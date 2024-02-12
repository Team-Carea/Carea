import json

from channels.generic.websocket import AsyncWebsocketConsumer
from channels.db import database_sync_to_async

from google.cloud import speech

from users.models import User
from chats.models import ChatRoom

class HelpConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        try:
            # URL 경로에서 채팅방 ID 추출
            self.room_id = self.scope["url_route"]["kwargs"]["room_id"]

            if not await self.check_room_exists(self.room_id):
                raise ValueError('채팅방이 존재하지 않습니다.')

            # channel layer에 저장할 그룹 이름
            self.room_group_name = f"help_{self.room_id}"

            # Join room group
            await self.channel_layer.group_add(self.room_group_name, self.channel_name)
            await self.accept()

        except ValueError as e:
            # 값 오류가 있을 경우 (예: 방이 존재하지 않음), 오류 메시지 보내고 연결 종료
            await self.send({'error': str(e)})
            await self.close()

    async def disconnect(self, close_code):
        try:
            # Leave room group
            await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

        except Exception as e:
            # 일반 예외 처리 (예: 오류 기록)
            pass

    # Receive message from WebSocket (클라이언트로부터)
    async def receive(self, text_data=None, bytes_data=None):
        try:
            # 그룹 이름 가져옴
            self.room_group_name = f"help_{self.room_id}"

            # 채팅방 가져오기
            room = await self.get_room(self.room_id)

            # 도움 제공자의 랜덤 생성한 문장인 경우
            # DB에 인증 문장 저장하고, 그룹에 문장 보내기
            if text_data:
                content = json.loads(text_data)

                # 수신된 JSON에서 필요한 정보 추출
                sentence = content['message']

                # 수신된 인증 문장 데이터베이스에 저장
                await self.save_sentence(room, sentence)

                # Send message to room group
                await self.channel_layer.group_send(
                    self.room_group_name, {
                        "type": "help_message",
                        "message": sentence
                    }
                )

            # 도움 요청자의 바이너리 음성 파일인 경우
            # STT 써서 랜덤 문장 비교 후 DB에 포인트 업데이트, 결과 프론트로 보내기
            elif bytes_data:
                transcription = await self.perform_stt(bytes_data)

                # 문장 비교
                if transcription == room.sentence:
                    # 성공 시 유저 경험치 상승
                    await self.increase_points(room)

                    # Send message to room group
                    await self.channel_layer.group_send(
                        self.room_group_name, {
                            "type": "help_message",
                            "message": "성공: 문장 일치"
                        }
                    )

                else:
                    # 실패 시 음성 파일 다시 보내라는 메시지 전송
                    # Send message to room group
                    await self.channel_layer.group_send(
                        self.room_group_name, {
                            "type": "help_message",
                            "message": "실패: 문장 불일치"
                        }
                    )

        except ValueError as e:
            # 값 오류 처리
            await self.send(text_data=json.dumps({'error': str(e)}))

    # Receive message from room group
    async def help_message(self, event):
        try:
            message = event['message']

            # Send message to WebSocket (클라이언트로)
            await self.send(text_data=json.dumps({"message": message}))

        except Exception as e:
            # 일반 예외 처리
            await self.send(text_data=json.dumps({'error': '메시지 전송 실패'}))

    async def perform_stt(self, bytes_data):
        client = speech.SpeechClient()

        audio = speech.RecognitionAudio(content=bytes_data)
        config = speech.RecognitionConfig(
            encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
            language_code="ko-KR",
            audio_channel_count=2,
        )

        # 음성 -> 텍스트
        response = client.recognize(config=config, audio=audio)
        transcription = response.results[0].alternatives[0].transcript

        return transcription

    @database_sync_to_async
    def check_room_exists(self, room_id):
        return ChatRoom.objects.filter(id=room_id).exists()

    @database_sync_to_async
    def get_room(self, room_id):
        try:
            room = ChatRoom.objects.get(id=room_id)
            return room
        except ChatRoom.DoesNotExist:
            raise ValueError("채팅방이 존재하지 않습니다.")

    @database_sync_to_async
    def save_sentence(self, room, sentence):
        if not sentence:
            raise ValueError("인증 문장이 필요합니다.")

        # 채팅방 인증 문장 저장
        room.sentence = sentence
        room.save()

    @database_sync_to_async
    def increase_points(self, room):
        if not room:
            raise ValueError("채팅방 정보가 필요합니다.")

        # 유저 경험치 상승
        helped = User.objects.get(id=room.helped)
        helped.point += 5
        helped.save()

        helper = User.objects.get(id=room.helper.id)
        helper.point += 10
        helper.save()
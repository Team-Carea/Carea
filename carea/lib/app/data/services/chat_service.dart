import 'dart:convert';
import 'package:carea/app/common/const/config.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:carea/app/data/models/chat_message_list_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final List<types.Message> messages = [];
  final String roomId;
  late WebSocketChannel channel;
  bool isWebSocketInitialized = false;
  Function? onMessageCallback;

  ChatService({required this.roomId});

  void initializeWebsocket() async {
    final accessToken = await AuthStorage.getAccessToken();
    // 웹소켓 연결 초기화
    channel = IOWebSocketChannel.connect(
        'ws://${AppConfig.localHost}/${AppConfig.chatRoomUrl}/$roomId?token=$accessToken');
    isWebSocketInitialized = true;

    // 웹소켓을 통해 서버로부터의 이벤트 수신 대기
    channel.stream.listen((event) {
      onMessageReceived(event, onMessageCallback);
    });
  }

  // 웹소켓 통해 메시지 전송
  void addMessage(ChatMessage message) {
    if (isWebSocketInitialized) {
      final messagePayload = jsonEncode({
        'message': message.message,
      });
      channel.sink.add(messagePayload);
    }
  }

  // 메시지 수신 처리
  void onMessageReceived(response, Function? callback) {
    // 내가 보낸 메시지에 대한 서버측의 응답일 경우
    if (response[0] == '{') {
      print(response);
    }
    // 다른 사람으로부터 받은 메시지일 경우
    // TODO: ui코드의 messages리스트에 '상대방'의 메시지임을 나타내는 형태로 추가하고, setState하기

    else {
      // 상대방으로부터 전송받은 내용으로 채팅방의 마지막 메시지를 변경하기 위한 부분
      if (callback != null) {
        // 응답받고 ChatMessage 객체 만들어서 추가하기
        //     final newMessage = ChatMessage(
        //     id: const Uuid().hashCode,
        //     message: _controller.text,
        //     createdAt: DateTime.now().toString(),
        //     user: currentUserId);
        // messages.add(newMessage); // 여기서 callback(message); ?
        print(response);
      }
      // messages.first = (messages.first as types.TextMessage).copyWith(
      //     text: (messages.first as types.TextMessage).text + response);
    }
  }

  // 웹소켓 연결 종료
  void dispose() {
    channel.sink.close();
  }
}

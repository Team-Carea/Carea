import 'dart:convert';
import 'package:carea/app/common/const/config.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:carea/app/data/models/chat_message_list_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final String roomId;
  final int opponentUserId;
  ChatService({required this.roomId, required this.opponentUserId});

  final List<types.Message> messages = [];
  late WebSocketChannel channel;
  bool isWebSocketInitialized = false;
  Function? onMessageCallback;

  void initializeWebsocket() async {
    final accessToken = await AuthStorage.getAccessToken();
    // 웹소켓 연결 초기화
    channel = IOWebSocketChannel.connect(
        'ws://${AppConfig.localHost}/${AppConfig.chatRoomUrl}/$roomId?token=$accessToken');
    isWebSocketInitialized = true;

    // 웹소켓을 통해 서버로부터의 이벤트 수신 대기
    channel.stream.listen((event) {
      onMessageReceived(event);
    });
  }

  // 웹소켓 통해 메시지 전송
  void sendMessage(ChatMessage message) {
    if (isWebSocketInitialized) {
      final messagePayload = jsonEncode({
        'message': message.message,
      });
      channel.sink.add(messagePayload);
    } else {
      print("WebSocket is not initialized.");
    }
  }

  // 메시지 수신 처리
  void onMessageReceived(response) {
    response = jsonDecode(response);
    final newMessage = ChatMessage.fromWebSocketJson(response);

    // 다른 사람으로부터 받은 메시지일 때만 처리
    if (newMessage.user == opponentUserId && onMessageCallback != null) {
      onMessageCallback!(newMessage);
    }
  }

  // 웹소켓 연결 종료
  void dispose() {
    channel.sink.close();
  }
}

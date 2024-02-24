import 'dart:convert';

import 'package:carea/app/common/const/config.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:carea/app/data/models/gemini_data_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HelpConfirmService {
  late WebSocketChannel channel;
  bool isInitialized = false;
  Function? onMyResponse;
  Function? onOtherResponse;

  Future<void> initializeWebsocket(String roomId) async {
    final accessToken = await AuthStorage.getAccessToken();
    channel = IOWebSocketChannel.connect(
        'ws://${AppConfig.localHost}/${AppConfig.nearHelpSttUrl}/$roomId?token=$accessToken');

    isInitialized = true;
    channel.stream.listen((event) {
      final response = jsonDecode(event);
      print(response);
      // TODO: 응답값에 따라 다른 함수 실행하도록 코드 변경.
      // 인증문장 송수신 관련 기능
      noticeSentenceResponse(response);
      // 인증완료 메시지 송수신 관련 기능
      noticeConfirmResponse(response);
    });
  }

  void sendSentence(String sentence) {
    if (isInitialized) {
      final sentencePayload = jsonEncode({
        'type': 'text',
        'message': sentence,
      });
      channel.sink.add(sentencePayload);
    } else {
      print("WebSocket is not initialized.");
    }
  }

  // 인증완료 메시지 전송을 위한 함수
  void sendConfirmation(String sentence) {
    if (isInitialized) {
      final sentencePayload = jsonEncode({
        'type': 'text',
        'message': sentence,
      });
      channel.sink.add(sentencePayload);
    }
  }

  void noticeSentenceResponse(response) {
    if (onMyResponse != null) {
      onMyResponse!();
    }
    if (onOtherResponse != null) {
      final receivedSentence = GeminiResponseModel.fromWebSocketJson(response);
      onOtherResponse!(receivedSentence.text);
    }
  }

  // 인증완료 메시지 송수신
  void noticeConfirmResponse(response) {}

  void dispose() {
    if (isInitialized) {
      channel.sink.close();
    }
  }
}

import 'dart:convert';

import 'package:carea/app/common/const/config.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:carea/app/data/models/gemini_data_model.dart';
import 'package:carea/app/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HelpConfirmWebSocketService {
  late WebSocketChannel channel;
  bool isInitialized = false;
  Function? onMySentenceResponse;
  Function? onSentenceResponse;
  Function? onConfimResponse;

  Future<void> initializeWebsocket(String roomId) async {
    final accessToken = await AuthStorage.getAccessToken();
    channel = IOWebSocketChannel.connect(
        'ws://${AppConfig.localHost}/${AppConfig.nearHelpSttUrl}/$roomId?token=$accessToken');

    isInitialized = true;
    channel.stream.listen((event) {
      final response = jsonDecode(event);
      if (response['message'] == '인증완료') {
        // 인증완료 메시지 송수신 관련 기능
        noticeConfirmResponse(response);
      } else {
        // 인증문장 송수신 관련 기능
        noticeSentenceResponse(response);
      }
    });
  }

  void sendSentence(String sentence) {
    if (isInitialized) {
      final sentencePayload = jsonEncode({'message': sentence});
      channel.sink.add(sentencePayload);
    } else {
      print("WebSocket is not initialized.");
    }
  }

  // 인증완료 메시지 전송을 위한 함수
  void sendConfirmation() {
    if (isInitialized) {
      final sentencePayload = jsonEncode({'message': '인증완료'});
      channel.sink.add(sentencePayload);
    }
  }

  void noticeSentenceResponse(response) {
    if (onMySentenceResponse != null) {
      onMySentenceResponse!();
    } else if (onSentenceResponse != null) {
      final receivedSentence = GeminiResponseModel.fromWebSocketJson(response);
      onSentenceResponse!(receivedSentence.text);
    }
  }

  // 인증완료 메시지 송수신
  void noticeConfirmResponse(response) {
    if (onConfimResponse != null) {
      onConfimResponse!();
    }
  }

  void dispose() {
    if (isInitialized) {
      channel.sink.close();
    }
  }
}

class HelpConfirmDioService {
  final Dio dio = Dio();

  // PATCH: 경험치 증가
  Future<PointInfo> getPoints(String roomId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final url =
        'http://${AppConfig.localHost}/${AppConfig.nearHelpUrl}/$roomId/points';
    try {
      final response = await dio.patch(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        PointInfoResponse pointInfoResponse =
            PointInfoResponse.fromJson(response.data);
        return pointInfoResponse.result!;
      } else {
        throw Exception('Failed to patch points');
      }
    } on DioException catch (e) {
      print(e.toString());
      throw Exception('Failed to  patch points');
    }
  }
}

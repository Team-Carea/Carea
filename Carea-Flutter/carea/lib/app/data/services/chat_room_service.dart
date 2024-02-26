import 'package:carea/app/common/util/auth_storage.dart';
import 'package:carea/app/data/models/chat_message_list_model.dart';
import 'package:carea/app/data/models/chat_room_list_model.dart';
import 'package:carea/app/data/models/role_response_model.dart';
import 'package:dio/dio.dart';
import 'package:carea/app/common/const/config.dart';

class ChatRoomService {
  final Dio dio = Dio();

  // GET: 채팅방 목록 조회
  Future<ChatRoomList> getChatRoomList() async {
    final accessToken = await AuthStorage.getAccessToken();
    try {
      final response = await dio.get(
        'http://${AppConfig.localHost}/${AppConfig.chatRoomListUrl}/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ChatRoomList.fromJson(response.data);
      } else {
        throw Exception('Failed to load chat room list');
      }
    } on DioException catch (e) {
      print(e.toString());
      throw Exception('Failed to load chat messages with DioError');
    }
  }

  // GET: 채팅 메시지 목록 조회
  Future<List<ChatMessage>> getChatMessages(String roomId) async {
    final accessToken = await AuthStorage.getAccessToken();
    try {
      final response = await dio.get(
        'http://${AppConfig.localHost}/chats/$roomId/messages/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        ChatMessageList chatMessages = ChatMessageList.fromJson(response.data);
        List<ChatMessage> chatMessageList = chatMessages.result!;
        return chatMessageList;
      } else {
        print('Failed to load chat messages');
        throw Exception('Failed to load chat messages');
      }
    } on DioException catch (e) {
      print(e.toString());
      throw Exception('Failed to load chat messages with DioError');
    }
  }

  // GET: 도움 요청자/제공자 판별
  Future<String> getUserType(String roomId) async {
    final accessToken = await AuthStorage.getAccessToken();

    try {
      final response = await dio.get(
        'http://${AppConfig.localHost}/${AppConfig.nearHelpUrl}/$roomId/identification',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final roleResponse = RoleResponse.fromJson(response.data);
        final roleResult = roleResponse.result;
        return roleResult!;
      } else {
        print('Failed to load chat messages');
        throw Exception('Failed to load chat messages');
      }
    } on DioException catch (e) {
      print(e.toString());
      throw Exception('Failed to load chat messages with DioError');
    }
  }
}

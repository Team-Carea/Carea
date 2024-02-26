import 'package:carea/app/data/models/chat_room_list_model.dart';
import 'package:carea/app/data/services/chat_room_service.dart';

class ChatRoomController {
  final ChatRoomService _chatRoomService = ChatRoomService();

  Future<ChatRoomList> fetchChatRooms() async {
    return await _chatRoomService.getChatRoomList();
  }
}

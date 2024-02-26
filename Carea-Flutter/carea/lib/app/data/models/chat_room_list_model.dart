class ChatRoomList {
  final bool isSuccess;
  final String message;
  final List<ChatRoom> result;

  ChatRoomList(
      {required this.isSuccess, required this.message, required this.result});

  factory ChatRoomList.fromJson(Map<String, dynamic> json) {
    return ChatRoomList(
      isSuccess: json['isSuccess'],
      message: json['message'],
      result:
          (json['result'] as List).map((i) => ChatRoom.fromJson(i)).toList(),
    );
  }
}

class ChatRoom {
  final int id;
  final int help;
  final String latestMessage;
  final DateTime updatedAt;
  final Opponent opponent;

  ChatRoom(
      {required this.id,
      required this.help,
      required this.latestMessage,
      required this.updatedAt,
      required this.opponent});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      help: json['help'],
      latestMessage: json['latest_message'],
      updatedAt: DateTime.parse(json['updated_at']),
      opponent: Opponent.fromJson(json['opponent']),
    );
  }
}

class Opponent {
  final int id;
  final String nickname;
  final String profileUrl;

  Opponent(
      {required this.id, required this.nickname, required this.profileUrl});

  factory Opponent.fromJson(Map<String, dynamic> json) {
    return Opponent(
      id: json['id'],
      nickname: json['nickname'],
      profileUrl: json['profile_url'],
    );
  }
}

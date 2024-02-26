class ChatMessageList {
  final bool isSuccess;
  final String message;
  final List<ChatMessage>? result;

  ChatMessageList(
      {required this.isSuccess, required this.message, this.result});

  factory ChatMessageList.fromJson(Map<String, dynamic> json) {
    return ChatMessageList(
      isSuccess: json['isSuccess'],
      message: json['message'],
      result: json['result'] != null
          ? (json['result'] as List)
              .map((i) => ChatMessage.fromJson(i))
              .toList()
          : null,
    );
  }
}

class ChatMessage {
  final int? id;
  final String message;
  final DateTime? createdAt;
  final int? user;

  ChatMessage({
    this.id,
    required this.message,
    this.createdAt,
    this.user,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      message: json['message'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      user: json['user'],
    );
  }

  factory ChatMessage.fromWebSocketJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'],
      user: json['user_id'],
      createdAt: DateTime.now(),
    );
  }
}

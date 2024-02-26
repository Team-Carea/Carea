import 'package:intl/intl.dart';

class Comment {
  int id;
  int postId;
  String content;
  String created_at;
  String nickname;
  String profileUrl;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.created_at,
    required this.nickname,
    required this.profileUrl,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    DateTime createdAt = DateTime.parse(json['created_at']);
    String formattedCreatedAt = DateFormat('yyyy-MM-dd').format(createdAt);

    return Comment(
        id: json['id'],
        postId: json['post_id'],
        content: json['content'],
        created_at: formattedCreatedAt,
        nickname: json['user']['nickname'],
        profileUrl: json['user']['profile_url']);
  }
}

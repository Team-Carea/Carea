import 'package:intl/intl.dart';

class Post {
  int id;
  String title;
  String content;
  String category;
  String created_at;
  String? updated_at;
  String nickname;
  String profileUrl;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.created_at,
    this.updated_at,
    required this.nickname,
    required this.profileUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    DateTime createdAt = DateTime.parse(json['created_at']);
    String formattedCreatedAt = DateFormat('yyyy-MM-dd').format(createdAt);
    String? formattedUpdatedAt;

    if (json['updated_at'] != null) {
      DateTime updatedAt = DateTime.parse(json['updated_at']);
      formattedUpdatedAt = DateFormat('yyyy-MM-dd').format(updatedAt);
    } else {
      formattedUpdatedAt = null;
    }

    return Post(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        category: json['category'],
        created_at: formattedCreatedAt,
        updated_at: formattedUpdatedAt,
        // user: json['user'],
        nickname: json['user']?['nickname'] ?? "undefined",
        profileUrl: json['user']['profile_url'] ?? "");
  }
}

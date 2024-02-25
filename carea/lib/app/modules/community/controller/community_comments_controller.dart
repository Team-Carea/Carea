import 'dart:async';
import 'package:carea/app/common/component/toast_popup.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

final Dio dio = Dio();

class Comment {
  int id;
  int postId;
  String content;
  String created_at;
  String nickname;

  Comment({
    required this.id,
    required this.postId,
    required this.content,
    required this.created_at,
    required this.nickname,
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
    );
  }
}

// 댓글 출력

class Comments {
  late List<Comment> _items;

  Comments() {
    _items = [];
    _items.sort((a, b) {
      return b.created_at.compareTo(a.created_at);
    });
  }

  Future<List<Comment>> fetchComments(String postId) async {
    final comments = Comments();
    await comments.getCommentDetail(postId);
    return comments.items;
  }

  List<Comment> get items => _items;

  Future<void> getCommentDetail(postId) async {
    final accessToken = await AuthStorage.getAccessToken();

    String baseUrl = 'http://10.0.2.2:8000/posts/$postId/comments/';
    try {
      final response = await dio.get(
        baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> extractedData = response.data;
        List<dynamic> result = extractedData['result'];
        final List<Comment> loadedComments = result.map((entry) {
          return Comment.fromJson(entry);
        }).toList();

        _items.sort((a, b) {
          return b.created_at.compareTo(a.created_at);
        });
        _items.addAll(loadedComments);
      } else {
        careaToast(toastMsg: '댓글이 출력되지 않았습니다');
      }
    } catch (error) {
      throw Exception();
    }
  }
}

// 댓글 등록

Future<void> postComment(int postId, String content, String nickname) async {
  final accessToken = await AuthStorage.getAccessToken();

  try {
    final response = await dio.post(
      'http://10.0.2.2:8000/posts/$postId/comments/',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
      data: {
        'post_id': postId,
        'content': content,
        'user': {
          'nickname': nickname,
        },
      },
    );
    if (response.statusCode == 201) {
      final jsonbody = response.data['result'];
      return;
    } else {
      careaToast(toastMsg: '댓글이 등록되지 않았습니다');
    }
  } catch (error) {
    throw Exception('Failed to post comment: $error');
  }
}

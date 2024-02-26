import 'dart:async';
import 'package:carea/app/common/component/toast_popup.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:carea/app/data/models/comment_model.dart';

final Dio dio = Dio();

// 댓글 출력

class Comments {
  Future<List<Comment>> fetchComments(String postId) async {
    return await getCommentDetail(int.parse(postId));
  }

  Future<List<Comment>> getCommentDetail(int postId) async {
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
        List<dynamic> result = response.data['result'];
        List<Comment> comments =
            result.map((commentData) => Comment.fromJson(commentData)).toList();
        return comments;
      } else {
        return [];
      }
    } catch (error) {
      throw Exception('Failed to load comments');
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

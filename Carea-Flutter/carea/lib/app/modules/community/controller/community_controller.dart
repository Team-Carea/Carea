import 'dart:async';
import 'package:carea/app/common/component/toast_popup.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:carea/app/data/models/post_model.dart';

final Dio dio = Dio();

class Posts {
  final List<Post> _items = [];

  List<Post> get items => _items;

  Future<void> fetchAndSetPosts(String category) async {
    _items.clear();

    if (category.isEmpty) {
      List<String> categories = [
        'latest',
        'free',
        'life',
        'economic',
        'future'
      ];
      await Future.wait(
          categories.map((category) => _fetchPostsForCategory(category)));
    } else {
      await _fetchPostsForCategory(category);
    }

    _items.sort((a, b) => b.created_at.compareTo(a.created_at));
  }

  Future<void> _fetchPostsForCategory(String category) async {
    final accessToken = await AuthStorage.getAccessToken();

    String baseUrl = 'http://10.0.2.2:8000/posts/$category/';
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
        final List<Post> loadedPosts =
            result.map((entry) => Post.fromJson(entry)).toList();
        _items.addAll(loadedPosts);
      } else {
        throw Exception(
            'Failed to fetch post with id, status code: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

// 게시글 상세 조회

  Future<Post> getPostDetail(int id) async {
    final accessToken = await AuthStorage.getAccessToken();

    String baseUrl = 'http://10.0.2.2:8000/posts/$id/';
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
        Map<String, dynamic> extractedData = response.data['result'];
        return Post.fromJson(extractedData);
      } else {
        throw Exception(
            'Failed to fetch post with id $id, status code: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}

// 게시글 등록

Future<void> createPost(String title, String content, String category) async {
  final accessToken = await AuthStorage.getAccessToken();

  String baseUrl = 'http://10.0.2.2:8000/posts/$category/';
  try {
    final response = await dio.post(
      baseUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
      data: {
        'title': title,
        'content': content,
        'category': category,
        'user': 1,
      },
    );
    if (response.statusCode == 201) {
      careaToast(toastMsg: '게시글이 작성되었습니다');
    } else {
      careaToast(toastMsg: '게시글 작성 중 오류가 생겼습니다');
    }
  } catch (error) {
    print('게시글 작성 중 오류가 발생했습니다: $error');
  }
}

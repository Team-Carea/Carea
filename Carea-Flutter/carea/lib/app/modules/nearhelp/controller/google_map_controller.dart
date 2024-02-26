import 'package:carea/app/common/component/toast_popup.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:location/location.dart';
import 'package:carea/app/common/util/auth_storage.dart';

Dio dio = Dio();
String googleApiKey = dotenv.get("GOOGLE_MAP_API_KEY");

class LocationService {
  Location location = Location();

  Future<LocationData?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }
}

// 도움 등록하기

Future<void> sendData(String title, String content, String address) async {
  final accessToken = await AuthStorage.getAccessToken();

  var url = 'http://10.0.2.2:8000/helps/';
  try {
    var response = await dio.post(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
      data: json.encode({
        'title': title,
        'content': content,
        'address': address,
      }),
    );
    if (response.statusCode == 201) {
      careaToast(toastMsg: '도움이 성공적으로 등록되었습니다.');
    }
  } catch (e) {
    throw ('Failed to send data: $e');
  }
}

// 도움 요청 표시하기

Future<List<Map<String, dynamic>>> getHelpData() async {
  final accessToken = await AuthStorage.getAccessToken();

  List<Map<String, dynamic>> places = [];
  const url = 'http://10.0.2.2:8000/helps/';
  try {
    var response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    if (response.statusCode == 200) {
      var extracted = response.data['result'];
      for (var item in extracted) {
        places.add({
          'id': item['id'].toString(),
          'latitude': double.parse(item['latitude']),
          'longitude': double.parse(item['longitude'])
        });
      }
      return places;
    } else {
      print('서버 에러: 상태 코드 ${response.statusCode}');
      return places;
    }
  } catch (e) {
    print('데이터 전송 실패: $e');
    careaToast(toastMsg: '오류가 발생했습니다');

    return places;
  }
}

// 상세 도움 표시하기

Future<Map<String, dynamic>> getHelpDataDetail(int id) async {
  final accessToken = await AuthStorage.getAccessToken();

  var url = 'http://10.0.2.2:8000/helps/$id';
  try {
    var response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    if (response.statusCode == 200) {
      var extracted = response.data['result'];
      DateTime parsedCreatedAt = DateTime.parse(extracted['created_at']);
      String formattedCreatedAt =
          '${DateFormat('yy-MM-dd').format(parsedCreatedAt)}에 올라온 글이에요';
      return {
        'profileImageUrl': extracted['user']['profile_url'],
        'nickname': extracted['user']['nickname'],
        'title': extracted['title'],
        'content': extracted['content'],
        'location': extracted['location'],
        'createdAt': formattedCreatedAt,
      };
    } else {
      print('서버 에러: 상태 코드 ${response.statusCode}');
      throw Exception('상세 정보 가져오기 실패');
    }
  } catch (e) {
    print('데이터 전송 실패: $e');
    careaToast(toastMsg: '오류가 발생했습니다');
    throw Exception('상세 정보 가져오기 실패');
  }
}

// 회원 정보 조회하기
Future<Map<String, dynamic>> getUserDetail() async {
  final accessToken = await AuthStorage.getAccessToken();

  var url = 'http://10.0.2.2:8000/users/user';
  try {
    var response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    if (response.statusCode == 200) {
      var extracted = response.data;
      print(extracted);
      return {
        'profileImageUrl': extracted['profile_url'],
        'nickname': extracted['nickname'],
      };
    } else {
      throw Exception('상세 정보 가져오기 실패');
    }
  } catch (e) {
    throw Exception('상세 정보 가져오기 실패');
  }
}

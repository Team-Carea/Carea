import 'package:carea/app/common/component/toast_popup.dart';
import 'package:carea/app/common/const/config.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:carea/app/data/models/user_model.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio dio = Dio();

  // POST: 회원가입
  Future<SignUpResult> signUp(User user) async {
    const url = 'http://${AppConfig.localHost}/${AppConfig.signUpUrl}/';
    final data = user.toJson();

    try {
      final response = await dio.post(url, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SignUpResult.fromJson(response.data);
      } else {
        throw Exception('Failed to signup: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to signup: $e');
    }
  }

  // POST: 로그인
  Future<bool> logIn(String email, String password) async {
    try {
      // 테스트 유저 '자준청' 정보: {"email": "careleaver@gmail.com", "password": "carealeaver123"}
      final response = await dio.post(
        'http://${AppConfig.localHost}/users/login/',
        data: {"email": email, "password": password},
      );

      final accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];

      AuthStorage.saveAccessToken(accessToken);
      AuthStorage.saveRefreshToken(refreshToken);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        careaToast(toastMsg: 'Failed to login: ${response.data}');
      }
    } catch (e) {
      careaToast(toastMsg: '아이디 또는 비밀번호가 틀렸습니다.');
    }
    return false;
  }

  // POST: 로그아웃
  Future<void> logOut(String refresh) async {
    const url = 'http://${AppConfig.localHost}/${AppConfig.logOutUrl}/';
    final data = {'refresh': refresh};

    try {
      final response = await dio.post(url, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('로그아웃 성공: ${response.data}');
      } else {
        throw Exception('Failed to logout: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // GET: 내 프로필 조회
  Future<UserProfile> getUserProfile(String accessToken) async {
    final accessToken = await AuthStorage.getAccessToken();
    const url = 'http://${AppConfig.localHost}/${AppConfig.profileUrl}/';
    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        print('프로필 조회 성공');
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }
}

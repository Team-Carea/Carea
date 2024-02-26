import 'package:carea/app/common/const/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = AppConfig.accessTokenKey;
  static const _refreshTokenKey = AppConfig.refreshTokenKey;

  // 액세스 토큰 키 저장
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // 액세스 토큰 키 검색
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // 액세스 토큰 키 삭제
  static Future<String?> delAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
    return null;
  }

  // 리프레시 토큰 키 저장
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  // 리프레시 토큰 키 검색
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // 리프레시 토큰 키 삭제
  static Future<String?> delRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
    return null;
  }
}

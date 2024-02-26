class AppConfig {
  static const String localHost = '10.0.2.2:8000';
  static const String apiHost = 'carea.app';
  static const String baseUrl = 'http://$localHost';
  // static const String baseUrl = 'https://$apiHost';
  static const String signInUrl = 'auth/signin';
  static const String signUpUrl = 'users/registration';
  static const String logOutUrl = 'users/logout';
  static const String googleSignInUrl = 'auth/google/login';
  static const String communityUrl = 'posts';
  static const String chatUrl = 'chats';
  static const String chatRoomListUrl = '$chatUrl/rooms';
  static const String chatRoomUrl = 'ws/$chatUrl';
  static const String nearHelpUrl = 'helps';
  static const String nearHelpSttUrl = 'ws/$nearHelpUrl/stt';
  static const String profileUrl = 'users/user';

  static const timeout = Duration(seconds: 5);
  static const splashTime = Duration(seconds: 2);
  static const String accessTokenKey = 'access';
  static const String refreshTokenKey = 'refresh';
}

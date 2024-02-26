class SignUpResult {
  final String accessToken;
  final String refreshToken;
  final UserProfile userProfile;

  SignUpResult({
    required this.accessToken,
    required this.refreshToken,
    required this.userProfile,
  });

  factory SignUpResult.fromJson(Map<String, dynamic> json) {
    return SignUpResult(
      accessToken: json['access'],
      refreshToken: json['refresh'],
      userProfile: UserProfile.fromJson(json['user']),
    );
  }
}

class User {
  final String email;
  final String password1;
  final String password2;
  final String nickname;
  final String? profileUrl;
  final String? introduction;

  User({
    required this.email,
    required this.password1,
    required this.password2,
    required this.nickname,
    this.profileUrl,
    this.introduction,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password1: json['password1'],
      password2: json['password2'],
      nickname: json['nickname'],
      profileUrl: json['profile_url'],
      introduction: json['introduction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password1': password1,
      'password2': password2,
      'nickname': nickname,
      'profile_url': profileUrl,
      'introduction': introduction,
    };
  }
}

class UserProfile {
  final int id;
  final String email;
  final String nickname;
  final String? profileUrl;
  final String? introduction;
  final int point;

  UserProfile({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileUrl,
    this.introduction,
    required this.point,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      profileUrl: json['profile_url'],
      introduction: json['introduction'],
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'profile_url': profileUrl,
      'introduction': introduction,
      'point': point,
    };
  }
}

class PointInfoResponse {
  bool isSuccess;
  String message;
  PointInfo? result;

  PointInfoResponse({
    required this.isSuccess,
    required this.message,
    this.result,
  });

  factory PointInfoResponse.fromJson(Map<String, dynamic> json) {
    return PointInfoResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      result: json['isSuccess'] ? PointInfo.fromJson(json['result']) : null,
    );
  }
}

class PointInfo {
  int increasedPoints;
  int userPoints;

  PointInfo({
    required this.increasedPoints,
    required this.userPoints,
  });

  factory PointInfo.fromJson(Map<String, dynamic> json) {
    return PointInfo(
      increasedPoints: json['increased_points'],
      userPoints: json['user_points'],
    );
  }
}

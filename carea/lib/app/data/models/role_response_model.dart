class RoleResponse {
  final bool isSuccess;
  final String message;
  final String? result;

  RoleResponse({
    required this.isSuccess,
    required this.message,
    this.result,
  });

  factory RoleResponse.fromJson(Map<String, dynamic> json) {
    return RoleResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      result: json['result'], // 성공 시 "seeker" 또는 "helper", 실패 시 null
    );
  }
}

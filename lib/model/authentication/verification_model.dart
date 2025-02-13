class VerificationModel {
  final String? message;
  final String? token;
  final bool? success;

  VerificationModel({
    this.message,
    this.token,
    this.success,
  });

  VerificationModel.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        success = json['success'] as bool,
        token = json['token'] as String?;

  Map<String, dynamic> toJson() => {
        'message': message,
        'token': token,
        'success': success,
      };
}

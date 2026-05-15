// ignore_for_file: always_specify_types
part of 'api.dart';

class ApiResponse<T> {
  int? statusCode;
  int? errorCode;
  String? message;
  dynamic data;

  ApiResponse._({
    this.statusCode,
    this.errorCode,
    this.message,
    this.data,
  });

  // Named constructor for success
  ApiResponse.success({
    String? message,
    int? statusCode,
    dynamic data,
  }) : this._(
          statusCode: statusCode ?? 200,
          message: message,
          data: data,
        );

  // Named constructor for failure
  ApiResponse.failure({
    String? message,
    int? errorCode,
    int? statusCode,
  }) : this._(
          statusCode: statusCode,
          errorCode: errorCode,
          message: message,
        );

  bool get succeeded => (statusCode == 200);

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse._(
        statusCode: json["status_code"] ?? json["httpStatusCode"],
        errorCode: json["error_code"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        if (errorCode != null) "error_code": errorCode,
        "message": message,
        "data": data,
      };
}

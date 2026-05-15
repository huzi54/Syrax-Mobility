import 'package:imo_mobility/core/api/auth/model/login_response.dart';

import '../../constants/constants.dart';
import '../api.dart';

class LoginApiService {
  LoginApiService._();
  static final LoginApiService instance = LoginApiService._();

  final String loginApiBase = '/auth';
  final String loginEndpoint = '/resident-login';

  Future<ApiResponse<LoginData>> login({
    required String phone,
    required String password,
  }) async {
    final ApiResponse response = await ApiService.apiCall(
      method: HttpMethod.post,
      endPoint: loginApiBase + loginEndpoint,
      dataMap: <String, dynamic>{'phone': phone, 'password': password},
    );

    if (response.succeeded && response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;
      final userData = responseData['data'] as Map<String, dynamic>?;

      if (userData != null) {
        final loginData = LoginData.fromJson(userData);
        return ApiResponse.success(data: loginData, message: response.message);
      }
    }

    return ApiResponse.failure(
      message: response.message ?? 'Login failed',
      errorCode: response.errorCode,
      statusCode: response.statusCode,
    );
  }
}

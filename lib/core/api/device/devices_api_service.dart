// ignore_for_file: always_specify_types

part of '../api.dart';

class DevicesApiService {
  DevicesApiService._();

  static const devicesApiBase = '/devices';

  /// Register device token with backend for push notifications.
  /// Returns ApiResponse indicating success or failure with detailed message.
  static Future<ApiResponse<void>> registerDevice({
    required String platform,
    required String deviceToken,
  }) async {
    try {
      final ApiResponse response = await ApiService.apiCall(
        method: HttpMethod.post,
        endPoint: '$devicesApiBase/register',
        dataMap: {'platform': platform, 'device_token': deviceToken},
        // Do not show a generic error snackbar for silent registration failures;
        // let the caller handle user-visible messaging if desired.
        showErrorMessage: false,
        showSuccessMessage: false,
      );

      if (response.succeeded) {
        return ApiResponse.success(
          message: response.message ?? 'Device registered successfully',
        );
      }

      return ApiResponse.failure(
        message: response.message ?? 'Failed to register device',
        errorCode: response.errorCode,
        statusCode: response.statusCode,
      );
    } catch (e) {
      ApiLogBeautifier.logError(
        '$devicesApiBase/register',
        e.toString(),
        exception: true,
        exceptionMessage: e.toString(),
      );
      return ApiResponse.failure(
        message: 'Failed to register device: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}

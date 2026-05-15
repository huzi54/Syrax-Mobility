part of '../api.dart';

/// Simple bearer token interceptor helper.
/// Reads the token from secure storage via AppDataService and exposes a
/// method to attach authorization headers to a headers map.
class BearerApiInterceptor {
  BearerApiInterceptor._();

  /// Reads the saved user token (secure storage key from AppDataKeys) and,
  /// if present, returns a map with the Authorization header.
  static Future<Map<String, String>> authHeaders() async {
    try {
      final String? token =
          await AppDataKeys.userToken.getFromSecure<String>();
      if (token != null && token.isNotEmpty) {
        return <String, String>{'Authorization': 'Bearer $token'};
      }
    } catch (_) {
      // ignore errors and return empty headers
    }
    return <String, String>{};
  }
}

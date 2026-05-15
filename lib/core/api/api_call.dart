// ignore_for_file: always_specify_types

part of 'api.dart';

class ApiService {
  ApiService._();

  static final ApiService _instance = ApiService._();

  factory ApiService() {
    return _instance;
  }
  static Future<ApiResponse> apiCall({
    required HttpMethod method,
    required String endPoint,
    Map<String, dynamic>? dataMap,
    Map<String, String>? queryParams,
    File? file,
    String? fileFieldName,
    final bool useRegisterToken = false,
    final bool forceMultipart = false,
    bool showSuccessMessage = false,
    bool showErrorMessage = true,
    final String? errorMessage,
    final String? successMessage,
  }) async {
    final Uri uri;

    if (queryParams == null) {
      uri = Uri.parse("${ApiEndpoints.baseUrl}$endPoint");
    } else {
      uri = Uri.parse(
        "${ApiEndpoints.baseUrl}$endPoint",
      ).replace(queryParameters: queryParams);
    }

    final String url = uri.toString();

    if (!await _checkInternetConnectivity()) {
      ApiLogBeautifier.logError(url, 'No internet connection');
      AppSnackBar.error('No internet connection');
      return ApiResponse.failure(
        message: "No internet connection",
        statusCode: 500,
      );
    }

    try {
      final Map<String, String> headers = {
        'accept': 'application/json',
        "Content-Type": (file != null || forceMultipart)
            ? "multipart/form-data"
            : "application/json",
      };

      dynamic request;

      if (file != null || forceMultipart) {
        request = http.MultipartRequest(method.name, uri);
        if (dataMap != null) {
          // Only add fields that are not null (allow empty string if explicitly set)
          dataMap.forEach((key, value) {
            if (value != null) {
              request.fields[key] = value.toString();
            }
          });
        }
        // Do NOT set Content-Type for multipart, http.MultipartRequest will handle it
      } else {
        request = http.Request(method.value, uri);
        request.body = jsonEncode(dataMap);
        request.headers.addAll({"Content-Type": "application/json"});
      }

      // Attach base headers
      request.headers.addAll(headers);
      // Attach Authorization header if token present
      try {
        final Map<String, String> auth =
            await BearerApiInterceptor.authHeaders();
        if (auth.isNotEmpty) {
          request.headers.addAll(auth);
        }
      } catch (_) {
        // ignore failures to attach auth
      }
      ApiLogBeautifier.logRequest(
        url,
        dataMap ?? {},
        queryParams ?? {},
        request.headers,
      );

      http.StreamedResponse response = await request.send();
      String data = await response.stream.bytesToString();
      ApiLogBeautifier.logResponse(url, response.statusCode, data);
      // Handle explicit unauthorized immediately (e.g., expired signature/token)
      if (response.statusCode == 401 || response.statusCode == 403) {
        // Try to parse message to confirm expiration, but even without it,
        // we consider 401 as session invalid and redirect.
        try {
          final String body = data;
          final dynamic decoded = body.isNotEmpty ? jsonDecode(body) : null;
          final String? msg = decoded is Map<String, dynamic>
              ? (decoded['message'] as String?)
              : null;
          if (msg != null && msg.toLowerCase().contains('expired')) {
            // emit and return failure
            SessionEvents.emitSessionExpired();
          } else {
            // still treat as invalid session
            SessionEvents.emitSessionExpired();
          }
        } catch (_) {
          SessionEvents.emitSessionExpired();
        }
        return ApiResponse.failure(message: 'Unauthorized', statusCode: 401);
      }

      if (response.statusCode == 200) {
        if (showSuccessMessage) {
          AppSnackBar.info(successMessage ?? 'Success');
        }
        return ApiResponse.success(
          message: 'Success',
          statusCode: 200,
          data: jsonDecode(data),
        );
      }

      ApiResponse apiResponse;
      try {
        final dynamic decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          apiResponse = ApiResponse.fromJson(decoded);
        } else if (decoded is List) {
          // Server returned a raw JSON list (for example: [ { ... }, ... ])
          // Wrap it as a successful ApiResponse so callers can consume
          // the list via ApiResponse.data.
          apiResponse = ApiResponse.success(
            data: decoded,
            statusCode: response.statusCode,
          );
        } else {
          // Unexpected JSON type
          ApiLogBeautifier.logError(
            url,
            'Invalid JSON response type: ${decoded.runtimeType}',
            exception: true,
            exceptionMessage: 'Expected Map or List',
          );
          if (showErrorMessage) {
            AppSnackBar.error('Invalid server response');
          }
          return ApiResponse.failure(
            message: 'Invalid server response',
            statusCode: response.statusCode,
          );
        }
      } catch (e) {
        ApiLogBeautifier.logError(
          url,
          'Invalid JSON response: $data',
          exception: true,
          exceptionMessage: e.toString(),
        );
        if (showErrorMessage) {
          AppSnackBar.error('Invalid server response');
        }
        return ApiResponse.failure(
          message: 'Invalid server response',
          statusCode: response.statusCode,
        );
      }

      if (apiResponse.succeeded) {
        if (showSuccessMessage) {
          AppSnackBar.info(successMessage ?? apiResponse.message ?? 'Success');
        }
        return apiResponse;
      }

      // Handle error codes and error messages
      if (apiResponse.statusCode == 401 || apiResponse.errorCode == 401) {
        // Token/signature expired via API-level envelope
        SessionEvents.emitSessionExpired();
        return ApiResponse.failure(
          message: apiResponse.message ?? 'Unauthorized',
          statusCode: 401,
        );
      } else if (apiResponse.statusCode == 400 ||
          apiResponse.errorCode == 400) {
        if (apiResponse.data is Map<String, dynamic> &&
            apiResponse.data['errors'] != null) {
          final firstError = apiResponse.data['errors'][0];
          AppSnackBar.error(errorMessage ?? firstError['message']);
        } else if (showErrorMessage) {
          AppSnackBar.error(errorMessage ?? apiResponse.message ?? 'Error');
        }
        ApiLogBeautifier.logError(url, apiResponse.message ?? '');
      } else if (showErrorMessage) {
        AppSnackBar.error(errorMessage ?? apiResponse.message ?? 'Error');
        ApiLogBeautifier.logError(url, apiResponse.message ?? '');
      }

      return apiResponse;
    } catch (e) {
      ApiLogBeautifier.logError(
        url,
        e.toString(),
        exception: true,
        exceptionMessage: e.toString(),
      );
      AppSnackBar.error('An Error Occurred');
      return ApiResponse.failure(message: e.toString(), statusCode: 500);
    }
  }

  static Future<Map<String, String>> get apiHeader async => {
    ...(await BearerApiInterceptor.authHeaders()),
    "Content-Type": "application/json",
  };

  static Future<bool> _checkInternetConnectivity() async {
    final List<ConnectivityResult> connectivityResults = await Connectivity()
        .checkConnectivity();
    return connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );
  }
}

class ApiLogBeautifier {
  static void logRequest(
    String url,
    Map<String, dynamic> dataMap,
    Map<String, dynamic> queryParams,
    Map<String, String>? headers,
  ) {
    log("============ API REQUEST ============");
    log("URL: $url");
    log("Headers: ${headers.toString()}");
    log("Query Param: ${queryParams.toString()}");
    log("Input Data: ${dataMap.toString()}");
    log("==================================\n\n");
  }

  static void logResponse(String url, int statusCode, String? data) {
    log("============ API RESPONSE ============");
    log("URL: $url");
    log("Status Code: $statusCode");
    if (data != null && data.isNotEmpty) {
      try {
        final dynamic decoded = jsonDecode(data);
        final String prettyJson = const JsonEncoder.withIndent(
          '  ',
        ).convert(decoded);
        log("Response Data :\n$prettyJson");
      } catch (e) {
        log("Response Data: $data");
      }
    } else {
      log("Response Data: $data");
    }
    log("====================================\n\n");
  }

  static void logError(
    String url,
    String error, {
    bool exception = false,
    String exceptionMessage = '',
  }) {
    log("============ API ERROR ===============");
    log("URL: $url");
    if (exception) {
      log("Exception: Occurred");
      log("Exception: $exceptionMessage");
    } else {
      log("Error: $error");
      log("===================================\n\n");
    }
  }
}

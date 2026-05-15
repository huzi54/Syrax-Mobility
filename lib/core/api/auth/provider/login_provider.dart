import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../shared/services/data/save_login_data.dart';
import '../model/login_response.dart';

import '../../api.dart';
import '../login_api_service.dart';

class LoginState {
  final bool isLoading;
  final LoginData? data;
  final String? error;

  LoginState({this.isLoading = false, this.data, this.error});

  LoginState copyWith({bool? isLoading, LoginData? data, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}

class LoginNotifier extends StateNotifier<bool> {
  Ref ref;
  LoginNotifier(this.ref) : super(false);

  Future<ApiResponse<LoginData>?> login(
    String phone,
    String password, {
    bool rememberMe = false,
  }) async {
    /// 🔴 Agar already loading hai to dobara call mat karo
    if (state) return null;

    state = true; // start loading

    final response = await LoginApiService.instance.login(
      phone: phone,
      password: password,
    );

    state = false; // stop loading

    if (response.succeeded && response.data != null) {
      await saveLoginData(response.data);

      await LoginDataService.handleRememberMe(
        rememberMe: rememberMe,
        phone: response.data?.phone,
      );

      return response;
    }

    return null;
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, bool>(
  (Ref ref) => LoginNotifier(ref),
);

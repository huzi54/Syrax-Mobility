// Location: lib/features/auth/presentation/providers/login_provider.dart

import 'package:flutter_riverpod/legacy.dart';
import 'package:imo_mobility/module/auth/model/login_model.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  void updateEmail(String email) {
    state = state.copyWith(email: email, errorMessage: null);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password, errorMessage: null);
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);
    // Handle navigation here via ref.listen in UI
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

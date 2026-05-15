import 'package:flutter_riverpod/legacy.dart';

import 'reset_password_state.dart';

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier() : super(const ResetPasswordState());

  void updateNewPassword(String password) =>
      state = state.copyWith(newPassword: password, errorMessage: null);
  void updateConfirmPassword(String password) =>
      state = state.copyWith(confirmPassword: password, errorMessage: null);

  Future<void> submitNewPassword() async {
    if (state.newPassword != state.confirmPassword) {
      state = state.copyWith(errorMessage: 'Passwords do not match');
      return;
    }
    if (state.newPassword.length < 6) {
      state = state.copyWith(
        errorMessage: 'Password must be at least 6 characters',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate API call to update password
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false, isPasswordSet: true);
  }
}

final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>((ref) {
      return ResetPasswordNotifier();
    });

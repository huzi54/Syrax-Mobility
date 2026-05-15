// Location: lib/features/auth/presentation/providers/reset_password_state.dart
import 'package:flutter/foundation.dart';

@immutable
class ResetPasswordState {
  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final bool isPasswordSet;
  final String? errorMessage;

  const ResetPasswordState({
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.isPasswordSet = false,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    bool? isPasswordSet,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isPasswordSet: isPasswordSet ?? this.isPasswordSet,
      errorMessage: errorMessage,
    );
  }
}

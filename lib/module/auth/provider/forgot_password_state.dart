// Location: lib/features/auth/presentation/providers/forgot_password_state.dart
import 'package:flutter/foundation.dart';

@immutable
class ForgotPasswordState {
  final String email;
  final bool isLoading;
  final bool isEmailSent;
  final String? errorMessage;

  const ForgotPasswordState({
    this.email = '',
    this.isLoading = false,
    this.isEmailSent = false,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    String? email,
    bool? isLoading,
    bool? isEmailSent,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isEmailSent: isEmailSent ?? this.isEmailSent,
      errorMessage: errorMessage,
    );
  }
}

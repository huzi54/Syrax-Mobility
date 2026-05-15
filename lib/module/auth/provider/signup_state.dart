// Location: lib/features/auth/presentation/providers/signup_state.dart
import 'package:flutter/foundation.dart';

@immutable
class SignupState {
  final String name;
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;

  const SignupState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
  });

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

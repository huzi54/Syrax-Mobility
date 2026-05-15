// Location: lib/features/auth/presentation/providers/forgot_password_provider.dart

import 'package:flutter_riverpod/legacy.dart';
import 'package:imo_mobility/module/auth/views/otp_screen.dart';
import 'package:imo_mobility/routes/route.dart';

import 'forgot_password_state.dart';

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier() : super(const ForgotPasswordState());

  void updateEmail(String email) =>
      state = state.copyWith(email: email, errorMessage: null);

  Future<void> sendResetLink() async {
    if (state.email.isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your email');

      return;
    } else {
      AppNavigation.push(OtpScreen(phoneNumber: state.email));
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isEmailSent: false,
    );

    // Simulate API call to send reset email
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false, isEmailSent: true);
  }
}

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
      return ForgotPasswordNotifier();
    });

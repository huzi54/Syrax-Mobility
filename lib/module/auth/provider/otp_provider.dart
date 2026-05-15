// Location: lib/features/auth/presentation/providers/otp_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../routes/route.dart';
import '../views/reset_password_screen.dart';
import 'otp_state.dart';

class OtpNotifier extends StateNotifier<OtpState> {
  Timer? _timer;

  OtpNotifier() : super(const OtpState()) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(resendTimer: 30, errorMessage: null);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendTimer > 0) {
        state = state.copyWith(resendTimer: state.resendTimer - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  void updateOtp(String code) {
    state = state.copyWith(otpCode: code, errorMessage: null);
  }

  Future<void> verifyOtp() async {
    if (state.otpCode.length < 4) {
      state = state.copyWith(errorMessage: 'Please enter a 4-digit code');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false, isVerified: true);
    // Handle navigation to next screen here
    AppNavigation.push(ResetPasswordScreen());
  }

  void resendOtp() {
    // Logic to request new OTP from backend
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final otpProvider = StateNotifierProvider<OtpNotifier, OtpState>((ref) {
  return OtpNotifier();
});

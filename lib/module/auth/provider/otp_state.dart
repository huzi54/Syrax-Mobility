// Location: lib/features/auth/presentation/providers/otp_state.dart
import 'package:flutter/foundation.dart';

@immutable
class OtpState {
  final String otpCode;
  final bool isLoading;
  final bool isVerified;
  final int resendTimer;
  final String? errorMessage;

  const OtpState({
    this.otpCode = '',
    this.isLoading = false,
    this.isVerified = false,
    this.resendTimer = 30, // Initial timer value
    this.errorMessage,
  });

  OtpState copyWith({
    String? otpCode,
    bool? isLoading,
    bool? isVerified,
    int? resendTimer,
    String? errorMessage,
  }) {
    return OtpState(
      otpCode: otpCode ?? this.otpCode,
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      resendTimer: resendTimer ?? this.resendTimer,
      errorMessage: errorMessage,
    );
  }
}

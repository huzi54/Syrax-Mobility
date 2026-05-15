import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordState {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool showError;

  PasswordState({
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasLowercase = false,
    this.hasNumber = false,
    this.hasSpecialChar = false,
    this.showError = false,
  });

  PasswordState copyWith({
    bool? hasMinLength,
    bool? hasUppercase,
    bool? hasLowercase,
    bool? hasNumber,
    bool? hasSpecialChar,
    bool? showError,
  }) {
    return PasswordState(
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasNumber: hasNumber ?? this.hasNumber,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
      showError: showError ?? this.showError,
    );
  }
}

class PasswordNotifier extends Notifier<PasswordState> {
  @override
  PasswordState build() => PasswordState();

  /// Called on every text change
  void validatePassword(String password) {
    final minLength = password.length >= 6;
    final uppercase = password.contains(RegExp(r'[A-Z]'));
    final lowercase = password.contains(RegExp(r'[a-z]'));
    final number = password.contains(RegExp(r'[0-9]'));
    final specialChar = password.contains(RegExp(r'[!@#\$&*]'));

    // Logging missing conditions for developer
    if (!minLength) log('[Password Validation] Missing: At least 6 characters');
    if (!uppercase) log('[Password Validation] Missing: Uppercase letter');
    if (!lowercase) log('[Password Validation] Missing: Lowercase letter');
    if (!number) log('[Password Validation] Missing: Number');
    if (!specialChar) {
      log('[Password Validation] Missing: Special character (!@#\$&*)');
    }

    state = state.copyWith(
      hasMinLength: minLength,
      hasUppercase: uppercase,
      hasLowercase: lowercase,
      hasNumber: number,
      hasSpecialChar: specialChar,
      showError: false, // reset error while typing
    );
  }

  /// Called when user presses set password button
  void markError() {
    state = state.copyWith(showError: true);

    if (!state.hasMinLength ||
        !state.hasUppercase ||
        !state.hasLowercase ||
        !state.hasNumber ||
        !state.hasSpecialChar) {
      log('[Password Validation] User tried to submit invalid password');
      if (!state.hasMinLength) log(' - At least 6 characters missing');
      if (!state.hasUppercase) log(' - Uppercase letter missing');
      if (!state.hasLowercase) log(' - Lowercase letter missing');
      if (!state.hasNumber) log(' - Number missing');
      if (!state.hasSpecialChar) log(' - Special character missing');
    }
  }

  /// Check all conditions
  bool allValid() {
    return state.hasMinLength &&
        state.hasUppercase &&
        state.hasLowercase &&
        state.hasNumber &&
        state.hasSpecialChar;
  }

  void reset() {
    state = PasswordState(); // default empty state
  }
}

/// Provider
final passwordProvider = NotifierProvider<PasswordNotifier, PasswordState>(
  PasswordNotifier.new,
);

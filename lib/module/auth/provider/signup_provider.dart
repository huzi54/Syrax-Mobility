// Location: lib/features/auth/presentation/providers/signup_provider.dart

import 'package:flutter_riverpod/legacy.dart';

import 'signup_state.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(const SignupState());

  void updateName(String name) =>
      state = state.copyWith(name: name, errorMessage: null);
  void updateEmail(String email) =>
      state = state.copyWith(email: email, errorMessage: null);
  void updatePassword(String password) =>
      state = state.copyWith(password: password, errorMessage: null);

  Future<void> signup() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);
    // Handle navigation here via ref.listen in UI
  }
}

final signupProvider = StateNotifierProvider<SignupNotifier, SignupState>((
  ref,
) {
  return SignupNotifier();
});

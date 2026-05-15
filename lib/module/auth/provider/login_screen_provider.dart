import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gateline_resident_app/shared/services/data/app_data_keys.dart';

class LoginScreenState {
  final String email;
  final String password;

  LoginScreenState({this.email = '', this.password = ''});

  LoginScreenState copyWith({
    String? email,
    String? password,
    bool? isRememberMe,
  }) {
    return LoginScreenState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class LoginScreenNotifier extends Notifier<LoginScreenState> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  LoginScreenState build() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // _loadRememberedEmail();
    return LoginScreenState();
  }

  // Future<void> _loadRememberedEmail() async {
  //   final rememberedEmail = await AppDataKeys.rememberedemail
  //       .getFromPrefs<String>();
  //   if (rememberedEmail != null && rememberedEmail.isNotEmpty) {
  //     emailController.text = rememberedEmail;
  //     state = state.copyWith(email: rememberedEmail, isRememberMe: true);
  //   }
  // }

  void updateemail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }
}

final loginScreenProvider =
    NotifierProvider.autoDispose<LoginScreenNotifier, LoginScreenState>(
      () => LoginScreenNotifier(),
    );

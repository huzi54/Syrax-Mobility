import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/module/auth/provider/login_notifiesr.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/auth/views/forgot_password_screen.dart';
import 'package:imo_mobility/module/auth/views/signup_screen.dart';
import 'package:imo_mobility/module/bottom_nav_bar/view/app_btm_nav_bar.dart';
import 'package:imo_mobility/module/home/view/home_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/text_fields/app_txtfield.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart'; // Add this
import 'package:imo_mobility/core/localization/app_translations.dart'; // Add this
import '../../../core/constants/constants.dart';
import '../../../shared/widgets/buttons/app_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);
    final langCode = ref.watch(localeProvider).languageCode; // Watch language

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              100.verticalSpace,
              Image.asset('assets/images/app-logo.png', height: 60),
              const SizedBox(height: 48),

              // --- Title ---
              Text(
                AppTranslations.of(context, 'welcome_back', langCode),
                style: context.bodyLarge?.copyWith(
                  color: AppColors.bluePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),

              // --- Subtitle ---
              Text(
                AppTranslations.of(context, 'sign_in_subtitle', langCode),
                style: context.bodyMedium?.copyWith(
                  color: AppColors.black.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // --- Email Field ---
              AppTextFields(
                controller: emailController,
                hintText: AppTranslations.of(context, 'enter_email', langCode),
                prefixIcon: const Icon(Icons.email),
              ),

              const SizedBox(height: 16),

              // --- Password Field ---
              AppTextFields.password(
                controller: passwordController,
                hintText: AppTranslations.of(
                  context,
                  'enterPassword',
                  langCode,
                ),
              ),

              // --- Forgot Password ---
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    AppNavigation.push(const ForgotPasswordScreen());
                  },
                  child: Text(
                    AppTranslations.of(context, 'forgot_password', langCode),
                    style: context.bodyMedium?.copyWith(
                      color: AppColors.blueSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Login Button ---
              AppButtons.elevated(
                borderRadius: 100,
                size: const Size(double.infinity, 50),
                onPressed: () =>
                    AppNavigation.pushReplacement(const AppBottomNavBar()),
                backgroundColor: AppColors.orangePrimary,
                text: AppTranslations.of(context, 'login', langCode),
              ),

              const SizedBox(height: 32),

              // --- Sign Up Link ---
              _buildSignUpLink(context, langCode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context, String langCode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppTranslations.of(context, 'dont_have_account', langCode),
          style: context.bodyMedium?.copyWith(
            color: AppColors.black.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: () {
            AppNavigation.push(const SignupScreen());
          },
          child: Text(
            AppTranslations.of(context, 'sign_up', langCode),
            style: context.bodyMedium?.copyWith(
              color: AppColors.orangePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

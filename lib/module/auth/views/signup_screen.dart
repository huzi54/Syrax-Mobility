import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/shared/widgets/text_fields/app_txtfield.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart'; // Localization
import 'package:imo_mobility/core/localization/app_translations.dart'; // Localization

import '../../../core/constants/constants.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../provider/signup_provider.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);
    final langCode = ref.watch(localeProvider).languageCode; // Watch language

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.bluePrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // --- Title ---
              Text(
                AppTranslations.of(context, 'create_account', langCode),
                style: context.titleLarge?.copyWith(
                  color: AppColors.bluePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // --- Tagline ---
              Text(
                AppTranslations.of(context, 'signup_subtitle', langCode),
                style: context.titleMedium?.copyWith(
                  color: AppColors.black.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // --- Form Fields ---
              AppTextFields(
                controller: nameController,
                hintText: AppTranslations.of(
                  context,
                  'full_name_hint',
                  langCode,
                ),
              ),

              const SizedBox(height: 16),
              AppTextFields.email(
                controller: emailController,
                hintText: AppTranslations.of(context, 'enterEmail', langCode),
              ),
              const SizedBox(height: 16),
              AppTextFields.password(
                controller: passwordController,
                hintText: AppTranslations.of(
                  context,
                  'enterPassword',
                  langCode,
                ),
              ),

              const SizedBox(height: 32),

              // --- Signup Button ---
              AppButtons.elevated(
                borderRadius: 100,
                size: const Size(double.infinity, 50),
                onPressed: state.isLoading ? null : notifier.signup,
                backgroundColor: AppColors.orangePrimary,
                foregroundColor: AppColors.white,
                isLoading: state.isLoading,
                text: AppTranslations.of(context, 'sign_up_btn', langCode),
              ),
              const SizedBox(height: 32),

              // --- Login Link ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppTranslations.of(
                      context,
                      'already_have_account',
                      langCode,
                    ),
                    style: context.bodyMedium?.copyWith(
                      color: AppColors.black.withValues(alpha: 0.6),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      AppTranslations.of(context, 'log_in', langCode),
                      style: context.bodyMedium?.copyWith(
                        color: AppColors.orangePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/localization/app_translations.dart'; // Import
import 'package:imo_mobility/core/localization/locale_provider.dart'; // Import

import '../../../core/constants/constants.dart';
import '../../../core/extensions/context_extension.dart';

import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/text_fields/app_txtfield.dart';
import '../provider/reset_password_provider.dart';

class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordProvider);
    final notifier = ref.read(resetPasswordProvider.notifier);
    final langCode = ref.watch(localeProvider).languageCode; // Watch language

    // Controllers to manage input for custom AppTextFields
    final newPasswordController = TextEditingController(
      text: state.newPassword,
    );
    final confirmPasswordController = TextEditingController(
      text: state.confirmPassword,
    );

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
                AppTranslations.of(context, 'setup_new_password', langCode),
                style: context.headlineSmall?.copyWith(
                  color: AppColors.bluePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // --- Tagline ---
              Text(
                AppTranslations.of(
                  context,
                  'reset_password_subtitle',
                  langCode,
                ),
                style: context.bodyMedium?.copyWith(
                  color: AppColors.black.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // --- REQUIRED: AppTextFields ---
              AppTextFields.password(
                controller: newPasswordController,
                onChanged: notifier.updateNewPassword,
                hintText: AppTranslations.of(
                  context,
                  'enterPassword',
                  langCode,
                ),
              ),
              const SizedBox(height: 16),
              AppTextFields.password(
                controller: confirmPasswordController,
                onChanged: notifier.updateConfirmPassword,
                hintText: AppTranslations.of(
                  context,
                  'enterPassword',
                  langCode,
                ),
              ),

              const SizedBox(height: 32),

              // --- Update Button ---
              AppButtons.elevated(
                borderRadius: 100,
                size: const Size(double.infinity, 50),
                onPressed: state.isLoading ? null : notifier.submitNewPassword,
                backgroundColor: AppColors.orangePrimary,
                foregroundColor: AppColors.white,
                isLoading: state.isLoading,
                text: AppTranslations.of(context, 'update_password', langCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

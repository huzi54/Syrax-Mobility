import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/shared/widgets/text_fields/app_txtfield.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart'; // Localization
import 'package:imo_mobility/core/localization/app_translations.dart'; // Localization

import '../../../core/constants/constants.dart';
import '../../../routes/route.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../provider/forgot_password_provider.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgotPasswordProvider);
    final notifier = ref.read(forgotPasswordProvider.notifier);
    final langCode = ref.watch(localeProvider).languageCode; // Watch language

    TextEditingController emailController = TextEditingController();

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
                AppTranslations.of(context, 'forgot_password_title', langCode),
                style: context.titleLarge?.copyWith(
                  color: AppColors.bluePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // --- Tagline ---
              Text(
                AppTranslations.of(
                  context,
                  'forgot_password_subtitle',
                  langCode,
                ),
                style: context.bodyMedium?.copyWith(
                  color: AppColors.black.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // --- Form Field ---
              AppTextFields.email(
                controller: emailController,
                hintText: AppTranslations.of(context, 'enterEmail', langCode),
              ),

              const SizedBox(height: 32),

              // --- Send OTP Button ---
              AppButtons.elevated(
                borderRadius: 100,
                size: const Size(double.infinity, 50),
                onPressed: () =>
                    AppNavigation.push(OtpScreen(phoneNumber: state.email)),
                backgroundColor: AppColors.orangePrimary,
                isLoading: state.isLoading,
                text: AppTranslations.of(context, 'send_otp', langCode),
              ),

              if (state.isEmailSent) ...[
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    AppTranslations.of(context, 'reset_link_sent', langCode),
                    style: context.bodyMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';

import '../../../core/constants/constants.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../provider/otp_provider.dart';

class OtpScreen extends ConsumerWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(otpProvider);
    final notifier = ref.read(otpProvider.notifier);
    final langCode = ref.watch(localeProvider).languageCode;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: context.headlineSmall?.copyWith(
        color: AppColors.bluePrimary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.grayLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grayBorder),
      ),
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
            children: [
              const SizedBox(height: 16),

              // --- Title ---
              Text(
                AppTranslations.of(context, 'verify_phone', langCode),
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
                  'otp_subtitle',
                  langCode,
                ).replaceAll('@number', phoneNumber),
                textAlign: TextAlign.center,
                style: context.titleMedium?.copyWith(
                  color: AppColors.black.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // --- Pinput ---
              Pinput(
                length: 4,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: AppColors.blueSecondary),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: AppColors.grayLight,
                    border: Border.all(color: AppColors.bluePrimary),
                  ),
                ),
                onChanged: notifier.updateOtp,
                showCursor: true,
                onCompleted: (pin) => notifier.verifyOtp(),
              ),

              const SizedBox(height: 32),

              // --- Verify Button ---
              AppButtons.elevated(
                borderRadius: 100,
                size: const Size(double.infinity, 50),
                onPressed: state.isLoading || state.otpCode.length < 4
                    ? null
                    : notifier.verifyOtp,
                backgroundColor: AppColors.orangePrimary,
                isLoading: state.isLoading,
                text: AppTranslations.of(context, 'verify_btn', langCode),
              ),

              const SizedBox(height: 32),

              // --- Resend Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppTranslations.of(context, 'didnt_receive_code', langCode),
                    style: context.bodyMedium?.copyWith(
                      color: AppColors.black.withValues(alpha: 0.6),
                    ),
                  ),
                  GestureDetector(
                    onTap: state.resendTimer == 0 ? notifier.resendOtp : null,
                    child: Text(
                      state.resendTimer > 0
                          ? AppTranslations.of(
                              context,
                              'resend_in',
                              langCode,
                            ).replaceAll(
                              '@seconds',
                              state.resendTimer.toString(),
                            )
                          : AppTranslations.of(context, 'resend', langCode),
                      style: context.bodyMedium?.copyWith(
                        color: state.resendTimer == 0
                            ? AppColors.orangePrimary
                            : Colors.grey,
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

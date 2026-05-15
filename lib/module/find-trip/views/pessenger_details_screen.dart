// Location: lib/features/trips/presentation/screens/passenger_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/book%20ride/view/ticket_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../shared/widgets/text_fields/app_txtfield.dart';
import 'payment_screen.dart';

class PassengerDetailsScreen extends ConsumerStatefulWidget {
  final String price;
  const PassengerDetailsScreen({super.key, required this.price});

  @override
  ConsumerState<PassengerDetailsScreen> createState() =>
      _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState
    extends ConsumerState<PassengerDetailsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'passenger_details', langCode),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.of(
                context,
                'enter_passenger_information',
                langCode,
              ),
              style: context.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppTranslations.of(
                context,
                'provide_details_of_traveler',
                langCode,
              ),
              style: context.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // --- Full Name ---
            _label(AppTranslations.of(context, 'full_name', langCode)),
            AppTextFields(
              controller: _nameController,
              hintText: AppTranslations.of(
                context,
                'enter_full_name',
                langCode,
              ),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 20),

            // --- Email ---
            _label(AppTranslations.of(context, 'email_address', langCode)),
            AppTextFields.email(
              controller: _emailController,
              hintText: AppTranslations.of(context, 'enterEmail', langCode),
            ),
            const SizedBox(height: 20),

            // --- Phone Number ---
            _label(AppTranslations.of(context, 'phone_number', langCode)),
            AppTextFields(
              controller: _phoneController,
              hintText: AppTranslations.of(context, 'example_phone', langCode),
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            const SizedBox(height: 20),

            // --- ID Number ---
            _label(AppTranslations.of(context, 'id_passport_number', langCode)),
            AppTextFields(
              controller: _idController,
              hintText: AppTranslations.of(
                context,
                'enter_id_number',
                langCode,
              ),
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
            const SizedBox(height: 40),

            // --- Confirm Button ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  print("Proceeding with passenger: ${_nameController.text}");
                  AppNavigation.push(CardPaymentScreen(price: widget.price));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Builder(
                  builder: (context) {
                    // Screen width lein
                    double screenWidth = MediaQuery.of(context).size.width;

                    // Font size calculate karein (4.5% of screen width)
                    // clamp(min, max) ensure karega ke size 14 se chota na ho aur 20 se bada na ho
                    double responsiveFontSize = (screenWidth * 0.045).clamp(
                      14.0,
                      20.0,
                    );

                    return Text(
                      AppTranslations.of(context, 'confirm_details', langCode),
                      style: context.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Dynamic size yahan apply hoga
                      ),
                      maxLines: 1,
                      overflow: TextOverflow
                          .ellipsis, // Agar space kam ho to dots dikhaye
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

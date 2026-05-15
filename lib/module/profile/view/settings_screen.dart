import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import '../../../shared/widgets/text_fields/app_txtfield.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "Moctar Sahande");
    _emailController = TextEditingController(text: "moctar@sirax.com");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'edit_profile', langCode),
        titleColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // --- Profile Image Upload Section ---
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.orangePrimary,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: const AssetImage(
                        "assets/images/default-dp.png",
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.bluePrimary,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- Name Input ---
            Text(
              AppTranslations.of(context, 'full_name', langCode),
              style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppTextFields(
              controller: _nameController,
              hintText: AppTranslations.of(
                context,
                'enter_your_name',
                langCode,
              ),
              prefixIcon: const Icon(Icons.person_outline),
              onChanged: (value) {},
            ),

            const SizedBox(height: 20),

            // --- Email Input ---
            Text(
              AppTranslations.of(context, 'email_address', langCode),
              style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppTextFields.email(
              controller: _emailController,
              enabled: false,
              hintText: AppTranslations.of(context, 'enterEmail', langCode),
            ),

            const SizedBox(height: 40),

            // --- Update Button ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppTranslations.of(
                          context,
                          'profile_updated_successfully',
                          langCode,
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppTranslations.of(context, 'save_changes', langCode),
                  style: context.bodySmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

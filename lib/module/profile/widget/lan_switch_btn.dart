import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';

import '../../../core/extensions/context_extension.dart';

class LanguageToggleWidget extends ConsumerWidget {
  const LanguageToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final bool isFrench = locale.languageCode == 'fr';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (isFrench) {
          ref.read(localeProvider.notifier).state = const Locale('en');
        } else {
          ref.read(localeProvider.notifier).state = const Locale('fr');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.translate, color: AppColors.primaryColor, size: 22),
                const SizedBox(width: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFrench ? "Langue" : "Language",
                      style: context.headlineSmall?.copyWith(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isFrench ? "Français" : "English",
                      style: context.headlineSmall?.copyWith(
                        color: AppColors.greyColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.greyColor),
          ],
        ),
      ),
    );
  }
}

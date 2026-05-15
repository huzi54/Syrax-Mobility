// Location: lib/features/home/presentation/widgets/home_options_row.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';
import '../../../core/constants/constants.dart';

class HomeOptionsRow extends ConsumerWidget {
  const HomeOptionsRow({super.key, this.onOptionTap});

  final void Function(String option)? onOptionTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTranslations.of(context, 'explore_now', langCode),
          style: context.headlineSmall?.copyWith(
            color: AppColors.primaryColor,
            fontSize: 22,
          ),
        ),
        10.verticalSpace,
        Row(
          children: [
            // Trips card
            Expanded(
              child: HomeOptionCard(
                icon: SvgPicture.asset(
                  'assets/images/icons/trip.svg',
                  color: AppColors.bluePrimary,
                  height: 45,
                ),
                borderRadius: BorderRadius.circular(20),
                backgroundColor: AppColors.white,
                label: AppTranslations.of(context, 'trips', langCode),
                onTap: () => onOptionTap?.call("Trips"),
              ),
            ),
            8.horizontalSpace,
            // Find Coach card
            Expanded(
              child: HomeOptionCard(
                icon: SvgPicture.asset(
                  'assets/images/icons/bus.svg',
                  color: AppColors.orangePrimary,
                  height: 45,
                ),
                backgroundColor: AppColors.white,
                label: AppTranslations.of(context, 'find_coach', langCode),
                borderRadius: BorderRadius.circular(20),
                onTap: () => onOptionTap?.call("Find Coach"),
              ),
            ),
            8.horizontalSpace,
            // Track Parcel card
            Expanded(
              child: HomeOptionCard(
                icon: SvgPicture.asset(
                  'assets/images/icons/parcel.svg',
                  color: AppColors.bluePrimary,
                  height: 45,
                ),
                label: AppTranslations.of(context, 'track_parcel', langCode),
                borderRadius: BorderRadius.circular(20),
                backgroundColor: AppColors.white,
                onTap: () => onOptionTap?.call("Track Parcel"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// HomeOptionCard widget
class HomeOptionCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final double height;
  final Gradient? gradient;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const HomeOptionCard({
    super.key,
    required this.icon,
    required this.label,
    this.height = 110,
    this.gradient,
    this.backgroundColor,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        // Card ke andar thodi space deni chahiye taake content edges se na takraye
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.scaffoldColor,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          gradient: gradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            5.verticalSpace,
            // Text ko Flexible ya padding mein wrap karein
            Text(
              label,
              style: context.bodyLarge?.copyWith(
                color: (label == 'Find Coach' || label == 'Trouver un car')
                    ? AppColors.parcelBtnColor
                    : AppColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize:
                    13, // Choti screens ke liye 14 ki bajaye 13 behtar hai
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Text ko 2 lines allow karein
              overflow: TextOverflow
                  .ellipsis, // Agar phir bhi bada ho toh dots dikhaye
            ),
          ],
        ),
      ),
    );
  }
}

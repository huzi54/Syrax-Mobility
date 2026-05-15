import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/book%20ride/view/ticket_view_screen.dart';
import 'package:imo_mobility/shared/utils/app_snackbar.dart';
import 'package:imo_mobility/shared/widgets/buttons/app_button.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import '../../../routes/route.dart';
import '../provider/book_ride_provider.dart';
import '../widgets/date_selection_widget.dart';
import 'search_destination_screen.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';

class BusBookingScreen extends ConsumerWidget {
  const BusBookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'find_coach', langCode),
        backgroundColor: AppColors.primaryColor,
        titleColor: AppColors.white,
        showBackButton: false,
      ),
      backgroundColor: AppColors.scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: const [BusCard()]),
      ),
    );
  }
}

/// Main Card Widget
class BusCard extends ConsumerWidget {
  const BusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;
    final cityState = ref.watch(citySelectionProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          // BoxShadow(
          //   color: AppColors.blackColor.withValues(alpha: .1),
          //   blurRadius: 20,
          //   spreadRadius: 5,
          // ),
        ],
      ),
      child: Column(
        children: [
          // City Selection
          const CitySelection(),

          const SizedBox(height: 20),

          // Date Row
          const DateSelection(),

          const SizedBox(height: 30),

          // Search Button
          AppButtons.elevated(
            onPressed: () {
              if (cityState.fromCity == null && cityState.toCity == null) {
                AppSnackBar.error(
                  AppTranslations.of(
                    context,
                    'select_departure_and_arrival',
                    langCode,
                  ),
                );
                return;
              }

              if (cityState.fromCity == null) {
                AppSnackBar.error(
                  AppTranslations.of(
                    context,
                    'select_departure_city',
                    langCode,
                  ),
                );
                return;
              }

              if (cityState.toCity == null) {
                AppSnackBar.error(
                  AppTranslations.of(context, 'select_arrival_city', langCode),
                );
                return;
              }

              AppNavigation.push(
                TicketScreen(
                  fromSelectedRide: cityState.fromCity!,
                  toSelectedRide: cityState.toCity!,
                ),
              );
            },

            padding: EdgeInsets.all(1),
            text: AppTranslations.of(context, 'search_now', langCode),
            // size: const Size(150, 50),
            backgroundColor: AppColors.orangePrimary,
            foregroundColor: AppColors.white,
          ),
        ],
      ),
    );
  }
}

/// City Selection with Swap Icon
class CitySelection extends ConsumerWidget {
  const CitySelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityState = ref.watch(citySelectionProvider);
    final langCode = ref.watch(localeProvider).languageCode;

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                builder: (_) => const SearchDestinationSheet(route: 'arrival'),
              ),
              child: CityField(
                icon: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.primaryColor.withValues(alpha: .3),
                  ),
                  child: Icon(
                    CupertinoIcons.location_solid,
                    color: AppColors.primaryColor,
                    size: 19,
                  ),
                ),
                label: AppTranslations.of(
                  context,
                  'arrival_destination',
                  langCode,
                ),
                city:
                    cityState.toCity ??
                    AppTranslations.of(
                      context,
                      'select_arrival_placeholder',
                      langCode,
                    ),
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                barrierColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                builder: (_) =>
                    const SearchDestinationSheet(route: 'departure'),
              ),
              child: CityField(
                icon: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.greenColor.withValues(alpha: .3),
                  ),
                  child: Icon(
                    CupertinoIcons.location_solid,
                    color: AppColors.greenColor,
                    size: 19,
                  ),
                ),
                label: AppTranslations.of(
                  context,
                  'departure_destination',
                  langCode,
                ),
                city:
                    cityState.fromCity ??
                    AppTranslations.of(
                      context,
                      'select_departure_placeholder',
                      langCode,
                    ),
              ),
            ),
          ],
        ),
        // Swap Button
        Positioned(
          right: 10,
          child: CircleAvatar(
            backgroundColor: AppColors.orangePrimary,
            child: IconButton(
              icon: const Icon(Icons.swap_vert, color: AppColors.whiteColor),
              onPressed: () {
                ref.read(citySelectionProvider.notifier).swapCities();
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual City Field Widget
class CityField extends ConsumerWidget {
  final Widget icon;
  final String label;
  final String city;

  const CityField({
    super.key,
    required this.icon,
    required this.label,
    required this.city,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    // Responsive logic: Check if the current city text matches the placeholders
    final bool isPlaceholder =
        city ==
            AppTranslations.of(
              context,
              'select_arrival_placeholder',
              langCode,
            ) ||
        city ==
            AppTranslations.of(
              context,
              'select_departure_placeholder',
              langCode,
            );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          icon,
          15.horizontalSpace, // Using your existing extension
          // Expanded is key for responsiveness to prevent overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Wrap content tightly
              children: [
                Text(
                  label,
                  style: context.bodyLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  city,
                  maxLines: 1, // Ensure it stays on one line
                  overflow:
                      TextOverflow.ellipsis, // Add "..." if text is too long
                  style: context.bodyLarge?.copyWith(
                    fontSize: 12,
                    fontWeight: isPlaceholder
                        ? FontWeight.w300
                        : FontWeight.w500,
                    color: isPlaceholder
                        ? AppColors.bluePrimary.withValues(
                            alpha: .4,
                          ) // Slightly higher opacity for readability
                        : AppColors.bluePrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

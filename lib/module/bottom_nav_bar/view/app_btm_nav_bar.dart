import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/module/book%20ride/view/book_ride_screen.dart';
import 'package:imo_mobility/module/track-parcel/view/track_parcel_screen.dart';

import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_provider.dart';
import '../../home/view/home_screen.dart';
import '../../profile/view/profile_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/nav_provider.dart';

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    final screens = [
      const HomeScreen(),
      const BusBookingScreen(),
      const TrackParcelScreen(),
      const ProfileScreen(),
    ];

    double width = MediaQuery.of(context).size.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: EdgeInsets.only(bottom: bottomPadding),
            height: (width * 0.16) + bottomPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: AppColors.orangePrimary,
              // boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(
                  context,
                  ref,
                  Icons.home,
                  AppTranslations.of(context, 'home', langCode),
                  0,
                  currentIndex,
                ),
                navItem(
                  context,
                  ref,
                  Icons.calendar_today,
                  AppTranslations.of(context, 'booking', langCode),
                  1,
                  currentIndex,
                ),
                navItem(
                  context,
                  ref,
                  Icons.local_shipping,
                  AppTranslations.of(context, 'parcel', langCode),
                  2,
                  currentIndex,
                ),
                navItem(
                  context,
                  ref,
                  Icons.person,
                  AppTranslations.of(context, 'profile', langCode),
                  3,
                  currentIndex,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget navItem(
    BuildContext context,
    WidgetRef ref,
    IconData icon,
    String label,
    int index,
    int currentIndex,
  ) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(bottomNavProvider.notifier).changeIndex(index);
        // Update profile active bool
        ref.read(isProfileActiveProvider.notifier).state = index == 3;
      },

      child: Container(
        width: 60,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected
                  ? AppColors.white
                  : AppColors.grayLight.withValues(alpha: .7),
            ),
            const SizedBox(height: 4),
            // Flexible + FittedBox to make text responsive
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown, // shrink text to fit width
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.grayLight.withValues(alpha: .7),
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

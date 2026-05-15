import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add Riverpod
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/book%20ride/view/book_ride_screen.dart';
import 'package:imo_mobility/module/home/widgets/booking_card.dart';
import 'package:imo_mobility/module/profile/view/profile_screen.dart';
import 'package:imo_mobility/module/tickets/view/all_tickets.dart';
import 'package:imo_mobility/shared/widgets/app_rich_text.dart';
import 'package:imo_mobility/core/localization/app_translations.dart'; // Localization
import 'package:imo_mobility/core/localization/locale_provider.dart'; // Localization
import '../../../routes/route.dart';

class HomeScreen extends ConsumerWidget {
  // Converted to ConsumerWidget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: AppColors.parcelBtnColor,
          title: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppRichText(
                  textAlign: TextAlign.left,
                  normalText: AppTranslations.of(context, 'hello', langCode),
                  actionText:
                      'Moctar', // User name usually comes from profile/auth state
                  onTap: () => null,
                  actionStyle: context.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 28,
                  ),
                  normalStyle: context.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                  ),
                ),
                Text(
                  AppTranslations.of(context, 'welcome_sirax', langCode),
                  style: context.bodySmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: GestureDetector(
                onTap: () => AppNavigation.push(const ProfileScreen()),
                child: CircleAvatar(
                  maxRadius: 30,
                  backgroundImage: AssetImage('assets/images/user-dp.png'),
                ),
              ),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.verticalSpace,
                BusCard(),
                10.verticalSpace,

                // const MyImageCarousel(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Screen ki width ke mutabiq font size calculate karein
                      // 0.05 ek multiplier hai, aap ise adjust kar sakte hain
                      double screenWidth = MediaQuery.of(context).size.width;
                      double dynamicFontSize =
                          screenWidth *
                          0.05; // Example: 400px width par 20px font

                      // Constraints set karein taake font bahut bada ya bahut chota na ho jaye
                      double titleSize = dynamicFontSize.clamp(16.0, 22.0);
                      double seeAllSize = (dynamicFontSize * 0.7).clamp(
                        12.0,
                        15.0,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          25.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  AppTranslations.of(
                                    context,
                                    'recent_bookings',
                                    langCode,
                                  ),
                                  style: context.headlineSmall?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: titleSize, // Dynamic font size
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              10.horizontalSpace,
                              GestureDetector(
                                onTap: () => AppNavigation.push(
                                  const TicketListScreen(),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      AppTranslations.of(
                                        context,
                                        'see_all',
                                        langCode,
                                      ),
                                      style: context.headlineSmall?.copyWith(
                                        color: AppColors.orangePrimary,
                                        fontWeight: FontWeight.w300,
                                        fontSize:
                                            seeAllSize, // Dynamic font size for small text
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: AppColors.orangePrimary,
                                      size:
                                          seeAllSize +
                                          2, // Icon ko bhi font ke mutabiq scale karein
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: BookingCard()),
                              20.horizontalSpace,
                              Expanded(child: BookingCard()),
                            ],
                          ),
                          90.verticalSpace,
                        ],
                      );
                    },
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

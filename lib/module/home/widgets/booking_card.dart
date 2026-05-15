import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import '../../../core/constants/constants.dart';
import '../../../core/extensions/app_extensions.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../routes/route.dart';
import '../../book ride/widgets/ticket_card.dart';

class BookingCard extends ConsumerWidget {
  const BookingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;
    return GestureDetector(
      onTap: () => AppNavigation.push(
        const BusTicketScreen(
          passengerName: "Jasper McAllister",
          bookingReference: "BUS-FRA-99281",
          departureTime: "09:30 AM",
          arrivalTime: "01:45 PM",
          duration: "4h 15m",
          fromCity: "Paris",
          fromStation: "Bercy Seine",
          toCity: "Lyon",
          toStation: "Lyon Perrache",
          busNumber: "FLX-402",
          busPlate: "FR-922-BK",
          seatNumber: "12A",
          isHome: true,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Screen width ke mutabiq base size nikalna
          double screenWidth = MediaQuery.of(context).size.width;

          // Responsive font sizes calculation
          double nameSize = (screenWidth * 0.042).clamp(13.0, 18.0);
          double priceSize = (screenWidth * 0.038).clamp(11.0, 15.0);
          double routeSize = (screenWidth * 0.035).clamp(10.0, 13.0);
          double dateSize = (screenWidth * 0.03).clamp(9.0, 11.0);

          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                  color: Colors.black.withOpacity(.05),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize
                  .min, // Container ko content ke mutabiq rakhne ke liye
              children: [
                /// Image (Responsive Aspect Ratio)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/bus-1.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                8.verticalSpace,

                /// Bus name & Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Bibus",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: nameSize, // Responsive
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orangePrimary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "€29.99",
                        style: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: priceSize, // Responsive
                        ),
                      ),
                    ),
                  ],
                ),

                4.verticalSpace,

                /// Route Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Paris",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontSize: routeSize, // Responsive
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //   child: Icon(
                    //     Icons.arrow_right_alt,
                    //     size: routeSize,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    Expanded(
                      child: Text(
                        "Lyon",
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontSize: routeSize, // Responsive
                        ),
                      ),
                    ),
                  ],
                ),

                8.verticalSpace,

                /// Time row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _time(context, "08:45"),
                    SizedBox(
                      height: 18,
                      width: 18,
                      child: Transform.flip(
                        flipX: true,
                        child: SvgPicture.asset(
                          'assets/images/icons/bus-2.svg',
                        ),
                      ),
                    ),
                    _time(context, "14:30"),
                  ],
                ),

                5.verticalSpace,

                /// Date
                Text(
                  "22-${AppTranslations.of(context, 'march', langCode).substring(0, 3)}-26",
                  style: context.bodyExtraSmall?.copyWith(
                    fontSize: dateSize, // Responsive
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _time(BuildContext context, String time) {
    return Text(
      time,
      style: context.bodySmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

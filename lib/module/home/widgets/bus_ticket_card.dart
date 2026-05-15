import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import '../../../core/extensions/app_extensions.dart';
import '../../book ride/widgets/ticket_card.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart'; // provider

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    // Left cut
    path.addOval(
      Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: 15.0),
    );

    // Right cut
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, size.height / 2),
        radius: 15.0,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BusTicketCard extends ConsumerWidget {
  final String busName;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String source;
  final String destination;
  final String price;
  final String seatNumber;
  final bool? isHome;

  const BusTicketCard({
    super.key,
    required this.busName,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.source,
    required this.destination,
    required this.price,
    required this.seatNumber,
    this.isHome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            /// 🔵 Top Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busName,
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        AppTranslations.of(context, 'bus_type', langCode),
                        style: context.bodyMedium?.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    price,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.grayBorder.withValues(alpha: .5)),

            /// 🔵 Middle Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTranslations.of(context, 'source_city', langCode),
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AppTranslations.of(context, 'destination_city', langCode),
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // BusProgressPainter(isHome: isHome),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                children: [
                  Transform.flip(
                    flipX: true,
                    child: SvgPicture.asset(
                      'assets/images/icons/bus-2.svg',
                      width: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Divider(color: Colors.black, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "4h 30m", // Duration static ya dynamic karein
                      style: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: Colors.black, thickness: 1),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/images/icons/station.svg',
                    width: 18,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTranslations.of(context, 'departure_time', langCode),
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AppTranslations.of(context, 'arrival_time', langCode),
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.grayBorder.withValues(alpha: .5)),

            /// 🔵 Bottom Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        AppTranslations.of(context, 'seats_label', langCode),
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      10.horizontalSpace,
                      Container(
                        height: 20,
                        width: 1,
                        color: AppColors.black.withValues(alpha: .1),
                      ),
                      10.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.verticalSpace,
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/seat-choosen.svg',
                                  ),
                                  Text(
                                    AppTranslations.of(
                                      context,
                                      'seat_12A',
                                      langCode,
                                    ),
                                    style: context.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              10.horizontalSpace,
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/seat-choosen.svg',
                                  ),
                                  Text(
                                    AppTranslations.of(
                                      context,
                                      'seat_13A',
                                      langCode,
                                    ),
                                    style: context.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.orangePrimary,
                        width: isHome == true ? .5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Text(
                          AppTranslations.of(context, 'view_details', langCode),
                          style: isHome == true
                              ? context.bodyExtraSmall?.copyWith(
                                  color: AppColors.orangePrimary,
                                )
                              : context.bodySmall?.copyWith(
                                  color: AppColors.orangePrimary,
                                ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.orangePrimary,
                          size: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

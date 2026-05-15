import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:imo_mobility/module/book%20ride/view/reserve_ticket.dart';
import 'package:imo_mobility/routes/route.dart';

import '../../../core/constants/constants.dart';
import '../../../core/extensions/context_extension.dart';
import '../../find-trip/views/ticket_booking.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';

/// 🔹 Timing model
class BusTiming {
  final String departure;
  final String arrival;
  final String busType;

  BusTiming({
    required this.departure,
    required this.arrival,
    required this.busType,
  });
}

/// 🔹 Expand state provider (per card)
final isTimingViewingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, id) => false,
);

class TravelBusCard extends ConsumerStatefulWidget {
  final String id;
  final String companyName;
  final String busType;
  final String busModel;
  final String price;
  final String imagePath;
  final List<BusTiming> timings;

  const TravelBusCard({
    super.key,
    required this.id,
    required this.companyName,
    required this.busType,
    required this.busModel,
    required this.price,
    required this.imagePath,
    required this.timings,
  });

  @override
  ConsumerState<TravelBusCard> createState() => _TravelBusCardState();
}

class _TravelBusCardState extends ConsumerState<TravelBusCard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final isTimingViewing = ref.watch(isTimingViewingProvider(widget.id));
    final langCode = ref.watch(localeProvider).languageCode;

    return AnimatedSize(
      reverseDuration: const Duration(milliseconds: 300),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 1,
              color: AppColors.primaryColor.withValues(alpha: .1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildBottomSection(context, isTimingViewing, langCode),
          ],
        ),
      ),
    );
  }

  /// 🔹 Header Section
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(height: 60, child: Image.asset(widget.imagePath)),
          Divider(color: AppColors.primaryGradientClrLow),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.companyName,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    widget.busType,
                    style: context.bodySmall?.copyWith(
                      color: AppColors.greyColor,
                    ),
                  ),
                  Text(
                    widget.busModel,
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.wifi),
                      SizedBox(width: 5),
                      Icon(Icons.lunch_dining_rounded),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.parcelBtnColor,
                    ),
                    child: Center(
                      child: Text(
                        widget.price,
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Bottom Expand Section
  /// 🔹 Bottom Expand Section
  Widget _buildBottomSection(
    BuildContext context,
    bool isTimingViewing,
    String langCode,
  ) {
    // decide how many timings to show
    final timingsToShow = isTimingViewing
        ? widget.timings
              .take(3)
              .toList() // view all 3 timings
        : widget.timings.take(1).toList(); // single timing

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),

          /// 🔥 Toggle Row
          InkWell(
            onTap: () {
              ref.read(isTimingViewingProvider(widget.id).notifier).state =
                  !isTimingViewing;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppTranslations.of(context, 'view_timings', langCode),
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    isTimingViewing
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    size: 30,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
          Divider(color: AppColors.grayBorder),

          /// 🔹 Dynamic Timings
          ...timingsToShow.asMap().entries.map((entry) {
            final index = entry.key;
            final timing = entry.value;

            return Column(
              children: [
                const SizedBox(height: 10),

                InkWell(
                  onTap: () => AppNavigation.push(
                    DynamicBusLayoutScreen(vehicleType: timing.busType),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            AppTranslations.of(context, 'departure', langCode),
                            style: context.bodyLarge?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            timing.departure,
                            style: context.bodyLarge?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            AppTranslations.of(context, 'arrival', langCode),
                            style: context.bodyLarge?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            timing.arrival,
                            style: context.bodyLarge?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// show divider only if NOT last item
                if (index != timingsToShow.length - 1)
                  Divider(color: AppColors.grayBorder.withValues(alpha: .3)),
              ],
            );
          }),
        ],
      ),
    );
  }
}

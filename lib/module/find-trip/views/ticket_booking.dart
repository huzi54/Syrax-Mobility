import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/module/book%20ride/view/ticket_screen.dart';
import 'package:imo_mobility/module/find-trip/views/pessenger_details_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/buttons/app_button.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import '../../../core/extensions/context_extension.dart';
import 'payment_screen.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';

// --- MODELS ---
enum SeatType { standard, vip, staff, blocked }

class BusLayoutTemplate {
  final String name;
  final int leftColumn;
  final int rightColumn;
  final int totalRows;
  final bool hasRearRow;
  final List<String> vipSeatIds;
  final List<String> staffSeatIds;
  final List<String> blockedSeatIds;

  BusLayoutTemplate({
    required this.name,
    required this.leftColumn,
    required this.rightColumn,
    required this.totalRows,
    this.hasRearRow = true,
    this.vipSeatIds = const [],
    this.staffSeatIds = const [],
    this.blockedSeatIds = const [],
  });
}

// --- STATE MANAGEMENT (Riverpod Legacy) ---
final layoutProvider = StateProvider<BusLayoutTemplate>((ref) {
  return BusLayoutTemplate(
    name: "Standard 2x2 Business",
    leftColumn: 2,
    rightColumn: 2,
    totalRows: 8,
    vipSeatIds: ["R0_L0", "R0_L1", "R0_R0", "R0_R1"],
    staffSeatIds: ["R1_L0"],
    blockedSeatIds: ["R7_R1"],
  );
});

final selectedSeatProvider = StateProvider<Set<String>>((ref) => {});

// Pricing logic based on seat type
double calculateTotalPrice(
  Set<String> selectedIds,
  BusLayoutTemplate template,
) {
  double total = 0.0;
  for (var id in selectedIds) {
    if (template.vipSeatIds.contains(id)) {
      total += 50.0; // VIP Price
    } else {
      total += 30.0; // Standard Price
    }
  }
  return total;
}

// --- MAIN UI ---
class DynamicBusLayoutScreen extends ConsumerWidget {
  final String vehicleType;

  const DynamicBusLayoutScreen({super.key, required this.vehicleType});

  BusLayoutTemplate _getTemplate() {
    switch (vehicleType) {
      case "Sprinter":
        return BusLayoutTemplate(
          name: "Executive Sprinter",
          leftColumn: 1,
          rightColumn: 2,
          totalRows: 6,
          vipSeatIds: ["R0_L0", "R0_R0", "R0_R1"],
          staffSeatIds: ["R1_L0", "R1_R0"],
          blockedSeatIds: ["R5_R1"],
          hasRearRow: false,
        );
      default:
        return BusLayoutTemplate(
          name: "Standard Coach",
          leftColumn: 2,
          rightColumn: 2,
          totalRows: 8,
          vipSeatIds: ["R0_L0", "R0_L1", "R0_R0", "R0_R1"],
          staffSeatIds: ["R1_L0", "R2_R1"],
          blockedSeatIds: ["R4_L1", "R7_R1"],
          hasRearRow: true,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = _getTemplate();
    final selectedSeats = ref.watch(selectedSeatProvider);
    final langCode = ref.watch(localeProvider).languageCode;

    double totalPrice = calculateTotalPrice(selectedSeats, template);
    int seatCounter = 1;

    return Scaffold(
      appBar: MyAppBar(title: template.name),
      body: Column(
        children: [
          _buildLegend(context, langCode),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  20.verticalSpace,
                  ...List.generate(template.totalRows, (rowIndex) {
                    final rowWidget = Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(template.leftColumn, (colIndex) {
                            final id = "R${rowIndex}_L$colIndex";
                            return _seatItem(
                              ref,
                              id,
                              seatCounter++,
                              template,
                              selectedSeats,
                            );
                          }),
                          const SizedBox(width: 40),
                          ...List.generate(template.rightColumn, (colIndex) {
                            final id = "R${rowIndex}_R$colIndex";
                            return _seatItem(
                              ref,
                              id,
                              seatCounter++,
                              template,
                              selectedSeats,
                            );
                          }),
                        ],
                      ),
                    );

                    if (rowIndex == 0) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [const SizedBox(height: 40), rowWidget],
                          ),
                          Positioned(
                            top: -5,
                            left:
                                MediaQuery.of(context).size.width / 2 -
                                ((template.leftColumn + template.rightColumn) *
                                            46 +
                                        115) /
                                    2 +
                                23,
                            child: SvgPicture.asset(
                              'assets/images/icons/steering-wheel-2.svg',
                              height: 35,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ],
                      );
                    }
                    return rowWidget;
                  }),
                  if (template.hasRearRow)
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          return _seatItem(
                            ref,
                            "REAR_$i",
                            seatCounter++,
                            template,
                            selectedSeats,
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildBottomPanel(context, selectedSeats, totalPrice, langCode),
        ],
      ),
    );
  }

  Widget _seatItem(
    WidgetRef ref,
    String id,
    int displayNum,
    BusLayoutTemplate template,
    Set<String> selected,
  ) {
    bool isSelected = selected.contains(id);
    bool isVip = template.vipSeatIds.contains(id);
    bool isBooked =
        template.staffSeatIds.contains(id) ||
        template.blockedSeatIds.contains(id);

    String asset = "assets/images/icons/available-seat.svg";
    if (isSelected)
      asset = "assets/images/icons/selected-seat.svg";
    else if (isBooked)
      asset = "assets/images/icons/booked-seat.svg";
    else if (isVip)
      asset = "assets/images/icons/vip-seat.svg";

    Color textColor = (isSelected || isBooked || isVip)
        ? Colors.white
        : const Color(0xFF5E5E7E);

    return GestureDetector(
      onTap: isBooked
          ? null
          : () {
              final notifier = ref.read(selectedSeatProvider.notifier);
              if (isSelected)
                notifier.state = {...selected}..remove(id);
              else
                notifier.state = {...selected, id};
            },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(asset, width: 38, height: 38),
            Positioned(
              top: 8,
              child: Text(
                "$displayNum",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, String langCode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _legendNode(
            context,
            AppTranslations.of(context, 'available', langCode),
            "assets/images/icons/seat-available.svg",
          ),
          _legendNode(
            context,
            AppTranslations.of(context, 'vip', langCode),
            "assets/images/icons/vip-seat.svg",
          ),
          _legendNode(
            context,
            AppTranslations.of(context, 'booked', langCode),
            "assets/images/icons/seat-booked.svg",
          ),
          _legendNode(
            context,
            AppTranslations.of(context, 'selected', langCode),
            "assets/images/icons/seat-choosen.svg",
          ),
        ],
      ),
    );
  }

  Widget _legendNode(BuildContext context, String title, String path) {
    return Row(
      children: [
        SvgPicture.asset(path, width: 14),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Color(0xFF5E5E7E)),
        ),
      ],
    );
  }

  Widget _buildBottomPanel(
    BuildContext context,
    Set<String> selected,
    double total,
    String langCode,
  ) {
    // Screen width calculate karein
    double screenWidth = MediaQuery.of(context).size.width;

    // Responsive font sizes
    double labelFontSize = (screenWidth * 0.03).clamp(10.0, 13.0);
    double priceFontSize = (screenWidth * 0.05).clamp(18.0, 24.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side: Info Column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${selected.length} ${AppTranslations.of(context, 'seats_selected', langCode)}",
                    style: TextStyle(
                      fontSize: labelFontSize,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "€ ${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: priceFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10), // Beech mein thoda gap
            // Right Side: Action Button
            Flexible(
              flex: 3,
              child: AppButtons.elevated(
                // Size ko screen width ke mutabiq adjust kiya (Max 180, Min 120)
                size: Size(screenWidth * 0.4.clamp(120.0, 180.0), 48),
                onPressed: selected.isEmpty
                    ? null
                    : () => _showBookingTypeDialog(
                        context,
                        total.toStringAsFixed(2),
                        langCode,
                      ),
                text: AppTranslations.of(context, 'continue', langCode),
                backgroundColor: AppColors.orangePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showBookingTypeDialog(
  BuildContext context,
  String price,
  String langCode,
) {
  // Screen width nikalna
  double screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        AppTranslations.of(context, 'booking_for', langCode),
        style: context.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          // Responsive title font
          fontSize: (screenWidth * 0.05).clamp(16.0, 22.0),
        ),
      ),
      content: Text(
        AppTranslations.of(context, 'booking_for_details', langCode),
        style: TextStyle(fontSize: (screenWidth * 0.035).clamp(12.0, 15.0)),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      actions: [
        // Flexible buttons layout
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PassengerDetailsScreen(price: price),
                  ),
                );
              },
              child: Text(
                AppTranslations.of(context, 'someone_else', langCode),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: (screenWidth * 0.035).clamp(12.0, 14.0),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // "For Myself" button ko flexible banaya
            Flexible(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  AppNavigation.push(CardPaymentScreen(price: price));
                },
                child: Container(
                  // Fix width hatakar constraints lagaye
                  constraints: BoxConstraints(
                    minWidth: 80,
                    maxWidth: screenWidth * 0.35,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.orangePrimary,
                  ),
                  child: Center(
                    child: Text(
                      AppTranslations.of(context, 'for_myself', langCode),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: (screenWidth * 0.035).clamp(12.0, 14.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

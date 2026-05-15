// bus_ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/bottom_nav_bar/view/app_btm_nav_bar.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_provider.dart';
import '../provider/book_ride_provider.dart';
import 'package:gal/gal.dart';

// bus_ticket_screen.dart

class BusTicketScreen extends ConsumerStatefulWidget {
  final bool isHome;
  final String passengerName;
  final String bookingReference;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String fromCity;
  final String fromStation;
  final String toCity;
  final String toStation;
  final String busNumber;
  final String busPlate;
  final String seatNumber;

  const BusTicketScreen({
    super.key,
    required this.passengerName,
    required this.bookingReference,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.fromCity,
    required this.fromStation,
    required this.toCity,
    required this.toStation,
    required this.busNumber,
    required this.busPlate,
    required this.seatNumber,
    required this.isHome,
  });

  @override
  ConsumerState<BusTicketScreen> createState() => _BusTicketScreenState();
}

class _BusTicketScreenState extends ConsumerState<BusTicketScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _downloadTicket() async {
    final imageBytes = await screenshotController.capture();
    if (imageBytes == null) return;

    if (!await Gal.hasAccess()) {
      await Gal.requestAccess();
    }

    try {
      await Gal.putImageBytes(
        imageBytes,
        name: "bus_ticket_${widget.bookingReference}",
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${AppTranslations.of(context, 'download', '')} ✅"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${AppTranslations.of(context, 'download', '')} ❌"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'your_ticket', langCode),
        onPressed: () =>
            AppNavigation.pushAndRemoveUntil(const AppBottomNavBar()),
        titleColor: AppColors.white,
      ),
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) =>
            AppNavigation.pushAndRemoveUntil(const AppBottomNavBar()),
        child: SingleChildScrollView(
          // Added for small screens
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: PhysicalShape(
                    clipper: TicketClipper(),
                    color: Colors.white,
                    elevation: 10,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppTranslations.of(
                                        context,
                                        'passenger',
                                        langCode,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      widget.passengerName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _infoRow(
                                      context,
                                      'ticket_id',
                                      widget.bookingReference,
                                      langCode,
                                    ),
                                    _infoRow(
                                      context,
                                      'total_paid',
                                      "€390",
                                      langCode,
                                      isPrimary: true,
                                    ),
                                    _infoRow(
                                      context,
                                      'travel_date',
                                      "22-${AppTranslations.of(context, 'march', langCode).substring(0, 3)}-26",
                                      langCode,
                                      isPrimary: true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                flex: 2,
                                child: QrImageView(
                                  data: 'BusTicket:${widget.bookingReference}',
                                  version: QrVersions.auto,
                                  size:
                                      120.0, // Reduced size for responsiveness
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Divider(
                              color: AppColors.grayBorder.withOpacity(0.4),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.fromCity,
                                  style: context.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.toCity,
                                  textAlign: TextAlign.end,
                                  style: context.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          BusProgressPainter(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.departureTime,
                                style: context.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.arrivalTime,
                                style: context.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Divider(color: AppColors.grayBorder.withOpacity(0.4)),
                          const SizedBox(height: 15),

                          // Responsive Bus Plate and Seats Row
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        AppTranslations.of(
                                          context,
                                          'bus_plate',
                                          langCode,
                                        ),
                                        style: context.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.primaryColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Text(
                                          widget.busPlate,
                                          style: context.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  color: AppColors.black,
                                  thickness: 1.5,
                                  width: 30,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppTranslations.of(
                                          context,
                                          'seats',
                                          langCode,
                                        ),
                                        style: context.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        // Wrap added for multiple seats
                                        spacing: 8,
                                        children: [
                                          _seatIcon('12A', context),
                                          _seatIcon('13A', context),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Divider(color: AppColors.black.withOpacity(0.1)),
                          const SizedBox(height: 5),
                          FittedBox(
                            // Ensures timestamp doesn't break
                            child: Row(
                              children: [
                                Text(
                                  AppTranslations.of(
                                    context,
                                    'printed_date',
                                    langCode,
                                  ),
                                  style: context.bodyExtraSmall,
                                ),
                                Text(
                                  ": 26 ${AppTranslations.of(context, 'march', langCode)}, 2026 10:00 PM",
                                  style: context.bodyExtraSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Responsive Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          onPressed: () async {
                            final image = await screenshotController.capture();
                            if (image != null) {
                              ref
                                  .read(ticketProvider.notifier)
                                  .shareTicket(image);
                            }
                          },
                          icon: Icons.share,
                          label: AppTranslations.of(context, 'share', langCode),
                          color: AppColors.primaryColor,
                          context: context,
                          isOutlined: true, // 👈 outline
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          onPressed: _downloadTicket,
                          icon: Icons.download,
                          label: AppTranslations.of(
                            context,
                            'download',
                            langCode,
                          ),
                          color: AppColors.orangePrimary,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    String key,
    String value,
    String lang, {
    bool isPrimary = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Wrap(
        children: [
          Text(
            "${AppTranslations.of(context, key, lang)}: ",
            style: context.bodySmall,
          ),
          Text(
            value,
            style: context.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPrimary ? AppColors.primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _seatIcon(String seat, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/images/icons/seat-choosen.svg', width: 20),
        Text(
          seat,
          style: context.bodySmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required BuildContext context,
    bool isOutlined = false,
  }) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: color),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        elevation: 0,
      ),
    );
  }
}

class BusProgressPainter extends StatelessWidget {
  bool? isHome;
  BusProgressPainter({super.key, this.isHome});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: isHome == true ? 20 : 0,
      ),
      child: Row(
        children: [
          Transform.flip(
            flipX: true,
            child: SvgPicture.asset('assets/images/icons/bus-2.svg', width: 22),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Colors.black, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "4h 30m", // Duration static ya dynamic karein
              style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const Expanded(child: Divider(color: Colors.black, thickness: 1)),
          const SizedBox(width: 8),
          SvgPicture.asset('assets/images/icons/station.svg', width: 18),
        ],
      ),
    );
  }
}

// TicketClipper code stays the same

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 15;
    double clipY = size.height * 0.48;

    path.lineTo(0, clipY - radius);
    path.arcToPoint(
      Offset(0, clipY + radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, clipY + radius);
    path.arcToPoint(
      Offset(size.width, clipY - radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(size.width, 20);
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
    path.lineTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

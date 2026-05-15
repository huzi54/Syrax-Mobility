import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/module/home/view/home_screen.dart';
import 'package:imo_mobility/routes/route.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import 'package:screenshot/screenshot.dart';
import '../../../core/constants/constants.dart';
import '../provider/book_ride_provider.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';

class TicketDetailsScreen extends ConsumerStatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  ConsumerState<TicketDetailsScreen> createState() =>
      _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends ConsumerState<TicketDetailsScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) =>
          AppNavigation.pushAndRemoveUntil(HomeScreen()),
      child: Scaffold(
        appBar: MyAppBar(
          title: AppTranslations.of(context, 'your_ticket', langCode),
          onPressed: () => AppNavigation.pushAndRemoveUntil(HomeScreen()),
          titleColor: Colors.white,
          actions: [
            Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(ticketProvider);
                return IconButton(
                  icon: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.share_outlined,
                          color: AppColors.primaryColor,
                        ),
                  onPressed: () async {
                    final image = await screenshotController.capture();
                    if (image != null) {
                      ref.read(ticketProvider.notifier).shareTicket(image);
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Screenshot(
                  controller: screenshotController,
                  child: _buildTicketCard(langCode),
                ),
              ),
            ),
            _buildDownloadButton(langCode),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(String langCode) {
    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            // Passenger Profile
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=jason',
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jason Davis",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.bluePrimary,
                      ),
                    ),
                    Text(
                      AppTranslations.of(context, 'passenger', langCode),
                      style: TextStyle(
                        color: AppColors.black.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Route Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoBlock(
                  AppTranslations.of(context, 'from', langCode),
                  "Illinois",
                  "Dancing Dove Lane",
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.blueSecondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_bus,
                    color: AppColors.blueSecondary,
                    size: 24,
                  ),
                ),
                _infoBlock(
                  AppTranslations.of(context, 'to', langCode),
                  "California",
                  "Bel Meadow Drive",
                  crossAlign: CrossAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Date & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconDetail(Icons.calendar_today, "29 Jan, 2023"),
                _iconDetail(Icons.access_time, "03:45 PM"),
              ],
            ),

            // Dashed Divider
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 35),
              child: _DashedLine(),
            ),

            // Grid Details
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _detailItem(
                  AppTranslations.of(context, 'bus_stop', langCode),
                  "Greyhound",
                ),
                _detailItem(
                  AppTranslations.of(context, 'ticket_no', langCode),
                  "W75P-C27",
                ),
                _detailItem(
                  AppTranslations.of(context, 'passenger', langCode),
                  "4 Adult",
                ),
                _detailItem(
                  AppTranslations.of(context, 'seat_no', langCode),
                  "C2, C3, C4, D3",
                ),
              ],
            ),

            const Spacer(),

            // QR Code
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grayBorder),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=JasonDavis_Ticket',
                height: 140,
                width: 140,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _infoBlock(
    String label,
    String city,
    String street, {
    CrossAxisAlignment crossAlign = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          city,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.bluePrimary,
          ),
        ),
        Text(street, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _iconDetail(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grayLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.blueSecondary),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.bluePrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.blueSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(String langCode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.bluePrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {},
          child: Text(
            AppTranslations.of(context, 'download_ticket', langCode),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// TicketClipper & _DashedLine unchanged from your original code
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 15;
    double cutOutY = size.height * 0.43;

    path.lineTo(0, cutOutY);
    path.arcToPoint(
      Offset(0, cutOutY + (radius * 2)),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, cutOutY + (radius * 2));
    path.arcToPoint(
      Offset(size.width, cutOutY),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            (constraints.constrainWidth() / 10).floor(),
            (index) => const SizedBox(
              width: 5,
              height: 1.5,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.grayBorder),
              ),
            ),
          ),
        );
      },
    );
  }
}

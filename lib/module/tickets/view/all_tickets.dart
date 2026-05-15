import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';

import '../../../core/extensions/app_extensions.dart';
import '../../../routes/route.dart';
import '../../book ride/widgets/ticket_card.dart';
import '../../bottom_nav_bar/view/app_btm_nav_bar.dart';
import '../../home/widgets/booking_card.dart';
import '../../home/widgets/bus_ticket_card.dart';

import 'package:imo_mobility/core/localization/locale_provider.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';

class TicketListScreen extends ConsumerWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    return PopScope(
      canPop: false, // Isko false rakhein taake hum khud handle karein
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // Agar pehle hi pop ho chuka hai to kuch na karein

        // Navigation ko microtask mein dalein taake UI freeze na ho
        Future.microtask(() {
          AppNavigation.pushAndRemoveUntil(const AppBottomNavBar());
        });
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: AppTranslations.of(context, 'my_bus_tickets', langCode),
          onPressed: () =>
              AppNavigation.pushAndRemoveUntil(const AppBottomNavBar()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: BookingCard()),
                  20.horizontalSpace,
                  Expanded(child: BookingCard()),
                ],
              ),
            ],
          ),

          //  GridView.builder(
          //   itemCount: 4, // total bookings
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 12,
          //     mainAxisSpacing: 12,
          //     childAspectRatio: 0.65, // height increase
          //   ),
          //   itemBuilder: (context, index) {
          //     return GestureDetector(
          //       onTap: () => AppNavigation.push(
          //         BusTicketScreen(
          //           passengerName: 'Jasper McAllister',
          //           bookingReference: "BUS-FRA-99281",
          //           departureTime: "09:30 AM",
          //           arrivalTime: "01:45 PM",
          //           duration: "4h 15m",
          //           fromCity: 'Paris',
          //           fromStation: 'Bercy Seine',
          //           toCity: 'Lyon',
          //           toStation: 'Lyon Perrache',
          //           busNumber: "FLX-402",
          //           busPlate: "FR-922-BK",
          //           seatNumber: "12A",
          //           isHome: true,
          //         ),
          //       ),
          //       child: const BookingCard(),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}

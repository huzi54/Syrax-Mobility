import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/app_extensions.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_provider.dart';
import '../provider/book_ride_provider.dart';
import '../widgets/reusable_date_selection.dart';
import '../widgets/travel_bus_card.dart';

class TicketScreen extends ConsumerWidget {
  final String fromSelectedRide;
  final String toSelectedRide;

  const TicketScreen({
    super.key,
    required this.fromSelectedRide,
    required this.toSelectedRide,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bookRideProvider.notifier);
    final langCode = ref.watch(localeProvider).languageCode;
    final selectedDate = ref.watch(
      bookRideProvider.notifier.select(
        (notifier) => notifier.calendarInitialDate,
      ),
    );

    return Scaffold(
      appBar: MyAppBar(
        title:
            "${fromSelectedRide.toUpperCase()} - ${toSelectedRide.toUpperCase()}",
        titleColor: AppColors.white,
        fontSize: 18,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              15.verticalSpace,
              ReusableDateSelection(
                startDate: selectedDate,
                numberOfDates: 10, // optional, default 10
                onDateSelected: (selectedDate) {
                  notifier.updateSelectedDate(selectedDate); // updates state
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_left, color: AppColors.primaryColor),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),

              20.verticalSpace,
              TravelBusCard(
                id: "bus_1",
                companyName: AppTranslations.of(
                  context,
                  'travelCompany',
                  langCode,
                ),
                busType: AppTranslations.of(context, 'busType', langCode),
                busModel: "Premium Plus 12x23",
                price: "€120",
                imagePath:
                    "assets/images/travel_company/travel-company-logo 1.png",
                timings: [
                  BusTiming(
                    departure: "13:00",
                    arrival: "17:00",
                    busType: 'Sprinter',
                  ),
                  BusTiming(
                    departure: "17:50",
                    arrival: "20:50",
                    busType: 'Standard Coach',
                  ),
                ],
              ),
              10.verticalSpace,
              TravelBusCard(
                id: "bus_2",
                companyName: AppTranslations.of(
                  context,
                  'travelCompany',
                  langCode,
                ),
                busType: AppTranslations.of(context, 'busType', langCode),
                busModel: "Premium Plus 12x23",
                price: "€120",
                imagePath:
                    "assets/images/travel_company/travel-company-logo 2.png",
                timings: [
                  BusTiming(
                    departure: "13:00",
                    arrival: "17:00",
                    busType: 'Sprinter',
                  ),
                  BusTiming(
                    departure: "17:50",
                    arrival: "20:50",
                    busType: 'Standard Coach',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

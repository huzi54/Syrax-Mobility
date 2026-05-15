// Location: lib/core/widgets/bus_ticket_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:imo_mobility/module/book%20ride/view/book_ride_screen.dart';
import 'package:imo_mobility/module/book%20ride/view/ticket_view_screen.dart';
import 'package:imo_mobility/module/find-trip/views/ticket_booking.dart';
import 'package:imo_mobility/routes/route.dart';

import '../../core/constants/constants.dart';
import '../../core/extensions/context_extension.dart';
import '../../core/localization/app_translations.dart';
import '../../core/localization/locale_provider.dart' show localeProvider;
import '../../module/book ride/provider/book_ride_provider.dart';
import '../../module/book ride/widgets/date_selection_widget.dart';

// Location: lib/core/widgets/search_trips_card.dart

class SearchTripsCard extends ConsumerWidget {
  const SearchTripsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripProvider);
    final tripNotifier = ref.read(tripProvider.notifier);
    final cityState = ref.read(citySelectionProvider);
    final selectedDate = ref
        .watch(bookRideProvider.notifier)
        .calendarInitialDate;

    final langCode = ref.watch(localeProvider).languageCode;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.of(context, 'where_are_you_going', langCode),
              style: context.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Location Inputs
            // City Selection
            CitySelection(),
            const SizedBox(height: 20),

            // Date Selection
            // Date Row
            DateSelection(),

            const SizedBox(height: 20),

            // Passengers & Coach Type
            Row(
              children: [
                Expanded(
                  child: customDropdown<int>(
                    label: AppTranslations.of(context, 'passenger', langCode),
                    selectedValue: tripState.passengers,
                    icon: Icons.person,
                    items: const [1, 2, 3, 4],
                    itemLabel: (value) {
                      if (value == 1) {
                        return "1 ${AppTranslations.of(context, 'adult', langCode)}";
                      }
                      return "$value ${AppTranslations.of(context, 'adults', langCode)}";
                    },
                    onChanged: tripNotifier.updatePassengers,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  AppNavigation.push(
                    TicketScreen(
                      fromSelectedRide: cityState.fromCity ?? '',
                      toSelectedRide: cityState.toCity ?? '',
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  AppTranslations.of(context, 'search_trips', langCode),
                  style: context.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
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

class TripState {
  final int passengers;
  final String coachType;

  TripState({this.passengers = 1, this.coachType = 'Economy Class'});

  TripState copyWith({int? passengers, String? coachType}) {
    return TripState(
      passengers: passengers ?? this.passengers,
      coachType: coachType ?? this.coachType,
    );
  }
}

class TripNotifier extends StateNotifier<TripState> {
  TripNotifier() : super(TripState());

  void updatePassengers(int value) {
    state = state.copyWith(passengers: value);
  }
}

final tripProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  return TripNotifier();
});

Widget customDropdown<T>({
  required String label,
  required T selectedValue,
  required List<T> items,
  required Function(T) onChanged,
  required String Function(T) itemLabel,
  IconData? icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: selectedValue,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, size: 18),
            items: items.map((e) {
              return DropdownMenuItem<T>(
                value: e,
                child: Row(
                  children: [
                    if (icon != null) Icon(icon, size: 16),
                    if (icon != null) const SizedBox(width: 6),
                    Text(itemLabel(e)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                onChanged(val);
              }
            },
          ),
        ),
      ),
    ],
  );
}

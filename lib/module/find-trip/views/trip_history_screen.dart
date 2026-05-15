// Location: lib/features/trips/presentation/screens/trip_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/module/home/widgets/bus_ticket_card.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';

class TripHistoryScreen extends ConsumerStatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  ConsumerState<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends ConsumerState<TripHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'trip_history', langCode),
      ),
      body: Column(
        children: [
          // --- Custom Tab Bar ---
          TabBar(
            controller: _tabController,
            labelColor: AppColors.orangePrimary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.orangePrimary,
            indicatorWeight: 3,
            labelStyle: context.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: AppTranslations.of(context, 'completed', langCode)),
              Tab(text: AppTranslations.of(context, 'canceled', langCode)),
            ],
          ),

          // --- History List ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTripList(isCanceled: false, langCode: langCode),
                _buildTripList(isCanceled: true, langCode: langCode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList({required bool isCanceled, required String langCode}) {
    // Example placeholder trips (replace with provider data in real app)
    final trips = isCanceled ? [1] : [1, 2, 3];

    if (trips.isEmpty) {
      return _buildEmptyState(langCode: langCode);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return Opacity(
          opacity: isCanceled ? 0.7 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const BusTicketCard(
              busName: "Express Travels",
              departureTime: "08:00 AM",
              arrivalTime: "02:00 PM",
              duration: "6h 0m",
              source: "NYC",
              destination: "BOS",
              price: "€45.00",
              seatNumber: "A12",
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({required String langCode}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_bus_filled_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            AppTranslations.of(context, 'no_trips_found', langCode),
            style: context.titleMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

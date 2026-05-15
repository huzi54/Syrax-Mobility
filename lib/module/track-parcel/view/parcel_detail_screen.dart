import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';
import 'package:imo_mobility/core/localization/locale_provider.dart';
import 'package:imo_mobility/core/localization/app_translations.dart';

import '../../../core/constants/constants.dart';

class ParcelTrackingScreen extends ConsumerWidget {
  final String trackingId;
  const ParcelTrackingScreen({super.key, required this.trackingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;

    return Scaffold(
      appBar: MyAppBar(
        title: AppTranslations.of(context, 'track_parcel', langCode),
        titleColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(context, langCode),
            const SizedBox(height: 30),
            Text(
              AppTranslations.of(context, 'tracking_history', langCode),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildTimelineItem(
              AppTranslations.of(context, 'parcel_picked_up', langCode),
              "Mar 01, 09:30 AM",
              "Paris Hub",
              true,
              true,
            ),
            _buildTimelineItem(
              AppTranslations.of(context, 'in_transit', langCode),
              "Mar 01, 02:15 PM",
              "On the way to Lyon",
              true,
              true,
            ),
            _buildTimelineItem(
              AppTranslations.of(context, 'out_for_delivery', langCode),
              "Mar 02, 10:00 AM",
              AppTranslations.of(context, 'delivery_exec_nearby', langCode),
              true,
              false,
            ),
            _buildTimelineItem(
              AppTranslations.of(context, 'delivered', langCode),
              AppTranslations.of(context, 'pending', langCode),
              "Final Destination: Lyon",
              false,
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String langCode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.orangePrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTranslations.of(context, 'tracking_id', langCode),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                trackingId,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 30),
          Row(
            children: [
              _locationInfo(
                context,
                AppTranslations.of(context, 'origin', langCode),
                "Paris",
                langCode,
              ),
              const Expanded(child: Icon(Icons.east, color: Colors.white)),
              _locationInfo(
                context,
                AppTranslations.of(context, 'destination', langCode),
                "Lyon",
                langCode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationInfo(
    BuildContext context,
    String title,
    String city,
    String langCode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Text(
          city,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String title,
    String time,
    String subTitle,
    bool isCompleted,
    bool showLine,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.orangePrimary
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted
                        ? AppColors.orangePrimary
                        : Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCompleted ? Colors.black : Colors.grey,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

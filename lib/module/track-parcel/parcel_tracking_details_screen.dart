import 'package:flutter/material.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import 'package:imo_mobility/shared/widgets/my_app_bar.dart';

class ParcelTrackingDetailsScreen extends StatelessWidget {
  final String trackingId;
  final String currentStatus;

  const ParcelTrackingDetailsScreen({
    super.key,
    required this.trackingId,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> trackingSteps = [
      {"title": "Parcel Picked Up", "date": "25 Feb 2026 - 10:00 AM"},
      {"title": "In Transit", "date": "26 Feb 2026 - 03:30 PM"},
      {"title": "Out for Delivery", "date": "28 Feb 2026 - 08:00 AM"},
      {"title": "Delivered", "date": "28 Feb 2026 - 02:15 PM"},
    ];

    return Scaffold(
      appBar: MyAppBar(
        title: trackingId,
        titleColor: AppColors.bluePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primaryColor.withOpacity(0.15),
              ),
              child: Text(
                currentStatus,
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            /// 🔹 Timeline Title
            Text(
              "Shipment Progress",
              style: context.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Timeline
            Expanded(
              child: ListView.builder(
                itemCount: trackingSteps.length,
                itemBuilder: (context, index) {
                  final step = trackingSteps[index];
                  final bool isCompleted =
                      index <= _getStatusIndex(currentStatus);

                  return _timelineTile(
                    context,
                    title: step["title"]!,
                    date: step["date"]!,
                    isCompleted: isCompleted,
                    isLast: index == trackingSteps.length - 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getStatusIndex(String status) {
    switch (status) {
      case "Parcel Picked Up":
        return 0;
      case "In Transit":
        return 1;
      case "Out for Delivery":
        return 2;
      case "Delivered":
        return 3;
      default:
        return 0;
    }
  }

  Widget _timelineTile(
    BuildContext context, {
    required String title,
    required String date,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Indicator Column
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.4),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.3),
              ),
          ],
        ),

        const SizedBox(width: 12),

        /// Text Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? AppColors.black : AppColors.greyColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: context.bodySmall?.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

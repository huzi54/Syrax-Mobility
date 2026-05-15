import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/constants.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/localization/locale_provider.dart';

class ReusableDateSelection extends ConsumerStatefulWidget {
  /// Starting date from which the tiles will start
  final DateTime startDate;

  /// Number of dates to show (default 10)
  final int numberOfDates;

  /// Callback when a date is selected
  final ValueChanged<DateTime>? onDateSelected;

  const ReusableDateSelection({
    super.key,
    required this.startDate,
    this.numberOfDates = 10,
    this.onDateSelected,
  });

  @override
  ConsumerState<ReusableDateSelection> createState() =>
      _ReusableDateSelectionState();
}

class _ReusableDateSelectionState extends ConsumerState<ReusableDateSelection> {
  late List<DateTime> dates;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Generate list of dates from startDate
    dates = List.generate(
      widget.numberOfDates,
      (index) => widget.startDate.add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dates.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value;
          final isSelected = index == selectedIndex;

          // Format day/month based on locale
          final dayName = DateFormat('EEE', langCode).format(date);
          final dayNumber = DateFormat('d', langCode).format(date);
          final monthName = DateFormat('MMM', langCode).format(date);

          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              if (widget.onDateSelected != null) {
                widget.onDateSelected!(date);
              }
            },
            borderRadius: BorderRadius.circular(7),
            child: DateTile(
              day: dayName,
              date: dayNumber,
              monthYear: monthName,
              isSelected: isSelected,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  final String day;
  final String date;
  final String monthYear;
  final bool isSelected;

  const DateTile({
    super.key,
    required this.day,
    required this.date,
    required this.monthYear,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                day,
                style: context.bodyLarge?.copyWith(
                  fontSize: 9,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.greyColor,
                ),
              ),
            ),
            Text(
              date,
              style: context.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                monthYear,
                style: context.bodySmall?.copyWith(
                  fontSize: 9,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

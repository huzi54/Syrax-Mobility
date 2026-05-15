import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imo_mobility/core/constants/constants.dart';
import 'package:imo_mobility/core/extensions/context_extension.dart';
import '../provider/book_ride_provider.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/locale_provider.dart';

class DateSelection extends ConsumerWidget {
  const DateSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(bookRideProvider);
    final notifier = ref.read(bookRideProvider.notifier);
    final selectedCalendarDate = notifier.selectedCalendarDate;

    final langCode = ref.watch(localeProvider).languageCode;

    // Ek date kam dikhane ke liye (Responsive layout ke liye jagah banane ko)
    final visibleDates = dates.length > 1
        ? dates.take(dates.length - 1).toList()
        : dates;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. Default Date Tiles (Wrapped in Expanded)
        ...visibleDates.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: InkWell(
                onTap: () => notifier.selectDate(index),
                borderRadius: BorderRadius.circular(7),
                child: DateTile(
                  day: DateFormat('EEE', langCode).format(date.date),
                  date: DateFormat('d', langCode).format(date.date),
                  monthYear: DateFormat('MMM', langCode).format(date.date),
                  isSelected: date.isSelected,
                ),
              ),
            ),
          );
        }),

        // 2. Calendar Button (Select Date)
        Expanded(
          child: InkWell(
            onTap: () => _showCalendarBottomSheet(context, ref),
            borderRadius: BorderRadius.circular(7),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                border: Border.all(color: AppColors.greyColor),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  // FittedBox text ko overflow hone se bachata hai
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        selectedCalendarDate != null
                            ? DateFormat(
                                'd MMM',
                                langCode,
                              ).format(selectedCalendarDate)
                            : AppTranslations.of(
                                context,
                                'selectDate',
                                langCode,
                              ),
                        style: context.bodySmall?.copyWith(
                          fontSize: 9,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showCalendarBottomSheet(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bookRideProvider.notifier);
    final langCode = ref.watch(localeProvider).languageCode;

    final calendarTextStyle = context.bodySmall?.copyWith(
      fontSize: 12,
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold,
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Localizations.override(
          context: context,
          locale: Locale(langCode), // <- override locale here
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: AppColors.whiteColor,
                onSurface: AppColors.blackColor,
              ),
              datePickerTheme: DatePickerThemeData(
                dayStyle: calendarTextStyle,
                weekdayStyle: calendarTextStyle,
                headerHeadlineStyle: calendarTextStyle?.copyWith(fontSize: 14),
                yearStyle: calendarTextStyle,
                todayForegroundColor: const WidgetStatePropertyAll(
                  AppColors.whiteColor,
                ),
              ),
            ),
            child: SizedBox(
              height: 350,
              child: CalendarDatePicker(
                initialDate: notifier.calendarInitialDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (selectedDate) {
                  notifier.updateSelectedDate(selectedDate);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
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
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : AppColors.whiteColor,
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              day,
              style: context.bodyLarge?.copyWith(
                fontSize: 10,
                color: isSelected ? AppColors.whiteColor : AppColors.greyColor,
              ),
            ),
          ),
          Text(
            date,
            style: context.bodyLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
          FittedBox(
            child: Text(
              monthYear,
              style: context.bodySmall?.copyWith(
                fontSize: 10,
                color: isSelected ? AppColors.whiteColor : AppColors.greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:intl/intl.dart';

class DateUtilsHelper {
  // Private constructor to prevent instantiation
  DateUtilsHelper._();

  /// Format DateTime to "Thursday, Feb 26 2026"
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMM d yyyy').format(date);
  }

  /// Optional: Short format "26 Feb 2026"
  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  /// Optional: Only day name "Thursday"
  static String formatDayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Optional: Only month & day "Feb 26"
  static String formatMonthDay(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
}

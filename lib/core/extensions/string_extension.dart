part of 'app_extensions.dart';

extension StringExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    final String lower = toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }
}

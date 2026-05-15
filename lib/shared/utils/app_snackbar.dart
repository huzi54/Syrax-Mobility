import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';

class AppSnackBar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  AppSnackBar.error(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: AppColors.redColor,
      duration: duration,
    );
  }

  AppSnackBar.info(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: AppColors.primaryColor,
      duration: duration,
    );
  }

  AppSnackBar.success(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.green,
      duration: duration,
    );
  }

  void _showSnackBar({
    required String message,
    required Color backgroundColor,
    required Duration duration,
  }) {
    if (scaffoldMessengerKey.currentState == null) {
      return;
    }

    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        dismissDirection: DismissDirection.down,
      ),
    );
  }
}

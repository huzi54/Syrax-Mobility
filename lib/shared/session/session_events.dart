import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imo_mobility/module/auth/views/login_screen.dart';

import '../../routes/route.dart';

import '../services/data/app_data_service.dart';

/// Simple global session events bus.
///
/// Allows lower layers (like the API client) to signal that the auth session
/// is no longer valid (e.g., token/signature expired) without importing UI
/// routing. A top-level listener can react and navigate accordingly.
class SessionEvents {
  SessionEvents._();

  static final StreamController<void> _sessionExpiredController =
      StreamController<void>.broadcast();

  static Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  static void emitSessionExpired() async {
    if (!_sessionExpiredController.isClosed) {
      _sessionExpiredController.add(null);
      AppNavigation.navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Remove all previous routes
      );

      await AppDataService.instance.clearAll();
    }
  }
}

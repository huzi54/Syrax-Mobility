import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class AppLogger {
  static bool isLoggingEnabled = kDebugMode;

  /// General method (private)
  static void _log(String message, String levelTag, String emoji) {
    if (!isLoggingEnabled) return;

    final String traceLine = StackTrace.current.toString().split('\n')[2];
    final String location = _parseLocation(traceLine);

    final String output = '''
[$levelTag] ${DateTime.now().toIso8601String()}
  Location: $location
  Message : $message
''';

    developer.log(output);
  }

  /// Specific level methods
  ///
  static void log(String message) => _log(message, 'DEBUG', '⚪');
  static void info(String message) => _log(message, 'INFO ', '🟢');
  static void warning(String message) => _log(message, 'WARN ', '🟡');
  static void error(String message) => _log(message, 'ERROR', '🔴');

  /// Parses method name and file:line info from stack trace
  static String _parseLocation(String traceLine) {
    try {
      final RegExp regex = RegExp(r'#2\s+(.+)\s+\((.+):(\d+):(\d+)\)');
      final RegExpMatch? match = regex.firstMatch(traceLine);

      if (match != null) {
        final String? method = match.group(1);
        final String? file = match.group(2)?.split('/').last;
        final String? line = match.group(3);
        return '$method@$file:$line';
      }
    } catch (_) {}

    return 'Unknown Location';
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';


import '../logger/app_logger.dart';

/// Logical permission types for the app. This allows using a single API across
/// platforms without passing `permission_handler` types everywhere.
enum PermissionType {
  camera,
  location,
  microphone,
  photos,
  storage,
  notification,
}

/// Result returned by permission helpers.
@immutable
class PermissionResult {
  final PermissionType type;
  final PermissionStatus status;

  const PermissionResult({required this.type, required this.status});

  bool get granted => status.isGranted;
  bool get denied => status.isDenied;
  bool get permanentlyDenied =>
      status.isPermanentlyDenied || status.isRestricted;
  bool get limited => status == PermissionStatus.limited;
}

/// Cross-platform permission helper service with platform-aware semantics.
class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  // Mapping from PermissionType to permission_handler Permission for the
  // current platform. This centralizes any platform-specific choices.
  Permission _mapTypeToPermission(PermissionType type) {
    switch (type) {
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.location:
        return Platform.isIOS
            ? Permission.locationWhenInUse
            : Permission.location;
      case PermissionType.microphone:
        return Permission.microphone;
      case PermissionType.photos:
        // On Android, photos are covered by storage permission; on iOS we
        // request the Photos permission.
        return Platform.isIOS ? Permission.photos : Permission.storage;
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.notification:
        return Permission.notification;
    }
  }

  /// Check the current status for a logical [PermissionType].
  Future<PermissionResult> check(PermissionType type) async {
    final Permission permission = _mapTypeToPermission(type);
    final PermissionStatus status = await permission.status;
    return PermissionResult(type: type, status: status);
  }

  /// Request a single [PermissionType] once and return the result.
  Future<PermissionResult> request(PermissionType type) async {
    final Permission permission = _mapTypeToPermission(type);
    final PermissionStatus status = await permission.request();
    return PermissionResult(type: type, status: status);
  }

  /// Ensure a permission is granted. If not, requests it. If permanently
  /// denied/restricted, opens app settings and re-checks.
  ///
  /// Returns `PermissionResult.granted == true` when granted at the end.
  Future<PermissionResult> ensure(PermissionType type) async {
    final Permission permission = _mapTypeToPermission(type);
    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      return PermissionResult(type: type, status: status);
    }

    // Request permission (this shows the system prompt on first-time)
    status = await permission.request();
    AppLogger.log(
        '[PermissionService] Requested permission for $type, result: $status');

    // Treat 'limited' (iOS Photos) as acceptable — caller can check .limited
    if (status.isGranted || status == PermissionStatus.limited) {
      return PermissionResult(type: type, status: status);
    }

    // If explicitly denied but rationale is available, return denied so UI
    // can show a rationale and try again.
    if (status.isDenied) {
      try {
        final bool rationale = await permission.shouldShowRequestRationale;
        if (rationale) {
          return PermissionResult(type: type, status: status);
        }
      } catch (_) {
        // On some platforms the call may throw; fallthrough to opening settings.
      }
    }

    // For permanently denied / restricted / fallback, open settings and re-check.
    if (status.isPermanentlyDenied ||
        status.isRestricted ||
        !status.isGranted) {
      await openAppSettings();
      final PermissionStatus newStatus = await permission.status;
      return PermissionResult(type: type, status: newStatus);
    }

    return PermissionResult(type: type, status: status);
  }

  /// Ensure multiple permissions and return a map of the results.
  Future<Map<PermissionType, PermissionResult>> ensureAll(
      Iterable<PermissionType> types) async {
    final Map<PermissionType, PermissionResult> results =
        <PermissionType, PermissionResult>{};
    for (final PermissionType t in types) {
      results[t] = await ensure(t);
    }
    return results;
  }

  /// Convenience getters for quick access when calling ensure/request.
  PermissionType get camera => PermissionType.camera;
  PermissionType get location => PermissionType.location;
  PermissionType get microphone => PermissionType.microphone;
  PermissionType get photos => PermissionType.photos;
  PermissionType get storage => PermissionType.storage;
  PermissionType get notification => PermissionType.notification;
}

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

/// A robust, type-safe singleton service for SharedPreferences.
/// Fully production-safe (no generic type issues, no release-mode failures).
class SharedPreferencesService {
  SharedPreferencesService._();
  static final SharedPreferencesService instance = SharedPreferencesService._();

  SharedPreferences? _prefs;

  /// Ensures SharedPreferences is initialized only once.
  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Stores a value of type [T] for the given [key].
  Future<void> set<T>(String key, T value) async {
    await _init();

    try {
      bool result = false;

      if (value is int) {
        result = await _prefs!.setInt(key, value);
      } else if (value is double) {
        result = await _prefs!.setDouble(key, value);
      } else if (value is bool) {
        result = await _prefs!.setBool(key, value);
      } else if (value is String) {
        result = await _prefs!.setString(key, value);
      } else if (value is List<String>) {
        result = await _prefs!.setStringList(key, value);
      } else {
        developer.log(
          'Unsupported type for key: $key',
          name: 'SharedPreferencesService',
        );
        throw Exception('Unsupported type');
      }

      if (!result) {
        developer.log(
          'Failed to save key: $key',
          name: 'SharedPreferencesService',
        );
        throw Exception('Failed to save value for key: $key');
      }

      developer.log(
        'Saved key: $key, value: $value',
        name: 'SharedPreferencesService',
      );
    } catch (e, stack) {
      developer.log(
        'Error saving key: $key, error: $e',
        name: 'SharedPreferencesService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Retrieves a value of type [T] for the given [key].
  /// SAFE in production — no generic comparison (T == int), no tree-shaking issues.
  Future<T?> get<T>(String key) async {
    await _init();

    try {
      dynamic value = _prefs!.get(key);

      if (value is T) {
        developer.log(
          'Retrieved key: $key, value: $value',
          name: 'SharedPreferencesService',
        );
        return value;
      }

      return null;
    } catch (e, stack) {
      developer.log(
        'Error retrieving key: $key, error: $e',
        name: 'SharedPreferencesService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Removes the value for the given [key].
  Future<void> remove(String key) async {
    await _init();
    try {
      await _prefs!.remove(key);
      developer.log('Removed key: $key', name: 'SharedPreferencesService');
    } catch (e, stack) {
      developer.log(
        'Error removing key: $key, error: $e',
        name: 'SharedPreferencesService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Clears all stored values.
  Future<void> clear() async {
    await _init();
    try {
      await _prefs!.clear();
      developer.log('Cleared all keys', name: 'SharedPreferencesService');
    } catch (e, stack) {
      developer.log(
        'Error clearing keys: $e',
        name: 'SharedPreferencesService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}

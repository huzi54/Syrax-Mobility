import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

/// Fully production-safe Secure Storage service.
/// No generic type failures, no tree-shaking issues.
class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Saves any value by converting it to String.
  Future<void> set<T>(String key, T value) async {
    try {
      await _storage.write(key: key, value: value.toString());
      developer.log(
        'Saved key: $key, value: $value',
        name: 'SecureStorageService',
      );
    } catch (e, stack) {
      developer.log(
        'Error saving key: $key, error: $e',
        name: 'SecureStorageService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Retrieves a value safely and converts based on the target T type.
  Future<T?> get<T>(String key) async {
    try {
      final value = await _storage.read(key: key);

      if (value == null) {
        developer.log(
          'No value found for key: $key',
          name: 'SecureStorageService',
        );
        return null;
      }

      dynamic result = value; // start as string

      // Convert safely
      if (T == int) {
        result = int.tryParse(value);
      } else if (T == double) {
        result = double.tryParse(value);
      } else if (T == bool) {
        result = value.toLowerCase() == 'true';
      } else if (T == String) {
        result = value;
      } else {
        throw Exception('Unsupported type for key: $key');
      }

      developer.log(
        'Retrieved key: $key, value: $result',
        name: 'SecureStorageService',
      );

      return result as T?;
    } catch (e, stack) {
      developer.log(
        'Error retrieving key: $key, error: $e',
        name: 'SecureStorageService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Remove key.
  Future<void> remove(String key) async {
    try {
      await _storage.delete(key: key);
      developer.log('Removed key: $key', name: 'SecureStorageService');
    } catch (e, stack) {
      developer.log(
        'Error removing key: $key, error: $e',
        name: 'SecureStorageService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Clear all.
  Future<void> clear() async {
    try {
      await _storage.deleteAll();
      developer.log('Cleared all keys', name: 'SecureStorageService');
    } catch (e, stack) {
      developer.log(
        'Error clearing keys: $e',
        name: 'SecureStorageService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}

import 'shared_preferences_service.dart';
import 'secure_storage_service.dart';

class AppDataService {
  AppDataService._();
  static final AppDataService instance = AppDataService._();

  final SharedPreferencesService _prefs = SharedPreferencesService.instance;
  final SecureStorageService _secure = SecureStorageService.instance;

  // SharedPreferences
  Future<void> setPrefs<T>(String key, T value) async =>
      await _prefs.set<T>(key, value);
  Future<T?> getPrefs<T>(String key) async => await _prefs.get<T>(key);
  Future<void> removePrefs(String key) async => await _prefs.remove(key);
  Future<void> clearPrefs() async => await _prefs.clear();

  // SecureStorage
  Future<void> setSecure<T>(String key, T value) async =>
      await _secure.set<T>(key, value);
  Future<T?> getSecure<T>(String key) async => await _secure.get<T>(key);
  Future<void> removeSecure(String key) async => await _secure.remove(key);
  Future<void> clearSecure() async => await _secure.clear();

  // Clear all data
  Future<void> clearAll() async {
    await clearPrefs();
    await clearSecure();
  }
}

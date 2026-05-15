import 'app_data_service.dart';

/// Centralized keys for app data storage.
///
/// Add new keys here for both SharedPreferences and SecureStorage.
class AppDataKeys {
  static const String userToken = 'accessToken';

  static const String residentId = 'resident_id';
  static const String residentName = 'resident_name';
  static const String phone = 'email';
  static const String apt = 'apt';
  static const String aptName = 'apt_name';
  static const String residentAddress = 'resident_address';
  static const String guardHouseId = 'guard_house_id';
  static const String communityId = 'community_id';
  static const String buildingId = 'building_id';
  static const String languageId = 'language_id';
  static const String smsConsent = 'sms_consent';
  static const String privacyPolicyAccepted = 'privacy_policy_accepted';

  static const String onboardingComplete = 'onboarding_complete';
  static const String communitySelectionComplete =
      'community_selection_complete';
  static const String themeMode = 'theme_mode';
  static const String userProfile = 'user_profile';
  static const String rememberedPhone = 'remembered_phone';
  static const String guardNotes = 'gurad_notes';
  static const String fcmToken = 'fcm_token';
  static const String notificationEnabled = 'notification_enabled';
  static const String notificationSnoozeUntil = 'notification_snooze_until';
}

/// Extension on String to provide easy access to app data storage functions.
///
/// Usage:
///   AppDataKeys.userToken.saveToPrefs('abc');
// final token = AppDataKeys.userToken.getFromPrefs<String>();
//  await AppDataKeys.userToken.removeFromPrefs();
///   ... same for secure storage ...
extension AppDataKeyExtensions on String {
  // SharedPreferences
  Future<void> saveToPrefs<T>(T value) async =>
      await AppDataService.instance.setPrefs<T>(this, value);

  Future<T?> getFromPrefs<T>() async =>
      await AppDataService.instance.getPrefs<T>(this);

  Future<void> removeFromPrefs() async =>
      await AppDataService.instance.removePrefs(this);

  // SecureStorage
  Future<void> saveToSecure<T>(T value) async =>
      await AppDataService.instance.setSecure<T>(this, value);

  Future<T?> getFromSecure<T>() async =>
      await AppDataService.instance.getSecure<T>(this);

  Future<void> removeFromSecure() async =>
      await AppDataService.instance.removeSecure(this);
}

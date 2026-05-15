import '../../../core/api/auth/model/login_response.dart';
import 'app_data_keys.dart';

class LoginDataService {
  LoginDataService._();

  /// Handles remember me functionality by saving or clearing the email
  static Future<void> handleRememberMe({
    required bool rememberMe,
    required String? phone,
  }) async {
    if (rememberMe && phone != null && phone.isNotEmpty) {
      await AppDataKeys.rememberedPhone.saveToPrefs(phone);
    } else {
      // Clear remembered phone if remember me is disabled or no phone
      await AppDataKeys.rememberedPhone.removeFromPrefs();
    }
  }

  /// Private method to save login data
  static Future<void> _saveUserData(LoginData? data) async {
    await AppDataKeys.userToken.saveToSecure(data?.accessToken ?? "");
    await AppDataKeys.residentId.saveToSecure(data?.residentId ?? 0);
    await AppDataKeys.residentName.saveToSecure(data?.residentName ?? "");
    await AppDataKeys.guardNotes.saveToSecure(data?.guardNotes ?? "");
    await AppDataKeys.phone.saveToSecure(data?.email ?? "");

    await AppDataKeys.rememberedPhone.saveToSecure(
      data?.phone ?? "",
    ); // added phon
    await AppDataKeys.apt.saveToSecure(data?.apt ?? "");
    await AppDataKeys.aptName.saveToSecure(data?.aptName ?? "");
    await AppDataKeys.residentAddress.saveToSecure(data?.address ?? "");
    await AppDataKeys.guardHouseId.saveToSecure(data?.guardHouseId ?? 0);
    await AppDataKeys.buildingId.saveToSecure(data?.buildingId ?? 0);
    await AppDataKeys.languageId.saveToSecure(data?.languageId ?? "");
  }

  static Future<void> _saveAppSettings(LoginData? data) async {
    await AppDataKeys.guardNotes.saveToSecure<String>(data?.guardNotes ?? "");
    await AppDataKeys.notificationEnabled.saveToSecure<bool>(
      data?.notificationEnabled ?? false,
    );
    await AppDataKeys.notificationSnoozeUntil.saveToSecure<String>(
      data?.notificationSnoozeUntil ?? "",
    );
    await AppDataKeys.fcmToken.saveToSecure<String>(data?.fcmToken ?? "");
  }

  /// Private method to save community data
  static Future<void> _saveCommunityData(LoginData? data) async {
    final communityId = data?.communityId ?? 0;
    await AppDataKeys.communityId.saveToSecure(communityId);

    // Only mark community selection complete if we have a valid community ID
    if (communityId > 0) {
      await AppDataKeys.communitySelectionComplete.saveToSecure(true);
    } else {
      // Clear community selection flag if no valid community
      await AppDataKeys.communitySelectionComplete.removeFromSecure();
    }
  }
}

Future<void> saveLoginData(LoginData model) async {
  await LoginDataService._saveUserData(model);
  await LoginDataService._saveCommunityData(model);
  await LoginDataService._saveAppSettings(model);
}

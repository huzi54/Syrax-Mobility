// // shared/providers/splash_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import '../../../shared/services/data/app_data_keys.dart';

// enum SplashNavigationTarget {
//   login,
//   communities,
//   main,
//   loading,
//   smsConsent,
//   privacyPolicy,
// }

// class SplashState {
//   final SplashNavigationTarget navigationTarget;
//   final bool isLoading;
//   final String? error;

//   SplashState({
//     this.navigationTarget = SplashNavigationTarget.loading,
//     this.isLoading = true,
//     this.error,
//   });

//   SplashState copyWith({
//     SplashNavigationTarget? navigationTarget,
//     bool? isLoading,
//     String? error,
//   }) {
//     return SplashState(
//       navigationTarget: navigationTarget ?? this.navigationTarget,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }
// }

// class SplashNotifier extends StateNotifier<SplashState> {
//   Ref ref;
//   SplashNotifier(this.ref) : super(SplashState());

//   Future<void> checkAuthenticationAndCommunity() async {
//     state = state.copyWith(isLoading: true, error: null);

//     try {
//       // Check if user has access token
//       final token = await AppDataKeys.userToken.getFromSecure<String>();
//       final rememberedEmail = await AppDataKeys.phone.getFromPrefs<String>();
//       final rememberMe = rememberedEmail != null && rememberedEmail.isNotEmpty;

//       if (token == null || token.isEmpty || !rememberMe) {
//         // No access token or remember me is false - clear data and go to login
//         if (!rememberMe) {
//           await _clearUserData();
//         }
//         state = state.copyWith(
//           navigationTarget: SplashNavigationTarget.login,
//           isLoading: false,
//         );
//         return;
//       }

//       // User is logged in, check if community selection is complete
//       final communitySelectionComplete = await AppDataKeys
//           .communitySelectionComplete
//           .getFromSecure<bool>();
//       final communityId = await AppDataKeys.communityId.getFromSecure<int>();

//       // Check if community selection is properly completed
//       final isCommunityReady =
//           (communitySelectionComplete == true) &&
//           (communityId != null && communityId > 0);

//       if (isCommunityReady) {
//         // Community is properly selected, go to main app
//         await ref.read(appSettingsProvider.notifier).loadAppSettings();

//         bool smsConsent = await AppDataKeys.smsConsent.getFromSecure() ?? false;
//         bool privacyAccepted =
//             await AppDataKeys.privacyPolicyAccepted.getFromSecure() ?? false;

//         state = state.copyWith(
//           navigationTarget: smsConsent
//               ? privacyAccepted
//                     ? SplashNavigationTarget.main
//                     : SplashNavigationTarget.privacyPolicy
//               : SplashNavigationTarget.smsConsent,
//           isLoading: false,
//         );

//         return;
//       } else {
//         // Community not selected or incomplete, go to community selection
//         state = state.copyWith(
//           navigationTarget: SplashNavigationTarget.communities,
//           isLoading: false,
//         );
//       }
//     } catch (e) {
//       // On any error, go to login to be safe
//       state = state.copyWith(
//         navigationTarget: SplashNavigationTarget.login,
//         isLoading: false,
//         error: 'Authentication check failed: $e',
//       );
//     }
//   }

//   Future<void> _clearUserData() async {
//     try {
//       await AppDataKeys.userToken.removeFromSecure();
//       await AppDataKeys.residentId.removeFromSecure();
//       await AppDataKeys.residentName.removeFromSecure();
//       await AppDataKeys.phone.removeFromSecure();
//       await AppDataKeys.apt.removeFromSecure();
//       await AppDataKeys.aptName.removeFromSecure();
//       await AppDataKeys.residentAddress.removeFromSecure();
//       await AppDataKeys.guardHouseId.removeFromSecure();
//       await AppDataKeys.communityId.removeFromSecure();
//       await AppDataKeys.buildingId.removeFromSecure();
//       await AppDataKeys.languageId.removeFromSecure();
//       await AppDataKeys.communitySelectionComplete.removeFromSecure();
//       await AppDataKeys.rememberedPhone.removeFromPrefs();
//       await AppDataKeys.guardNotes.removeFromSecure();
//       await AppDataKeys.notificationEnabled.removeFromSecure();
//       await AppDataKeys.notificationSnoozeUntil.removeFromSecure();
//       await AppDataKeys.fcmToken.removeFromSecure();

//       // Remembered email is cleared to disable remember me
//     } catch (e) {
//       // Ignore errors during cleanup
//     }
//   }
// }

// final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>(
//   (Ref ref) => SplashNotifier(ref),
// );

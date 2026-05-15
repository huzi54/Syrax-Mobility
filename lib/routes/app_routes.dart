// ignore_for_file: unused_element

part of 'route.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';

  //////////////////////////////// AUTH ////////////////////////////////
  static const String signUp = '/sign_up';
  static const String signIn = '/sign_in';
  static const String verificationOtp = '/verification_otp';
  static const String linkVerification = '/link_verification';
  static const String forgetPassword = '/forget_password';
  static const String emailVerification = '/email_verification';
  static const String otpVerification = '/otp_verification';
  static const String resetPassword = '/reset_password';

  /////////////////////////////////// PAYMENTS ////////////////////////////////
  static const String addCard = '/add_card';
  static const String rentalBilling = '/rental_billing';
  static const String finalStatement = '/final_statement';
  static const String receipt = '/receipt';
  static const String receiptDetail = '/receipt_detail';
  static const String postPaymentFeedback = '/post_payment_feedback';

  /////////////////////////////////// SETTINGS ////////////////////////////////
  static const String settings = '/settings';
  static const String profileSettings = '/profile_settings';
  static const String changePasswordSettings = '/change_password_settings';
  static const String notificationSettings = '/notification_settings';
  static const String privacySecurity = '/privacy_security';

  /////////////////////////////////// NOTIFICATIONS ////////////////////////////////
  static const String notifications = '/notifications';

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    final Map<String, dynamic>? args =
        routeSettings.arguments as Map<String, dynamic>?;

    final Map<String, Widget Function()> routeBuilders =
        <String, Widget Function()>{
          // splash: () => const SplashView(),
          // home: () => const HomeView(),
        };

    T parseModel<T>(String key, T Function(Map<String, dynamic>) fromJson) {
      final Map<String, dynamic>? modelMap =
          args?[key] as Map<String, dynamic>?;
      if (modelMap == null) {
        throw Exception('Missing argument: $key');
      }
      return fromJson(modelMap);
    }

    final Widget Function()? pageBuilder = routeBuilders[routeSettings.name];
    if (pageBuilder != null) {
      return pageBuilder().asRoute();
    }

    // Default fallback
    return Scaffold(
      body: Center(child: Text('No route defined for "${routeSettings.name}"')),
    ).asRoute();
  }
}

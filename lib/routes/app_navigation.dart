part of 'route.dart';

/// Enum representing different navigation transition types.
enum NavigationType { push, replace, removeUntil }

/// A centralized navigation helper class.
///
/// Uses a global [navigatorKey] to perform navigation without
/// needing a [BuildContext].
class AppNavigation {
  /// Global key to access the navigator state.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Checks if the navigator can pop the current route.
  static bool canPop() => navigatorKey.currentState?.canPop() ?? false;

  /// Pops the current route with optional [data].
  static void pop([dynamic data]) {
    AppLogger.log('[Navigation] Pop current route');
    navigatorKey.currentState?.maybePop(data);
  }

  /// Pops all routes until the first route.
  static void popAll() {
    AppLogger.log('[Navigation] Pop all routes');
    navigatorKey.currentState?.popUntil((Route route) => route.isFirst);
  }

  /// Returns the current active route if available.
  static Route? get currentRouteObject {
    final BuildContext? context = navigatorKey.currentState?.context;
    return context != null ? ModalRoute.of(context) : null;
  }

  /// Internal method to create platform-aware routes with native transitions.
  static Route<T> _createRoute<T>(Widget page, {String? routeName}) {
    final TargetPlatform platform = Theme.of(
      navigatorKey.currentContext!,
    ).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      //  Native iOS slide transition
      return CupertinoPageRoute<T>(
        builder: (_) => page,
        settings: RouteSettings(name: routeName),
      );
    } else {
      // Custom Android transition (fade + slight slide)
      return PageRouteBuilder<T>(
        pageBuilder: (_, _, _) => page,
        settings: RouteSettings(name: routeName),
        transitionsBuilder:
            (
              _,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              // Example: Fade + Slide from right
              final CurvedAnimation fade = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );

              final Animation<Offset> slide = Tween<Offset>(
                begin: const Offset(0.1, 0.0), // slightly from right
                end: Offset.zero,
              ).animate(fade);

              return FadeTransition(
                opacity: fade,
                child: SlideTransition(position: slide, child: child),
              );
            },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }
  }

  /// Internal method to navigate to a new [page] with a specified [NavigationType].
  ///
  /// Optionally specify [routeName] and [arguments].
  static Future<T?> _navigate<T>(
    Widget page, {
    String? routeName,
    Object? arguments,
    NavigationType type = NavigationType.push,
  }) {
    final Route<T> route = _createRoute<T>(page, routeName: routeName);

    final NavigatorState nav = navigatorKey.currentState!;

    switch (type) {
      case NavigationType.push:
        AppLogger.log('[Navigation] Push -> $routeName');
        return nav.push<T>(route);

      case NavigationType.replace:
        AppLogger.log('[Navigation] Replace -> $routeName');
        return nav.pushReplacement<T, T>(route);

      case NavigationType.removeUntil:
        AppLogger.log('[Navigation] RemoveUntil -> $routeName');
        return nav.pushAndRemoveUntil<T>(route, (Route r) => false);
    }
  }

  /// Pushes a new [page] onto the navigation stack.
  ///
  /// Optionally specify [routeName] and [arguments].
  static Future<T?> push<T>(
    Widget page, {
    String? routeName,
    Object? arguments,
  }) => _navigate<T>(
    page,
    routeName: routeName,
    arguments: arguments,
    type: NavigationType.push,
  );

  /// Replaces the current route with a new [page].
  ///
  /// Optionally specify [routeName] and [arguments].
  static Future<T?> pushReplacement<T>(
    Widget page, {
    String? routeName,
    Object? arguments,
  }) => _navigate<T>(
    page,
    routeName: routeName,
    arguments: arguments,
    type: NavigationType.replace,
  );

  /// Removes all existing routes and pushes a new [page].
  ///
  /// Optionally specify [routeName] and [arguments].
  static Future<T?> pushAndRemoveUntil<T>(
    Widget page, {
    String? routeName,
    Object? arguments,
  }) => _navigate<T>(
    page,
    routeName: routeName,
    arguments: arguments,
    type: NavigationType.removeUntil,
  );

  /// Pushes a named route onto the navigation stack.
  ///
  /// Optionally pass [arguments].
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) async {
    AppLogger.log('[Navigation] pushNamed -> $routeName');
    return navigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replaces the current route with a named route.
  ///
  /// Optionally pass [arguments].
  static Future<T?> pushReplacementNamed<T>(
    String routeName, {
    Object? arguments,
  }) async {
    AppLogger.log('[Navigation] pushReplacementNamed -> $routeName');
    return navigatorKey.currentState?.pushReplacementNamed<T, T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Removes all routes and pushes a named route.
  ///
  /// Optionally pass [arguments].
  static Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) async {
    AppLogger.log('[Navigation] pushNamedAndRemoveUntil -> $routeName');
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
      (Route route) => false,
      arguments: arguments,
    );
  }

  // Password Reset Flow Navigation Helpers

  /// Navigate to email verification for password reset
  static Future<void> toEmailVerification({String? email}) async {
    await pushNamed(AppRoutes.emailVerification, arguments: {'email': email});
  }

  /// Navigate to OTP verification for password reset
  static Future<void> toOtpVerification({required String email}) async {
    await pushNamed(AppRoutes.otpVerification, arguments: {'email': email});
  }

  /// Navigate to reset password screen
  static Future<void> toResetPassword({required String email}) async {
    await pushNamed(AppRoutes.resetPassword, arguments: {'email': email});
  }
}

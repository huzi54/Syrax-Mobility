import 'package:flutter/material.dart';

import 'app_theme_extension.dart';

extension BuildContextEntension<T> on BuildContext {
  //

  //RESPONSIVE

  //

  bool get isMobile => MediaQuery.of(this).size.width <= 500.0;

  bool get isTablet =>
      MediaQuery.of(this).size.width < 1024.0 &&
      MediaQuery.of(this).size.width >= 650.0;

  bool get isSmallTablet =>
      MediaQuery.of(this).size.width < 650.0 &&
      MediaQuery.of(this).size.width > 500.0;

  bool get isDesktop => MediaQuery.of(this).size.width >= 1024.0;

  bool get isSmall =>
      MediaQuery.of(this).size.width < 850.0 &&
      MediaQuery.of(this).size.width >= 560.0;

  //

  //MEDIA QUERY

  //

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get size => MediaQuery.of(this).size;

  double get paddingTop => MediaQuery.of(this).padding.top;

  double get paddingBottom => MediaQuery.of(this).padding.bottom;

  double get paddingDefault => height * 0.02;

  //

  //TEXT STYLES

  //

  TextStyle? get bodyExtraSmall =>
      bodySmall!.copyWith(fontSize: 10, fontWeight: FontWeight.w400);

  TextStyle? get bodySmall => Theme.of(
        this,
      )
          .textTheme
          .bodySmall!
          .copyWith(fontSize: 12, fontWeight: FontWeight.w400);

  TextStyle? get bodyMedium => Theme.of(
        this,
      )
          .textTheme
          .bodyMedium!
          .copyWith(fontSize: 14, fontWeight: FontWeight.w400);

  TextStyle? get bodyLarge => Theme.of(
        this,
      )
          .textTheme
          .bodyLarge!
          .copyWith(fontSize: 16, fontWeight: FontWeight.w400);

  TextStyle? get titleSmall => Theme.of(
        this,
      )
          .textTheme
          .titleSmall!
          .copyWith(fontSize: 18, fontWeight: FontWeight.w400);

  TextStyle? get titleMedium => Theme.of(
        this,
      )
          .textTheme
          .titleMedium!
          .copyWith(fontSize: 20, fontWeight: FontWeight.w400);

  TextStyle? get titleLarge => Theme.of(
        this,
      )
          .textTheme
          .titleLarge!
          .copyWith(fontSize: 22, fontWeight: FontWeight.w400);

  TextStyle? get headlineSmall => Theme.of(this)
      .textTheme
      .headlineSmall!
      .copyWith(fontWeight: FontWeight.w600, fontSize: 24);

  TextStyle? get headlineMedium => Theme.of(this)
      .textTheme
      .headlineMedium!
      .copyWith(fontWeight: FontWeight.w600, fontSize: 28);

  TextStyle? get headlineLarge => Theme.of(this)
      .textTheme
      .headlineLarge!
      .copyWith(fontWeight: FontWeight.w600, fontSize: 32);

  TextStyle? get gradientStyle => titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        foreground: Paint()
          ..shader = const LinearGradient(
            colors: <Color>[Color(0xffE7873A), Color(0xffDE4D3C)],
          ).createShader(const Rect.fromLTWH(0.0, 0.0, 400.0, 50.0)),
      );

  //

  //COLORS

  //

  ThemeData get theme => Theme.of(this);

  /// Get current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get primaryColorDark => Theme.of(this).primaryColorDark;

  Color get primaryColorLight => Theme.of(this).primaryColorLight;

  Color get primary => Theme.of(this).colorScheme.primary;

  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  Color get cardColor => Theme.of(this).cardColor;

  Color get error => Theme.of(this).colorScheme.error;

  Color get onError => Theme.of(this).colorScheme.onError;

  Color get background => Theme.of(this).colorScheme.surface;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  // extensions

  Gradient get vertical =>
      Theme.of(this).extension<AppThemeExtension>()!.vertical;

  Gradient get horizontal =>
      Theme.of(this).extension<AppThemeExtension>()!.horizontal;

  Color get extraLightGrey =>
      Theme.of(this).extension<AppThemeExtension>()!.extraLightGrey;

  Color get lightGrey =>
      Theme.of(this).extension<AppThemeExtension>()!.lightGrey;

  Color get orange => Theme.of(this).extension<AppThemeExtension>()!.orange;

  /// Dynamic icon color
  Color get themedIconColor => colorScheme.onSurfaceVariant;

  /// Dynamic icon color
  Color get backgroundColor => colorScheme.surface;

  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (BuildContext context) => Wrap(children: <Widget>[child]),
    );
  }

  Future<dynamic> showOverlayPopup({bool barrierDismissible = false}) async {
    return showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => const AlertDialog(),
    );
  }

  void pop([T? result]) {
    Navigator.of(this).pop(result);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message,
  ) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),

        behavior: SnackBarBehavior.floating,

        // backgroundColor: primary,
      ),
    );
  }

  Future<T?> showAlertDialog(List<Widget> children) {
    return showDialog(
      context: this,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

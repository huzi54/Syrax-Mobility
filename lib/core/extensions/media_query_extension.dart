import 'package:flutter/material.dart';

extension MediaQueryX on BuildContext {
  /// Screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Screen width
  double get screenWidth => screenSize.width;

  /// Screen height
  double get screenHeight => screenSize.height;

  /// Screen aspect ratio
  double get screenAspectRatio => screenSize.aspectRatio;

  /// Pixel density
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// Orientation
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// System padding (safe areas like status bar, notch, etc.)
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  double get paddingTop => padding.top;

  double get paddingBottom => padding.bottom;

  double get paddingLeft => padding.left;

  double get paddingRight => padding.right;

  /// View insets (e.g., keyboard)
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// True if the keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// View padding (may differ from padding on Android)
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// System gesture insets (areas reserved for system gestures)
  EdgeInsets get systemGestureInsets => MediaQuery.systemGestureInsetsOf(this);

  /// Text scale factor
  // double get textScale => MediaQuery.textScaleFactorOf(this);
}

import 'package:flutter/material.dart';

extension ColorExtenstion on Color {
  ColorFilter filter() {
    return ColorFilter.mode(this, BlendMode.srcIn);
  }
}

extension ColorBrightnessExtension on Color {
  bool get isDark =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.dark;

  bool get isLight =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.light;
}

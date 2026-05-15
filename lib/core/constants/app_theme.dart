import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  // -------- FONT FAMILY --------
  static const String _fontFamily = 'Outfit';

  static final ThemeData lightTheme = ThemeData(
    // -------- FONT FAMILY --------
    fontFamily: _fontFamily,

    // -------- PRIMARY COLORS --------
    primarySwatch: MaterialColor(0xff0077A6, {
      50: Color(0xFFE0F2F8),
      100: Color(0xFFB3DFEE),
      200: Color(0xFF80CAE3),
      300: Color(0xFF4DB5D8),
      400: Color(0xFF26A5D0),
      500: Color(0xFF0077A6),
      600: Color(0xFF006F9F),
      700: Color(0xFF006495),
      800: Color(0xFF005A8C),
      900: Color(0xFF004773),
    }),
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      primaryContainer: Color(0xFFE0F2F8),
      secondary: AppColors.secondaryColor,
      secondaryContainer: Color(0xFFE8F5E8),
      surface: AppColors.whiteColor,
      error: AppColors.redColor,
      onPrimary: AppColors.whiteColor,
      onSecondary: AppColors.whiteColor,
      onSurface: AppColors.blackColor,
      onError: AppColors.whiteColor,
    ),

    // -------- APP BAR THEME --------
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.whiteColor,
        fontFamily: _fontFamily,
      ),
    ),

    // -------- ELEVATED BUTTON THEME --------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
      ),
    ),

    // -------- TEXT BUTTON THEME --------
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,

        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
      ),
    ),

    // -------- OUTLINED BUTTON THEME --------
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Outfit',
        ),
      ),
    ),

    // -------- INPUT DECORATION THEME --------
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.greyColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.greyColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.redColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.redColor, width: 2),
      ),
      fillColor: AppColors.whiteColor,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(
        color: AppColors.greyColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // -------- CARD THEME --------
    cardTheme: CardThemeData(
      color: AppColors.whiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(8),
    ),

    // -------- FLOATING ACTION BUTTON THEME --------
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.whiteColor,
    ),

    // -------- PROGRESS INDICATOR THEME --------
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
    ),

    // -------- CHECKBOX THEME --------
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.whiteColor;
      }),
      checkColor: WidgetStateProperty.all(AppColors.whiteColor),
      overlayColor: WidgetStateProperty.all(
        AppColors.primaryColor.withValues(alpha: 0.1),
      ),
    ),

    // -------- RADIO THEME --------
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.greyColor;
      }),
    ),

    // -------- SWITCH THEME --------
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.greyColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor.withValues(alpha: 0.5);
        }
        return AppColors.greyColor.withValues(alpha: 0.3);
      }),
    ),

    // // -------- TEXT THEME --------
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ).apply(bodyColor: Colors.black, displayColor: Colors.black),

    // -------- BACKGROUND COLORS --------
    scaffoldBackgroundColor: Color(0xfff1f2f6),
    // scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
  );
}

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.grey.shade200,
      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppConstants.extraLargeBorderRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: AppConstants.headerStyle,
        titleMedium: AppConstants.sectionTitleStyle,
        bodyMedium: AppConstants.labelStyle,
        labelMedium: AppConstants.subtitleStyle,
      ),
    );
  }

  static Color get accentColor => Colors.blue.shade400;

  static BoxDecoration get sidePanelDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.95),
    borderRadius: BorderRadius.circular(AppConstants.extraLargeBorderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 20,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ],
    border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
  );

  static BoxDecoration get debugBorderDecoration =>
      BoxDecoration(border: Border.all(color: Colors.red));

  static BoxDecoration get outputBorderDecoration =>
      BoxDecoration(border: Border.all(color: Colors.black, width: 2));
}

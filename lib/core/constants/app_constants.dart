import 'package:flutter/material.dart';

class AppConstants {
  // UI Constants
  static const double defaultGap = 32.0;
  static const double defaultTitleHeight = 100.0;
  static const double defaultTitleFontSize = 28.0;
  static const String defaultTitleFontFamily = 'Roboto';
  static const Color defaultTitleColor = Colors.black;
  static const Color defaultAccentColor = Colors.blue;

  // Grid Constants
  static const int defaultGridColumns = 3;
  static const int defaultGridRows = 3;
  static const List<int> availableGridSizes = [2, 3, 4, 5];

  // Output Size Constants
  static const int defaultOutputWidth = 1200;
  static const int defaultOutputHeight = 800;
  static const int sizeIncrement = 10;
  static const int minSize = 10;

  // Animation Constants
  static const Duration defaultAnimationDuration = Duration(milliseconds: 200);
  static const Duration expandAnimationDuration = Duration(milliseconds: 200);

  // Spacing Constants
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 18.0;
  static const double extraLargeSpacing = 24.0;

  // Border Radius Constants
  static const double smallBorderRadius = 6.0;
  static const double mediumBorderRadius = 10.0;
  static const double largeBorderRadius = 12.0;
  static const double extraLargeBorderRadius = 16.0;

  // Container Sizes
  static const double colorPickerSize = 36.0;
  static const double colorPickerHeight = 24.0;
  static const double inputFieldWidth = 80.0;
  static const double sidePanelWidth = 340.0;

  // Text Styles
  static const TextStyle sectionTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.5,
  );

  static const TextStyle headerStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    letterSpacing: 0.5,
  );

  static const TextStyle labelStyle = TextStyle(fontWeight: FontWeight.w400);

  static const TextStyle subtitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    letterSpacing: 0.2,
  );
}

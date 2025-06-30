import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../shared/models/background_type.dart';

class BannerService {
  /// Calculates the optimal scale ratio for the banner based on screen constraints
  static double calculateScaleRatio({
    required double screenWidth,
    required double screenHeight,
    required int outputWidth,
    required int outputHeight,
  }) {
    final widthRatio = outputWidth / screenWidth;
    final heightRatio = outputHeight / screenHeight;
    double scaleRatio = max(widthRatio, heightRatio);
    return scaleRatio < 1 ? 1 : scaleRatio;
  }

  /// Calculates banner dimensions based on scale ratio
  static Size calculateBannerDimensions({
    required int outputWidth,
    required int outputHeight,
    required double scaleRatio,
  }) {
    return Size(outputWidth / scaleRatio, outputHeight / scaleRatio);
  }

  /// Creates box decoration for banner background
  static BoxDecoration createBannerDecoration(BackgroundType backgroundType) {
    if (backgroundType is BackgroundColor) {
      return BoxDecoration(color: backgroundType.color);
    } else if (backgroundType is BackgroundGradient) {
      return BoxDecoration(gradient: backgroundType.gradient);
    }
    return const BoxDecoration();
  }

  /// Validates grid dimensions
  static bool isValidGridDimensions(int columns, int rows) {
    return columns >= 2 && columns <= 5 && rows >= 2 && rows <= 5;
  }

  /// Validates output dimensions
  static bool isValidOutputDimensions(int width, int height) {
    return width > 0 && height > 0 && width <= 4000 && height <= 4000;
  }

  /// Calculates total grid cells
  static int calculateTotalCells(int columns, int rows) {
    return columns * rows;
  }

  /// Gets image at specific grid position
  static Uint8List? getImageAtPosition(
    List<Uint8List> images,
    int row,
    int column,
    int totalColumns,
  ) {
    final index = row * totalColumns + column;
    return images.length > index ? images[index] : null;
  }

  /// Validates image list
  static bool hasValidImages(List<Uint8List> images) {
    return images.isNotEmpty && images.length <= 25; // Max 5x5 grid
  }
}

import 'dart:typed_data';
import '../../../../shared/models/background_type.dart';
import '../../../../core/constants/app_constants.dart';
import 'device_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Title-related providers
final titleProvider = StateProvider<String>((ref) => "My App Showcase");
final titleFontSizeProvider = StateProvider<double>(
  (ref) => AppConstants.defaultTitleFontSize,
);
final titleColorProvider = StateProvider<Color>(
  (ref) => AppConstants.defaultTitleColor,
);
final titleFontFamilyProvider = StateProvider<String>(
  (ref) => AppConstants.defaultTitleFontFamily,
);
final titleHeightProvider = Provider<double>(
  (ref) => AppConstants.defaultTitleHeight,
);

// Image and grid providers
final imagesProvider = StateProvider<List<Uint8List>>((ref) => []);
final gridColumnsProvider = StateProvider<int>(
  (ref) => AppConstants.defaultGridColumns,
);
final gridRowsProvider = StateProvider<int>(
  (ref) => AppConstants.defaultGridRows,
);

// Output size providers
final outputWidthProvider = StateProvider<int>(
  (ref) => AppConstants.defaultOutputWidth,
);
final outputHeightProvider = StateProvider<int>(
  (ref) => AppConstants.defaultOutputHeight,
);

// Style providers
final bgTypeProvider = StateProvider<BackgroundType>(
  (ref) => const BackgroundColor(Colors.white),
);
final showBordersProvider = StateProvider<bool>((ref) => true);
final gapProvider = StateProvider<double>((ref) => AppConstants.defaultGap);
final deviceFrameProvider = StateProvider<DeviceFrameType>(
  (ref) => DeviceFrameType.iphone,
);

// Computed providers
final totalGridCellsProvider = Provider<int>((ref) {
  final columns = ref.watch(gridColumnsProvider);
  final rows = ref.watch(gridRowsProvider);
  return columns * rows;
});

final hasValidImagesProvider = Provider<bool>((ref) {
  final images = ref.watch(imagesProvider);
  return images.isNotEmpty && images.length <= 25;
});

final canDownloadProvider = Provider<bool>((ref) {
  return ref.watch(hasValidImagesProvider);
});

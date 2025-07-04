import 'dart:typed_data';
import '../../../../shared/models/background_type.dart';
import '../../data/providers/device_frame.dart';

class BannerConfig {
  final int gridColumns;
  final int gridRows;
  final int outputWidth;
  final int outputHeight;
  final String title;
  final double titleFontSize;
  final int titleColorValue;
  final String titleFontFamily;
  final BackgroundType bgType;
  final bool showBorders;
  final double gap;
  final DeviceFrameType deviceFrame;
  final List<Uint8List> images;

  BannerConfig({
    required this.gridColumns,
    required this.gridRows,
    required this.outputWidth,
    required this.outputHeight,
    required this.title,
    required this.titleFontSize,
    required this.titleColorValue,
    required this.titleFontFamily,
    required this.bgType,
    required this.showBorders,
    required this.gap,
    required this.deviceFrame,
    required this.images,
  });

  BannerConfig copyWith({
    int? gridColumns,
    int? gridRows,
    int? outputWidth,
    int? outputHeight,
    String? title,
    double? titleFontSize,
    int? titleColorValue,
    String? titleFontFamily,
    BackgroundType? bgType,
    bool? showBorders,
    double? gap,
    DeviceFrameType? deviceFrame,
    List<Uint8List>? images,
  }) {
    return BannerConfig(
      gridColumns: gridColumns ?? this.gridColumns,
      gridRows: gridRows ?? this.gridRows,
      outputWidth: outputWidth ?? this.outputWidth,
      outputHeight: outputHeight ?? this.outputHeight,
      title: title ?? this.title,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleColorValue: titleColorValue ?? this.titleColorValue,
      titleFontFamily: titleFontFamily ?? this.titleFontFamily,
      bgType: bgType ?? this.bgType,
      showBorders: showBorders ?? this.showBorders,
      gap: gap ?? this.gap,
      deviceFrame: deviceFrame ?? this.deviceFrame,
      images: images ?? this.images,
    );
  }

  // Helper to get Color from value (for UI, if needed)
  // Color get titleColor => Color(titleColorValue);

  double get titleHeight => 100.0; // Default or computed value
}

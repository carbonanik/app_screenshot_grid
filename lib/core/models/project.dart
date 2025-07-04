import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../../features/banner_generator/data/providers/device_frame.dart';
import '../../shared/models/background_type.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  int gridColumns;
  @HiveField(1)
  int gridRows;
  @HiveField(2)
  int outputWidth;
  @HiveField(3)
  int outputHeight;
  @HiveField(4)
  String title;
  @HiveField(5)
  double titleFontSize;
  @HiveField(6)
  int titleColorValue;
  @HiveField(7)
  String titleFontFamily;
  @HiveField(8)
  BackgroundTypeHive bgType;
  @HiveField(9)
  bool showBorders;
  @HiveField(10)
  double gap;
  @HiveField(11)
  int deviceFrameIndex;
  @HiveField(12)
  List<Uint8List> images;

  Project({
    this.gridColumns = 3,
    this.gridRows = 3,
    this.outputWidth = 1200,
    this.outputHeight = 800,
    this.title = 'My App Showcase',
    this.titleFontSize = 32.0,
    this.titleColorValue = 0xFF000000,
    this.titleFontFamily = 'Roboto',
    BackgroundTypeHive? bgType,
    this.showBorders = true,
    this.gap = 16.0,
    this.deviceFrameIndex = 0,
    List<Uint8List>? images,
  }) : bgType = bgType ?? BackgroundTypeHive.color(const Color(0xFFFFFFFF)),
       images = images ?? const [];

  Color get titleColor => Color(titleColorValue);
  DeviceFrameType get deviceFrame => DeviceFrameType.values[deviceFrameIndex];
}

@HiveType(typeId: 1)
class BackgroundTypeHive extends HiveObject {
  @HiveField(0)
  String type; // 'color' or 'gradient'
  @HiveField(1)
  int? colorValue;
  @HiveField(2)
  List<int>? gradientColors;
  @HiveField(3)
  List<double>? gradientStops;
  @HiveField(4)
  String? begin;
  @HiveField(5)
  String? end;

  BackgroundTypeHive()
    : type = 'color',
      colorValue = 0xFFFFFFFF,
      gradientColors = null,
      gradientStops = null,
      begin = null,
      end = null;

  BackgroundTypeHive.color(Color color)
    : type = 'color',
      colorValue = color.value,
      gradientColors = null,
      gradientStops = null,
      begin = null,
      end = null;

  BackgroundTypeHive.gradient(LinearGradient gradient)
    : type = 'gradient',
      colorValue = null,
      gradientColors = gradient.colors.map((c) => c.value).toList(),
      gradientStops = gradient.stops,
      begin = gradient.begin.toString(),
      end = gradient.end.toString();

  BackgroundType toBackgroundType() {
    if (type == 'color' && colorValue != null) {
      return BackgroundColor(Color(colorValue!));
    } else if (type == 'gradient' && gradientColors != null) {
      return BackgroundGradient(
        LinearGradient(
          colors: gradientColors!.map((v) => Color(v)).toList(),
          stops: gradientStops,
          begin: _alignmentFromString(begin),
          end: _alignmentFromString(end),
        ),
      );
    }
    return const BackgroundColor(Colors.white);
  }

  static Alignment _alignmentFromString(String? s) {
    switch (s) {
      case 'Alignment.topLeft':
        return Alignment.topLeft;
      case 'Alignment.topRight':
        return Alignment.topRight;
      case 'Alignment.bottomLeft':
        return Alignment.bottomLeft;
      case 'Alignment.bottomRight':
        return Alignment.bottomRight;
      case 'Alignment.centerLeft':
        return Alignment.centerLeft;
      case 'Alignment.centerRight':
        return Alignment.centerRight;
      case 'Alignment.topCenter':
        return Alignment.topCenter;
      case 'Alignment.bottomCenter':
        return Alignment.bottomCenter;
      case 'Alignment.center':
      default:
        return Alignment.center;
    }
  }

  static BackgroundTypeHive fromBackgroundType(BackgroundType bg) {
    if (bg is BackgroundColor) {
      return BackgroundTypeHive.color(bg.color);
    } else if (bg is BackgroundGradient && bg.gradient is LinearGradient) {
      return BackgroundTypeHive.gradient(bg.gradient as LinearGradient);
    }
    return BackgroundTypeHive.color(Colors.white);
  }
}

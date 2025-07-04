import 'package:flutter/material.dart';
import '../../shared/models/background_type.dart';
import 'package:hive/hive.dart';
import '../models/project.dart';

class Persistence {
  static const String boxName = 'project_box';
  static const String key = 'project';

  // --- Serialization helpers ---
  static Map<String, dynamic> colorToJson(Color color) => {
    'value': color.value,
  };
  static Color colorFromJson(Map<String, dynamic> json) => Color(json['value']);

  static Map<String, dynamic> linearGradientToJson(LinearGradient gradient) => {
    'colors': gradient.colors.map((c) => colorToJson(c)).toList(),
    'stops': gradient.stops,
    'begin': gradient.begin.toString(),
    'end': gradient.end.toString(),
  };
  static LinearGradient linearGradientFromJson(Map<String, dynamic> json) {
    return LinearGradient(
      colors: (json['colors'] as List)
          .map((c) => colorFromJson(c as Map<String, dynamic>))
          .toList(),
      stops: (json['stops'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      begin: _alignmentFromString(json['begin'] as String?),
      end: _alignmentFromString(json['end'] as String?),
    );
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

  static Map<String, dynamic> backgroundTypeToJson(BackgroundType bg) {
    if (bg is BackgroundColor) {
      return {'type': 'color', 'color': colorToJson(bg.color)};
    } else if (bg is BackgroundGradient && bg.gradient is LinearGradient) {
      return {
        'type': 'gradient',
        'gradient': linearGradientToJson(bg.gradient as LinearGradient),
      };
    }
    return {'type': 'unknown'};
  }

  static BackgroundType backgroundTypeFromJson(Map<String, dynamic> json) {
    if (json['type'] == 'color') {
      return BackgroundColor(colorFromJson(json['color']));
    } else if (json['type'] == 'gradient') {
      return BackgroundGradient(linearGradientFromJson(json['gradient']));
    }
    return const BackgroundColor(Colors.white);
  }

  static Future<void> saveProject(Project project) async {
    final box = Hive.box<Project>(boxName);
    await box.put(key, project);
  }

  static Future<Project?> loadProject() async {
    final box = Hive.box<Project>(boxName);
    return box.get(key);
  }

  static Future<void> clearProject() async {
    final box = Hive.box<Project>(boxName);
    await box.delete(key);
  }
}

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/project.dart';
import '../../domain/entities/banner_config.dart';
import '../../data/providers/device_frame.dart';
import '../../../../shared/models/background_type.dart';

class BannerLocalDataSource {
  static const String boxName = 'project_box';

  Future<BannerConfig?> loadBannerConfig() async {
    final box = await Hive.openBox<Project>(boxName);
    final project = box.get('banner_config');
    if (project == null) return null;
    return _projectToBannerConfig(project);
  }

  Future<void> saveBannerConfig(BannerConfig config) async {
    final box = await Hive.openBox<Project>(boxName);
    final project = _bannerConfigToProject(config);
    await box.put('banner_config', project);
  }

  // Conversion: Project (Hive) -> BannerConfig (domain)
  BannerConfig _projectToBannerConfig(Project p) {
    return BannerConfig(
      gridColumns: p.gridColumns,
      gridRows: p.gridRows,
      outputWidth: p.outputWidth,
      outputHeight: p.outputHeight,
      title: p.title,
      titleFontSize: p.titleFontSize,
      titleColorValue: p.titleColorValue,
      titleFontFamily: p.titleFontFamily,
      bgType: p.bgType.toBackgroundType(),
      showBorders: p.showBorders,
      gap: p.gap,
      deviceFrame: DeviceFrameType.values[p.deviceFrameIndex],
      images: p.images,
    );
  }

  // Conversion: BannerConfig (domain) -> Project (Hive)
  Project _bannerConfigToProject(BannerConfig c) {
    return Project(
      gridColumns: c.gridColumns,
      gridRows: c.gridRows,
      outputWidth: c.outputWidth,
      outputHeight: c.outputHeight,
      title: c.title,
      titleFontSize: c.titleFontSize,
      titleColorValue: c.titleColorValue,
      titleFontFamily: c.titleFontFamily,
      bgType: BackgroundTypeHive.fromBackgroundType(c.bgType),
      showBorders: c.showBorders,
      gap: c.gap,
      deviceFrameIndex: c.deviceFrame.index,
      images: c.images,
    );
  }
}

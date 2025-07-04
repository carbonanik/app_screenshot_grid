import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/banner_config.dart';
import '../../domain/usecases/load_project.dart';
import '../../domain/usecases/save_project.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_local_datasource.dart';
import '../repositories/banner_repository_impl.dart';
import '../../../../shared/models/background_type.dart';
import '../../data/providers/device_frame.dart';

class BannerConfigNotifier extends StateNotifier<BannerConfig?> {
  final LoadBannerConfig loadBannerConfigUseCase;
  final SaveBannerConfig saveBannerConfigUseCase;

  BannerConfigNotifier({
    required this.loadBannerConfigUseCase,
    required this.saveBannerConfigUseCase,
  }) : super(null);

  Future<void> load() async {
    final loaded = await loadBannerConfigUseCase();
    if (loaded != null) {
      state = loaded;
    } else {
      // Set a default config if nothing is loaded
      state = BannerConfig(
        gridColumns: 3,
        gridRows: 3,
        outputWidth: 1200,
        outputHeight: 800,
        title: 'My App Showcase',
        titleFontSize: 32.0,
        titleColorValue: 0xFF000000,
        titleFontFamily: 'Roboto',
        bgType: const BackgroundColor(Colors.white),
        showBorders: true,
        gap: 16.0,
        deviceFrame: DeviceFrameType.iphone,
        images: [],
      );
    }
  }

  Future<void> save() async {
    final config = state;
    if (config != null) {
      await saveBannerConfigUseCase(config);
    }
  }

  void update(BannerConfig config) {
    state = config;
  }

  // Example: update a single field (add more as needed)
  void updateTitle(String title) {
    if (state != null) {
      state = BannerConfig(
        gridColumns: state!.gridColumns,
        gridRows: state!.gridRows,
        outputWidth: state!.outputWidth,
        outputHeight: state!.outputHeight,
        title: title,
        titleFontSize: state!.titleFontSize,
        titleColorValue: state!.titleColorValue,
        titleFontFamily: state!.titleFontFamily,
        bgType: state!.bgType,
        showBorders: state!.showBorders,
        gap: state!.gap,
        deviceFrame: state!.deviceFrame,
        images: state!.images,
      );
    }
  }
}

// Data source provider
final bannerLocalDataSourceProvider = Provider<BannerLocalDataSource>((ref) {
  return BannerLocalDataSource();
});

// Repository provider
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final localDataSource = ref.watch(bannerLocalDataSourceProvider);
  return BannerRepositoryImpl(localDataSource);
});

// Use case providers
final loadBannerConfigUseCaseProvider = Provider<LoadBannerConfig>((ref) {
  final repo = ref.watch(bannerRepositoryProvider);
  return LoadBannerConfig(repo);
});

final saveBannerConfigUseCaseProvider = Provider<SaveBannerConfig>((ref) {
  final repo = ref.watch(bannerRepositoryProvider);
  return SaveBannerConfig(repo);
});

// Main banner config provider
final bannerConfigProvider =
    StateNotifierProvider<BannerConfigNotifier, BannerConfig?>((ref) {
      final loadUseCase = ref.watch(loadBannerConfigUseCaseProvider);
      final saveUseCase = ref.watch(saveBannerConfigUseCaseProvider);
      return BannerConfigNotifier(
        loadBannerConfigUseCase: loadUseCase,
        saveBannerConfigUseCase: saveUseCase,
      );
    });

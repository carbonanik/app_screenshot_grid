import 'dart:typed_data';
import '../../../../shared/models/background_type.dart';
import '../../../../shared/widgets/device_frame_widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/providers/banner_config_provider.dart';
import '../../data/providers/device_frame.dart';
import '../../domain/entities/banner_config.dart';
import '../../domain/services/banner_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';

class BannerWidget extends ConsumerWidget {
  final ScreenshotController screenshotController;
  final bool swapMode;
  final int? firstSelectedIndex;
  final void Function(int index)? onImageTap;
  final bool deleteMode;

  const BannerWidget({
    required this.screenshotController,
    this.swapMode = false,
    this.firstSelectedIndex,
    this.onImageTap,
    this.deleteMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(bannerConfigProvider);
    if (config == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final bannerState = _BannerState.fromConfig(config);

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleRatio = BannerService.calculateScaleRatio(
          screenWidth: constraints.maxWidth,
          screenHeight: constraints.maxHeight,
          outputWidth: bannerState.outputWidth,
          outputHeight: bannerState.outputHeight,
        );

        final bannerSize = BannerService.calculateBannerDimensions(
          outputWidth: bannerState.outputWidth,
          outputHeight: bannerState.outputHeight,
          scaleRatio: scaleRatio,
        );

        final showBorders = config.showBorders;
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: showBorders ? AppTheme.debugBorderDecoration : null,
          child: Center(
            child: Screenshot(
              controller: screenshotController,
              child: _BannerContainer(
                config: config,
                size: bannerSize,
                swapMode: swapMode,
                firstSelectedIndex: firstSelectedIndex,
                onImageTap: onImageTap,
                deleteMode: deleteMode,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BannerContainer extends StatelessWidget {
  final BannerConfig config;
  final Size size;
  final bool swapMode;
  final int? firstSelectedIndex;
  final void Function(int index)? onImageTap;
  final bool deleteMode;

  const _BannerContainer({
    required this.config,
    required this.size,
    this.swapMode = false,
    this.firstSelectedIndex,
    this.onImageTap,
    this.deleteMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BannerService.createBannerDecoration(config.bgType);
    final showBorders = config.showBorders;
    return Container(
      width: size.width,
      height: size.height,
      decoration: decoration.copyWith(
        border: showBorders ? AppTheme.outputBorderDecoration.border : null,
      ),
      padding: EdgeInsets.all(config.gap / 2),
      child: Column(
        children: [
          _BannerTitle(
            title: config.title,
            fontSize: config.titleFontSize,
            color: Color(config.titleColorValue),
            fontFamily: config.titleFontFamily,
            height: config.titleHeight,
          ),
          Expanded(
            child: _BannerGrid(
              images: config.images,
              columns: config.gridColumns,
              rows: config.gridRows,
              gap: config.gap,
              swapMode: swapMode,
              firstSelectedIndex: firstSelectedIndex,
              onImageTap: onImageTap,
              deleteMode: deleteMode,
              deviceFrame: config.deviceFrame,
              showBorders: config.showBorders,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final String fontFamily;
  final double height;

  const _BannerTitle({
    required this.title,
    required this.fontSize,
    required this.color,
    required this.fontFamily,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.getFont(
            fontFamily,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _BannerGrid extends StatelessWidget {
  final List<Uint8List> images;
  final int columns;
  final int rows;
  final double gap;
  final bool swapMode;
  final int? firstSelectedIndex;
  final void Function(int index)? onImageTap;
  final bool deleteMode;
  final DeviceFrameType deviceFrame;
  final bool showBorders;

  const _BannerGrid({
    required this.images,
    required this.columns,
    required this.rows,
    required this.gap,
    this.swapMode = false,
    this.firstSelectedIndex,
    this.onImageTap,
    this.deleteMode = false,
    required this.deviceFrame,
    required this.showBorders,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        rows,
        (rowIndex) => Expanded(
          child: Row(
            children: List.generate(columns, (columnIndex) {
              final image = BannerService.getImageAtPosition(
                images,
                rowIndex,
                columnIndex,
                columns,
              );
              final flatIndex = rowIndex * columns + columnIndex;

              return Expanded(
                child: _ImageCell(
                  image: image,
                  showBorder: showBorders,
                  gap: gap,
                  swapMode: swapMode,
                  selected: swapMode && firstSelectedIndex == flatIndex,
                  onTap: (swapMode && image != null)
                      ? () => onImageTap?.call(flatIndex)
                      : (deleteMode && image != null)
                      ? () => onImageTap?.call(flatIndex)
                      : null,
                  deviceFrame: deviceFrame,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ImageCell extends StatelessWidget {
  final Uint8List? image;
  final bool showBorder;
  final double gap;
  final bool swapMode;
  final bool selected;
  final VoidCallback? onTap;
  final DeviceFrameType deviceFrame;

  const _ImageCell({
    required this.image,
    required this.showBorder,
    required this.gap,
    this.swapMode = false,
    this.selected = false,
    this.onTap,
    required this.deviceFrame,
  });

  @override
  Widget build(BuildContext context) {
    Widget framedImage = const SizedBox.shrink();
    if (image != null) {
      switch (deviceFrame) {
        case DeviceFrameType.iphone:
          framedImage = IPhoneFrame(
            child: Image.memory(image!, fit: BoxFit.cover),
          );
          break;
        case DeviceFrameType.android:
          framedImage = AndroidFrame(
            child: Image.memory(image!, fit: BoxFit.cover),
          );
          break;
      }
    }

    Widget cell = Container(
      margin: EdgeInsets.all(gap / 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: selected
              ? Colors.blue
              : (showBorder ? Colors.black : Colors.transparent),
          width: selected ? 3 : 1,
        ),
        boxShadow: selected
            ? [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 8)]
            : null,
      ),
      child: Center(child: framedImage),
    );
    if ((swapMode || onTap != null) && image != null) {
      cell = GestureDetector(onTap: onTap, child: cell);
    }
    return cell;
  }
}

class _BannerState {
  final int columns;
  final int rows;
  final int outputWidth;
  final int outputHeight;
  final BackgroundType backgroundType;
  final double gap;
  final double titleHeight;

  _BannerState({
    required this.columns,
    required this.rows,
    required this.outputWidth,
    required this.outputHeight,
    required this.backgroundType,
    required this.gap,
    required this.titleHeight,
  });

  factory _BannerState.fromConfig(BannerConfig config) {
    return _BannerState(
      columns: config.gridColumns,
      rows: config.gridRows,
      outputWidth: config.outputWidth,
      outputHeight: config.outputHeight,
      backgroundType: config.bgType,
      gap: config.gap,
      titleHeight: config.titleHeight,
    );
  }
}

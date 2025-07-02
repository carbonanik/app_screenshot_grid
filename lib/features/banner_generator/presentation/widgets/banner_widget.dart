import 'dart:typed_data';
import '../../../../shared/models/background_type.dart';
import '../../../../shared/widgets/device_frame_widgets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/providers/device_frame.dart';
import '../../data/providers/providers.dart';
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
    final bannerState = _BannerState.fromRef(ref);

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

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: AppTheme.debugBorderDecoration,
          child: Center(
            child: Screenshot(
              controller: screenshotController,
              child: _BannerContainer(
                size: bannerSize,
                backgroundType: bannerState.backgroundType,
                gap: bannerState.gap,
                titleHeight: bannerState.titleHeight,
                columns: bannerState.columns,
                rows: bannerState.rows,
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

class _BannerContainer extends ConsumerWidget {
  final Size size;
  final BackgroundType backgroundType;
  final double gap;
  final double titleHeight;
  final int columns;
  final int rows;
  final bool swapMode;
  final int? firstSelectedIndex;
  final void Function(int index)? onImageTap;
  final bool deleteMode;

  const _BannerContainer({
    required this.size,
    required this.backgroundType,
    required this.gap,
    required this.titleHeight,
    required this.columns,
    required this.rows,
    this.swapMode = false,
    this.firstSelectedIndex,
    this.onImageTap,
    this.deleteMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decoration = BannerService.createBannerDecoration(backgroundType);

    return Container(
      width: size.width,
      height: size.height,
      decoration: decoration.copyWith(
        border: AppTheme.outputBorderDecoration.border,
      ),
      padding: EdgeInsets.all(gap / 2),
      child: Column(
        children: [
          _BannerTitle(height: titleHeight),
          Expanded(
            child: _BannerGrid(
              columns: columns,
              rows: rows,
              gap: gap,
              swapMode: swapMode,
              firstSelectedIndex: firstSelectedIndex,
              onImageTap: onImageTap,
              deleteMode: deleteMode,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerTitle extends ConsumerWidget {
  final double height;

  const _BannerTitle({required this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(titleProvider);
    final fontSize = ref.watch(titleFontSizeProvider);
    final color = ref.watch(titleColorProvider);
    final fontFamily = ref.watch(titleFontFamilyProvider);

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

class _BannerGrid extends ConsumerWidget {
  final int columns;
  final int rows;
  final double gap;
  final bool swapMode;
  final int? firstSelectedIndex;
  final void Function(int index)? onImageTap;
  final bool deleteMode;

  const _BannerGrid({
    required this.columns,
    required this.rows,
    required this.gap,
    this.swapMode = false,
    this.firstSelectedIndex,
    this.onImageTap,
    this.deleteMode = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(imagesProvider);
    final showBorders = ref.watch(showBordersProvider);

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
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ImageCell extends ConsumerWidget {
  final Uint8List? image;
  final bool showBorder;
  final double gap;
  final bool swapMode;
  final bool selected;
  final VoidCallback? onTap;

  const _ImageCell({
    required this.image,
    required this.showBorder,
    required this.gap,
    this.swapMode = false,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frameType = ref.watch(deviceFrameProvider);

    Widget framedImage = const SizedBox.shrink();
    if (image != null) {
      switch (frameType) {
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

  factory _BannerState.fromRef(WidgetRef ref) {
    return _BannerState(
      columns: ref.watch(gridColumnsProvider),
      rows: ref.watch(gridRowsProvider),
      outputWidth: ref.watch(outputWidthProvider),
      outputHeight: ref.watch(outputHeightProvider),
      backgroundType: ref.watch(bgTypeProvider),
      gap: ref.watch(gapProvider),
      titleHeight: ref.watch(titleHeightProvider),
    );
  }
}

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

  const BannerWidget({required this.screenshotController, super.key});

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

  const _BannerContainer({
    required this.size,
    required this.backgroundType,
    required this.gap,
    required this.titleHeight,
    required this.columns,
    required this.rows,
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
            child: _BannerGrid(columns: columns, rows: rows, gap: gap),
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

  const _BannerGrid({
    required this.columns,
    required this.rows,
    required this.gap,
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

              return Expanded(
                child: _ImageCell(
                  image: image,
                  showBorder: showBorders,
                  gap: gap,
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

  const _ImageCell({
    required this.image,
    required this.showBorder,
    required this.gap,
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

    return Container(
      margin: EdgeInsets.all(gap / 2),
      decoration: showBorder
          ? BoxDecoration(border: Border.all(color: Colors.black))
          : null,
      child: Center(child: framedImage),
    );
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

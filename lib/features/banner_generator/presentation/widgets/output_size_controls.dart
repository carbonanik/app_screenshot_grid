import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/banner_config_provider.dart';
import '../../../../core/constants/app_constants.dart';

class OutputSizeControls extends ConsumerWidget {
  final Color accent;

  const OutputSizeControls({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(bannerConfigProvider);
    final notifier = ref.read(bannerConfigProvider.notifier);
    final outputWidth = config?.outputWidth ?? AppConstants.defaultOutputWidth;
    final outputHeight =
        config?.outputHeight ?? AppConstants.defaultOutputHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Output Size",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: accent,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Width field with mouse wheel support
            SizedBox(
              width: AppConstants.inputFieldWidth,
              child: Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent && config != null) {
                    final delta = event.scrollDelta.dy;
                    int newWidth = outputWidth;
                    if (delta < 0) {
                      newWidth += AppConstants.sizeIncrement;
                    } else if (delta > 0 && newWidth > AppConstants.minSize) {
                      newWidth -= AppConstants.sizeIncrement;
                    }
                    notifier.update(config.copyWith(outputWidth: newWidth));
                    notifier.save();
                  }
                },
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Width",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.mediumBorderRadius,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: outputWidth.toString(),
                  ),
                  onSubmitted: (v) {
                    if (config != null) {
                      notifier.update(
                        config.copyWith(
                          outputWidth:
                              int.tryParse(v) ??
                              AppConstants.defaultOutputWidth,
                        ),
                      );
                      notifier.save();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Height field with mouse wheel support
            SizedBox(
              width: AppConstants.inputFieldWidth,
              child: Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent && config != null) {
                    final delta = event.scrollDelta.dy;
                    int newHeight = outputHeight;
                    if (delta < 0) {
                      newHeight += AppConstants.sizeIncrement;
                    } else if (delta > 0 && newHeight > AppConstants.minSize) {
                      newHeight -= AppConstants.sizeIncrement;
                    }
                    notifier.update(config.copyWith(outputHeight: newHeight));
                    notifier.save();
                  }
                },
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Height",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.mediumBorderRadius,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: outputHeight.toString(),
                  ),
                  onSubmitted: (v) {
                    if (config != null) {
                      notifier.update(
                        config.copyWith(
                          outputHeight:
                              int.tryParse(v) ??
                              AppConstants.defaultOutputHeight,
                        ),
                      );
                      notifier.save();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../../../../core/constants/app_constants.dart';

class OutputSizeControls extends ConsumerWidget {
  final Color accent;

  const OutputSizeControls({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputWidth = ref.watch(outputWidthProvider);
    final outputHeight = ref.watch(outputHeightProvider);

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
                  if (event is PointerScrollEvent) {
                    final delta = event.scrollDelta.dy;
                    final notifier = ref.read(outputWidthProvider.notifier);
                    if (delta < 0) {
                      notifier.state += AppConstants.sizeIncrement;
                    } else if (delta > 0 &&
                        notifier.state > AppConstants.minSize) {
                      notifier.state -= AppConstants.sizeIncrement;
                    }
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
                  onSubmitted: (v) =>
                      ref.read(outputWidthProvider.notifier).state =
                          int.tryParse(v) ?? AppConstants.defaultOutputWidth,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Height field with mouse wheel support
            SizedBox(
              width: AppConstants.inputFieldWidth,
              child: Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    final delta = event.scrollDelta.dy;
                    final notifier = ref.read(outputHeightProvider.notifier);
                    if (delta < 0) {
                      notifier.state += AppConstants.sizeIncrement;
                    } else if (delta > 0 &&
                        notifier.state > AppConstants.minSize) {
                      notifier.state -= AppConstants.sizeIncrement;
                    }
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
                  onSubmitted: (v) =>
                      ref.read(outputHeightProvider.notifier).state =
                          int.tryParse(v) ?? AppConstants.defaultOutputHeight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

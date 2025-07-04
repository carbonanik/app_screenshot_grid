import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/banner_config_provider.dart';
import '../../data/providers/color_picker_dialog.dart';
import '../../../../shared/models/background_type.dart';
import '../../../../core/constants/app_constants.dart';

class StyleControls extends ConsumerWidget {
  final Color accent;

  const StyleControls({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(bannerConfigProvider);
    final notifier = ref.read(bannerConfigProvider.notifier);
    final bgType = config?.bgType ?? const BackgroundColor(Colors.white);
    final showBorders = config?.showBorders ?? true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                final result = await showDialog<BackgroundType>(
                  context: context,
                  builder: (context) => const ColorPickerDialog(
                    title: "Background Color",
                    allowGradients: true,
                  ),
                );
                if (result != null && config != null) {
                  notifier.update(config.copyWith(bgType: result));
                  notifier.save();
                }
              },
              child: Container(
                width: AppConstants.colorPickerSize,
                height: AppConstants.colorPickerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.smallBorderRadius,
                  ),
                  border: Border.all(color: Colors.grey.shade300),
                  color: bgType is BackgroundColor
                      ? (bgType as BackgroundColor).color
                      : null,
                  gradient: bgType is BackgroundGradient
                      ? (bgType as BackgroundGradient).gradient
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Checkbox(
              value: showBorders,
              onChanged: (v) {
                if (config != null && v != null) {
                  notifier.update(config.copyWith(showBorders: v));
                  notifier.save();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: accent,
            ),
            const Text(
              "Show Borders",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}

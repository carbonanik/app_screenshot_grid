import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../../data/providers/color_picker_dialog.dart';
import '../../../../shared/models/background_type.dart';
import '../../../../core/constants/app_constants.dart';

class StyleControls extends ConsumerWidget {
  final Color accent;

  const StyleControls({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                if (result != null) {
                  ref.read(bgTypeProvider.notifier).state = result;
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
                  color: ref.watch(bgTypeProvider) is BackgroundColor
                      ? (ref.watch(bgTypeProvider) as BackgroundColor).color
                      : null,
                  gradient: ref.watch(bgTypeProvider) is BackgroundGradient
                      ? (ref.watch(bgTypeProvider) as BackgroundGradient)
                            .gradient
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Checkbox(
              value: ref.watch(showBordersProvider),
              onChanged: (v) =>
                  ref.read(showBordersProvider.notifier).state = v!,
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

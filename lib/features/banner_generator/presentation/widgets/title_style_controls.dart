import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/banner_config_provider.dart';
import '../../data/providers/color_picker_dialog.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/background_type.dart';

class TitleStyleControls extends ConsumerWidget {
  final Color accent;

  const TitleStyleControls({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(bannerConfigProvider);
    final notifier = ref.read(bannerConfigProvider.notifier);
    final fontSize = config?.titleFontSize ?? 28.0;
    final color = config != null ? Color(config.titleColorValue) : Colors.black;
    final fontFamily = config?.titleFontFamily ?? 'Roboto';

    // List of Google Fonts to pick from
    final fonts = [
      'Roboto',
      'Montserrat',
      'Lato',
      'Oswald',
      'Poppins',
      'Open Sans',
      'Raleway',
      'Merriweather',
      'Bebas Neue',
      'Pacifico',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Title Style",
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
            const Text("Size:"),
            SizedBox(
              width: 120,
              child: Slider(
                value: fontSize,
                min: 12,
                max: 64,
                divisions: 52,
                label: fontSize.round().toString(),
                onChanged: (v) {
                  if (config != null) {
                    notifier.update(config.copyWith(titleFontSize: v));
                    notifier.save();
                  }
                },
                activeColor: accent,
              ),
            ),
            Text(fontSize.round().toString()),
            const SizedBox(width: 16),
            const Text("Color:"),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDialog<BackgroundType>(
                  context: context,
                  builder: (context) => const ColorPickerDialog(
                    title: "Title Color",
                    allowGradients: false,
                  ),
                );
                if (picked != null &&
                    picked is BackgroundColor &&
                    config != null) {
                  notifier.update(
                    config.copyWith(titleColorValue: picked.color.value),
                  );
                  notifier.save();
                }
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(
                    AppConstants.smallBorderRadius,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text("Font:"),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: fontFamily,
              items: fonts
                  .map(
                    (f) => DropdownMenuItem(
                      value: f,
                      child: Text(f, style: GoogleFonts.getFont(f)),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (config != null && v != null) {
                  notifier.update(config.copyWith(titleFontFamily: v));
                  notifier.save();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

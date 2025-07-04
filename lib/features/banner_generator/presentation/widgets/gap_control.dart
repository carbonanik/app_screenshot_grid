import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/banner_config_provider.dart';

class GapControl extends ConsumerWidget {
  final Color accent;

  const GapControl({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(bannerConfigProvider);
    final notifier = ref.read(bannerConfigProvider.notifier);
    final gap = config?.gap ?? 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gap",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: accent,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
        Slider(
          value: gap,
          min: 0,
          max: 64,
          divisions: 32,
          label: gap.round().toString(),
          onChanged: (v) {
            if (config != null) {
              notifier.update(config.copyWith(gap: v));
              notifier.save();
            }
          },
          activeColor: accent,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';

class GapControl extends ConsumerWidget {
  final Color accent;

  const GapControl({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gap = ref.watch(gapProvider);
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
          onChanged: (v) => ref.read(gapProvider.notifier).state = v,
          activeColor: accent,
        ),
      ],
    );
  }
}

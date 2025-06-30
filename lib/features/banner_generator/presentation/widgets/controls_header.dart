import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class ControlsHeader extends StatelessWidget {
  final Color accent;
  final VoidCallback? onTap;

  const ControlsHeader({required this.accent, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.tune, color: accent, size: 22),
        const SizedBox(width: AppConstants.smallSpacing),
        Text(
          "Banner Controls",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: accent,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.expand_circle_down_rounded),
          onPressed: onTap,
        ),
      ],
    );
  }
}

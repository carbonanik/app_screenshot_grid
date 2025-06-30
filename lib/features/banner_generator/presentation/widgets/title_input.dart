import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../../../../core/constants/app_constants.dart';

class TitleInput extends ConsumerWidget {
  final Color accent;

  const TitleInput({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController(text: ref.watch(titleProvider));
    return TextField(
      controller: titleCtrl,
      decoration: InputDecoration(
        labelText: "Banner Title",
        prefixIcon: Icon(Icons.title, color: accent.withValues(alpha: 0.7)),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
      style: const TextStyle(fontWeight: FontWeight.w500),
      onSubmitted: (v) => ref.read(titleProvider.notifier).state = v,
    );
  }
}

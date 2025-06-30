import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../../../../core/constants/app_constants.dart';

class GridControls extends ConsumerWidget {
  final Color accent;

  const GridControls({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Columns:",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: AppConstants.smallSpacing),
            DropdownButton<int>(
              value: ref.watch(gridColumnsProvider),
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(
                AppConstants.mediumBorderRadius,
              ),
              items: AppConstants.availableGridSizes.map((size) {
                return DropdownMenuItem<int>(value: size, child: Text('$size'));
              }).toList(),
              onChanged: (val) =>
                  ref.read(gridColumnsProvider.notifier).state = val!,
            ),
            const SizedBox(width: AppConstants.largeSpacing),
            const Text("Rows:", style: TextStyle(fontWeight: FontWeight.w400)),
            const SizedBox(width: AppConstants.smallSpacing),
            DropdownButton<int>(
              value: ref.watch(gridRowsProvider),
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(
                AppConstants.mediumBorderRadius,
              ),
              items: AppConstants.availableGridSizes.map((size) {
                return DropdownMenuItem<int>(value: size, child: Text('$size'));
              }).toList(),
              onChanged: (val) =>
                  ref.read(gridRowsProvider.notifier).state = val!,
            ),
          ],
        ),
      ],
    );
  }
}

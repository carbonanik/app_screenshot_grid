import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/banner_config_provider.dart';
import '../../../../core/constants/app_constants.dart';

class GridControls extends ConsumerWidget {
  final Color accent;

  const GridControls({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(bannerConfigProvider);
    final notifier = ref.read(bannerConfigProvider.notifier);
    final columns = config?.gridColumns ?? AppConstants.defaultGridColumns;
    final rows = config?.gridRows ?? AppConstants.defaultGridRows;
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
              value: columns,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(
                AppConstants.mediumBorderRadius,
              ),
              items: AppConstants.availableGridSizes.map((size) {
                return DropdownMenuItem<int>(value: size, child: Text('$size'));
              }).toList(),
              onChanged: (val) {
                if (config != null && val != null) {
                  notifier.update(config.copyWith(gridColumns: val));
                  notifier.save();
                }
              },
            ),
            const SizedBox(width: AppConstants.largeSpacing),
            const Text("Rows:", style: TextStyle(fontWeight: FontWeight.w400)),
            const SizedBox(width: AppConstants.smallSpacing),
            DropdownButton<int>(
              value: rows,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(
                AppConstants.mediumBorderRadius,
              ),
              items: AppConstants.availableGridSizes.map((size) {
                return DropdownMenuItem<int>(value: size, child: Text('$size'));
              }).toList(),
              onChanged: (val) {
                if (config != null && val != null) {
                  notifier.update(config.copyWith(gridRows: val));
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

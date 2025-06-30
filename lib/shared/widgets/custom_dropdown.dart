import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? label;
  final double? width;
  final Widget Function(T)? itemBuilder;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.width,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Widget dropdown = DropdownButton<T>(
      value: value,
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: itemBuilder?.call(item) ?? Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );

    if (label != null) {
      dropdown = Row(
        children: [
          Text(label!, style: AppConstants.labelStyle),
          SizedBox(width: AppConstants.smallSpacing),
          dropdown,
        ],
      );
    }

    if (width != null) {
      return SizedBox(width: width, child: dropdown);
    }

    return dropdown;
  }
}

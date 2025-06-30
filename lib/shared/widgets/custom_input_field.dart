import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../../core/theme/app_theme.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final double? width;
  final bool enableMouseWheel;
  final VoidCallback? onMouseWheelUp;
  final VoidCallback? onMouseWheelDown;
  final String? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInputField({
    super.key,
    required this.label,
    this.initialValue,
    this.keyboardType,
    this.onSubmitted,
    this.onChanged,
    this.width,
    this.enableMouseWheel = false,
    this.onMouseWheelUp,
    this.onMouseWheelDown,
    this.prefixIcon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);

    Widget inputField = TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null
            ? Icon(
                Icons.adaptive.share,
                color: AppTheme.accentColor.withValues(alpha: 0.7),
              )
            : null,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
    );

    if (enableMouseWheel) {
      inputField = Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            final delta = event.scrollDelta.dy;
            if (delta < 0 && onMouseWheelUp != null) {
              onMouseWheelUp!();
            } else if (delta > 0 && onMouseWheelDown != null) {
              onMouseWheelDown!();
            }
          }
        },
        child: inputField,
      );
    }

    if (width != null) {
      return SizedBox(width: width, child: inputField);
    }

    return inputField;
  }
}

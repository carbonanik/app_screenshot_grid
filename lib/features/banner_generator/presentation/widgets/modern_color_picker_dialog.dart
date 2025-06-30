import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../../../../core/constants/app_constants.dart';

class ModernColorPickerDialog extends ConsumerStatefulWidget {
  final Color initialColor;
  final String title;

  const ModernColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.title,
  });

  @override
  ConsumerState<ModernColorPickerDialog> createState() =>
      _ModernColorPickerDialogState();
}

class _ModernColorPickerDialogState
    extends ConsumerState<ModernColorPickerDialog> {
  late Color _currentColor;
  late TextEditingController _hexController;
  bool _isValidHex = true;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    _hexController = TextEditingController(
      text:
          '#${_currentColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _onColorChanged(Color color) {
    setState(() {
      _currentColor = color;
      _hexController.text =
          '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
      _isValidHex = true;
    });
  }

  void _onHexChanged(String value) {
    setState(() {
      _isValidHex = _isValidHexColor(value);
      if (_isValidHex) {
        _currentColor = _parseHexColor(value);
      }
    });
  }

  bool _isValidHexColor(String hex) {
    if (hex.isEmpty) return false;
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    if (hex.length != 6 && hex.length != 8) return false;
    return RegExp(r'^[0-9A-Fa-f]+$').hasMatch(hex);
  }

  Color _parseHexColor(String hex) {
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add alpha channel
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.palette, color: _currentColor),
          const SizedBox(width: 8),
          Text(widget.title),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Color wheel
          ColorPicker(
            pickerColor: _currentColor,
            onColorChanged: _onColorChanged,
            pickerAreaHeightPercent: 0.6,
            enableAlpha: true,
            displayThumbColor: true,
            showLabel: true,
            paletteType: PaletteType.hsvWithHue,
            pickerAreaBorderRadius: const BorderRadius.all(
              Radius.circular(AppConstants.largeBorderRadius),
            ),
          ),
          const SizedBox(height: 16),

          // Hex color input
          _buildHexInput(),
          const SizedBox(height: 16),

          // Quick color presets
          _buildColorPresets(),
          const SizedBox(height: 16),

          // Current color display
          _buildCurrentColorDisplay(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_currentColor),
          child: const Text('Select'),
        ),
      ],
    );
  }

  Widget _buildHexInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hex Color Code',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _hexController,
          onChanged: _onHexChanged,
          decoration: InputDecoration(
            hintText: '#FF0000',
            prefixIcon: const Icon(Icons.tag),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.mediumBorderRadius,
              ),
            ),
            errorText: _isValidHex ? null : 'Invalid hex color',
            suffixIcon: Container(
              margin: const EdgeInsets.all(4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
          ),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildColorPresets() {
    final presetColors = [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Colors',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presetColors.map((color) {
            final isSelected = color.value == _currentColor.value;
            return GestureDetector(
              onTap: () => _onColorChanged(color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCurrentColorDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Color',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  '#${_currentColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

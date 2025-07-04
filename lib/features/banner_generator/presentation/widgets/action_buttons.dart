import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class ActionButtons extends StatelessWidget {
  final Color accent;
  final VoidCallback onPickImages;
  final VoidCallback? onDownload;
  final VoidCallback? onClear;

  const ActionButtons({
    required this.accent,
    required this.onPickImages,
    required this.onDownload,
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionButton(
          onPressed: onPickImages,
          icon: Icons.upload_file,
          label: "Upload Images",
          backgroundColor: accent,
        ),
        const SizedBox(height: 12),
        _ActionButton(
          onPressed: onDownload,
          icon: Icons.file_download,
          label: "Export Banner",
          backgroundColor: Colors.grey.shade800,
        ),
        const SizedBox(height: 12),
        _ActionButton(
          onPressed: onClear,
          icon: Icons.clear_all,
          label: "Clear All",
          backgroundColor: Colors.red.shade600,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

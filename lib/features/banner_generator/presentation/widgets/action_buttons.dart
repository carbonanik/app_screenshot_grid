import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class ActionButtons extends StatelessWidget {
  final Color accent;
  final VoidCallback onPickImages;
  final VoidCallback? onDownload;

  const ActionButtons({
    required this.accent,
    required this.onPickImages,
    required this.onDownload,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: onPickImages,
          icon: const Icon(Icons.upload_file, color: Colors.white, size: 18),
          label: const Text("Upload"),
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.largeBorderRadius,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
        ElevatedButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download, color: Colors.white, size: 18),
          label: const Text("Download"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.largeBorderRadius,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
      ],
    );
  }
}

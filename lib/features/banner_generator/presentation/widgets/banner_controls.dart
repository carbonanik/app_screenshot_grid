import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import 'controls_header.dart';
import 'section_card.dart';
import 'title_input.dart';
import 'title_style_controls.dart';
import 'grid_controls.dart';
import 'output_size_controls.dart';
import 'gap_control.dart';
import 'style_controls.dart';
import 'device_frame_picker.dart';
import 'action_buttons.dart';

class BannerControls extends ConsumerWidget {
  final VoidCallback onPickImages;
  final VoidCallback? onDownload;
  final VoidCallback? onHeaderTap;
  final VoidCallback? onClear;
  final bool swapMode;
  final bool deleteMode;
  final ValueChanged<bool?> onSwapModeChanged;
  final ValueChanged<bool?> onDeleteModeChanged;

  const BannerControls({
    super.key,
    required this.onPickImages,
    this.onHeaderTap,
    this.onDownload,
    this.onClear,
    required this.swapMode,
    required this.deleteMode,
    required this.onSwapModeChanged,
    required this.onDeleteModeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = Colors.blue.shade400;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ControlsHeader(accent: accent, onTap: onHeaderTap),
          const SizedBox(height: AppConstants.largeSpacing),
          SectionCard(
            title: "Title",
            accent: accent,
            children: [
              TitleInput(accent: accent),
              const SizedBox(height: AppConstants.mediumSpacing),
              TitleStyleControls(accent: accent),
            ],
          ),
          const SizedBox(height: AppConstants.largeSpacing),
          SectionCard(
            title: "Grid",
            accent: accent,
            children: [
              GridControls(accent: accent),
              const SizedBox(height: AppConstants.mediumSpacing),
              OutputSizeControls(accent: accent),
              const SizedBox(height: AppConstants.mediumSpacing),
              GapControl(accent: accent),
              Row(
                children: [
                  Checkbox(value: swapMode, onChanged: onSwapModeChanged),
                  const Text('Change Position'),
                ],
              ),
              // const SizedBox(width: 16),
              Row(
                children: [
                  Checkbox(value: deleteMode, onChanged: onDeleteModeChanged),
                  const Text('Delete Item'),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largeSpacing),
          SectionCard(
            title: "Style",
            accent: accent,
            children: [
              StyleControls(accent: accent),
              const SizedBox(height: 10),
              DeviceFramePicker(accent: accent),
              const SizedBox(height: AppConstants.largeSpacing),
              ActionButtons(
                accent: accent,
                onPickImages: onPickImages,
                onDownload: onDownload,
                onClear: onClear,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.extraLargeSpacing),
        ],
      ),
    );
  }
}

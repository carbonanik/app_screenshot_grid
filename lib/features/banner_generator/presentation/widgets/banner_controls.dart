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

class BannerControls extends ConsumerStatefulWidget {
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
  ConsumerState<BannerControls> createState() => _BannerControlsState();
}

class _BannerControlsState extends ConsumerState<BannerControls> {
  String? _expandedSection;

  void _toggleSection(String sectionTitle) {
    setState(() {
      if (_expandedSection == sectionTitle) {
        _expandedSection = null; // Collapse if already expanded
      } else {
        _expandedSection = sectionTitle; // Expand this section, collapse others
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.grey.shade900;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.smallSpacing),
          ControlsHeader(accent: accent, onTap: widget.onHeaderTap),
          const SizedBox(height: AppConstants.smallSpacing),
          SectionCard(
            title: "Title",
            accent: accent,
            icon: Icons.title,
            initiallyExpanded: _expandedSection == "Title",
            onToggle: () => _toggleSection("Title"),
            children: [
              TitleInput(accent: accent),
              const SizedBox(height: AppConstants.mediumSpacing),
              TitleStyleControls(accent: accent),
            ],
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          SectionCard(
            title: "Grid",
            accent: accent,
            icon: Icons.grid_on,
            initiallyExpanded: _expandedSection == "Grid",
            onToggle: () => _toggleSection("Grid"),
            children: [
              GridControls(accent: accent),
              const SizedBox(height: AppConstants.mediumSpacing),
              OutputSizeControls(accent: accent),
              const SizedBox(height: AppConstants.mediumSpacing),
              GapControl(accent: accent),
              const SizedBox(height: AppConstants.mediumSpacing),

              Column(
                children: [
                  Row(
                    children: [
                      Switch(
                        value: widget.swapMode,
                        onChanged: widget.onSwapModeChanged,
                        activeColor: accent,
                      ),
                      const Text(
                        'Change Position',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Switch(
                        value: widget.deleteMode,
                        onChanged: widget.onDeleteModeChanged,
                        activeColor: Colors.red,
                      ),
                      const Text(
                        'Delete Item',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          SectionCard(
            title: "Style",
            accent: accent,
            icon: Icons.palette,
            initiallyExpanded: _expandedSection == "Style",
            onToggle: () => _toggleSection("Style"),
            children: [
              StyleControls(accent: accent),
              const SizedBox(height: 10),
              DeviceFramePicker(accent: accent),
            ],
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          SectionCard(
            title: "Actions",
            accent: accent,
            icon: Icons.play_arrow,
            initiallyExpanded: _expandedSection == "Actions",
            onToggle: () => _toggleSection("Actions"),
            children: [
              ActionButtons(
                accent: accent,
                onPickImages: widget.onPickImages,
                onDownload: widget.onDownload,
                onClear: widget.onClear,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
        ],
      ),
    );
  }
}

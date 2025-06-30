import '../widgets/banner_controls.dart';
import '../widgets/banner_widget.dart';
import '../../data/providers/providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:html' as html;
import 'dart:ui';

class BannerGeneratorPage extends ConsumerStatefulWidget {
  const BannerGeneratorPage({super.key});

  @override
  ConsumerState<BannerGeneratorPage> createState() =>
      _BannerGeneratorPageState();
}

class _BannerGeneratorPageState extends ConsumerState<BannerGeneratorPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _showSidePanel = true;

  Future<void> _pickImages() async {
    try {
      final pickedImages = await ImagePickerWeb.getMultiImagesAsBytes();
      if (pickedImages != null) {
        final limitedImages = pickedImages.take(25).toList(); // Max 5x5 grid
        ref.read(imagesProvider.notifier).state = limitedImages;

        if (pickedImages.length > 25 && mounted) {
          ErrorHandler.showSuccessSnackBar(
            context,
            'Only first 25 images will be used (max 5x5 grid)',
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          'Failed to pick images: ${ErrorHandler.getErrorMessage(error)}',
        );
      }
    }
  }

  Future<void> _downloadBanner() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) {
        if (mounted) {
          ErrorHandler.showErrorSnackBar(context, 'Failed to capture banner');
        }
        return;
      }

      final blob = html.Blob([image]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "banner.png")
        ..click();
      html.Url.revokeObjectUrl(url);

      if (mounted) {
        ErrorHandler.showSuccessSnackBar(
          context,
          'Banner downloaded successfully!',
        );
      }
    } catch (error) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          'Failed to download banner: ${ErrorHandler.getErrorMessage(error)}',
        );
      }
    }
  }

  void _toggleSidePanel() {
    setState(() {
      _showSidePanel = !_showSidePanel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final canDownload = ref.watch(canDownloadProvider);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: BannerWidget(screenshotController: _screenshotController),
          ),
          if (_showSidePanel) _buildSidePanel(canDownload),
          if (!_showSidePanel) _buildFloatingControls(),
        ],
      ),
    );
  }

  Widget _buildSidePanel(bool canDownload) {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: AppConstants.sidePanelWidth,
        margin: const EdgeInsets.all(AppConstants.extraLargeSpacing),
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        decoration: AppTheme.sidePanelDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppConstants.extraLargeBorderRadius,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SingleChildScrollView(
              child: BannerControls(
                onPickImages: _pickImages,
                onDownload: canDownload ? _downloadBanner : null,
                onHeaderTap: _toggleSidePanel,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingControls() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Row(
        children: [
          IconButton(
            onPressed: _toggleSidePanel,
            icon: const Icon(Icons.arrow_circle_up),
          ),
          const Text("Controls"),
        ],
      ),
    );
  }
}

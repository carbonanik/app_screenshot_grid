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
  bool _swapMode = false;
  int? _firstSelectedIndex;
  bool _deleteMode = false;

  Future<void> _pickImages() async {
    try {
      final pickedImages = await ImagePickerWeb.getMultiImagesAsBytes();
      if (pickedImages != null) {
        final currentImages = ref.read(imagesProvider.notifier).state;
        final combinedImages = (currentImages + pickedImages)
            .take(25)
            .toList(); // Max 5x5 grid
        ref.read(imagesProvider.notifier).state = combinedImages;

        if ((currentImages.length + pickedImages.length) > 25 && mounted) {
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

  void _clearImages() {
    ref.read(imagesProvider.notifier).state = [];
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

  void _onSwapModeChanged(bool? value) {
    setState(() {
      _swapMode = value ?? false;
      if (_swapMode) _deleteMode = false;
      _firstSelectedIndex = null;
    });
  }

  void _onDeleteModeChanged(bool? value) {
    setState(() {
      _deleteMode = value ?? false;
      if (_deleteMode) {
        _swapMode = false;
        _firstSelectedIndex = null;
      }
    });
  }

  void _onImageTap(int index) async {
    if (_swapMode) {
      setState(() {
        if (_firstSelectedIndex == null) {
          _firstSelectedIndex = index;
        } else if (_firstSelectedIndex != index) {
          // Swap images
          final images = List.of(ref.read(imagesProvider.notifier).state);
          final temp = images[_firstSelectedIndex!];
          images[_firstSelectedIndex!] = images[index];
          images[index] = temp;
          ref.read(imagesProvider.notifier).state = images;
          _firstSelectedIndex = null;
        }
      });
    } else if (_deleteMode) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        final images = List.of(ref.read(imagesProvider.notifier).state);
        images.removeAt(index);
        ref.read(imagesProvider.notifier).state = images;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canDownload = ref.watch(canDownloadProvider);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: BannerWidget(
              screenshotController: _screenshotController,
              swapMode: _swapMode,
              firstSelectedIndex: _firstSelectedIndex,
              onImageTap: _onImageTap,
              deleteMode: _deleteMode,
            ),
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
                onClear: _clearImages,
                swapMode: _swapMode,
                deleteMode: _deleteMode,
                onSwapModeChanged: _onSwapModeChanged,
                onDeleteModeChanged: _onDeleteModeChanged,
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

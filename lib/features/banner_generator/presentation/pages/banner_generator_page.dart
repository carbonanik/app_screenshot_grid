import '../widgets/banner_controls.dart';
import '../widgets/banner_widget.dart';
import '../../data/providers/banner_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:html' as html;
import 'dart:ui';
import 'dart:math';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();
    // Load the banner config on init
    Future.microtask(() => ref.read(bannerConfigProvider.notifier).load());
  }

  Future<void> _pickImages() async {
    final notifier = ref.read(bannerConfigProvider.notifier);
    final config = ref.read(bannerConfigProvider);
    if (config == null) return;
    try {
      final pickedImages = await ImagePickerWeb.getMultiImagesAsBytes();
      if (pickedImages != null) {
        final currentImages = config.images;
        final combinedImages = (currentImages + pickedImages).take(25).toList();
        notifier.update(config.copyWith(images: combinedImages));
        notifier.save();
        if ((currentImages.length + pickedImages.length) > 25 && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Only first 25 images will be used (max 5x5 grid)'),
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick images: $error')),
        );
      }
    }
  }

  void _clearImages() {
    final notifier = ref.read(bannerConfigProvider.notifier);
    final config = ref.read(bannerConfigProvider);
    if (config == null) return;
    notifier.update(config.copyWith(images: []));
    notifier.save();
  }

  Future<void> _downloadBanner() async {
    final config = ref.read(bannerConfigProvider);
    if (config == null) return;
    try {
      final outputWidth = config.outputWidth;
      final outputHeight = config.outputHeight;
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final scaleRatio = outputWidth / screenWidth > outputHeight / screenHeight
          ? outputWidth / screenWidth
          : outputHeight / screenHeight;
      final bannerSize = Size(
        outputWidth / scaleRatio,
        outputHeight / scaleRatio,
      );
      final pixelRatio = max(
        outputWidth / bannerSize.width,
        outputHeight / bannerSize.height,
      );
      final image = await _screenshotController.capture(pixelRatio: pixelRatio);
      if (image == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to capture banner')),
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner downloaded successfully!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download banner: $error')),
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
    final notifier = ref.read(bannerConfigProvider.notifier);
    final config = ref.read(bannerConfigProvider);
    if (config == null) return;
    if (_swapMode) {
      setState(() {
        if (_firstSelectedIndex == null) {
          _firstSelectedIndex = index;
        } else if (_firstSelectedIndex != index) {
          final images = List.of(config.images);
          final temp = images[_firstSelectedIndex!];
          images[_firstSelectedIndex!] = images[index];
          images[index] = temp;
          notifier.update(config.copyWith(images: images));
          notifier.save();
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
        final images = List.of(config.images);
        images.removeAt(index);
        notifier.update(config.copyWith(images: images));
        notifier.save();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(bannerConfigProvider);
    final canDownload =
        config != null &&
        config.images.isNotEmpty &&
        config.images.length <= 25;
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
        width: 340.0,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
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

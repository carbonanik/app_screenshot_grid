import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/banner_config_provider.dart';
import '../../data/providers/device_frame.dart';

class DeviceFramePicker extends ConsumerWidget {
  final Color accent;

  const DeviceFramePicker({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(bannerConfigProvider);
    final notifier = ref.read(bannerConfigProvider.notifier);
    final frameType = config?.deviceFrame ?? DeviceFrameType.iphone;
    return Row(
      children: [
        const Text(
          "Device Frame:",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        DropdownButton<DeviceFrameType>(
          value: frameType,
          items: const [
            DropdownMenuItem(
              value: DeviceFrameType.iphone,
              child: Text("iPhone"),
            ),
            DropdownMenuItem(
              value: DeviceFrameType.android,
              child: Text("Android"),
            ),
          ],
          onChanged: (type) {
            if (config != null && type != null) {
              notifier.update(config.copyWith(deviceFrame: type));
              notifier.save();
            }
          },
        ),
      ],
    );
  }
}

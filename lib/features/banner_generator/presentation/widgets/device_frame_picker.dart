import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../../data/providers/device_frame.dart';

class DeviceFramePicker extends ConsumerWidget {
  final Color accent;

  const DeviceFramePicker({required this.accent, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frameType = ref.watch(deviceFrameProvider);
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
          onChanged: (type) =>
              ref.read(deviceFrameProvider.notifier).state = type!,
        ),
      ],
    );
  }
}

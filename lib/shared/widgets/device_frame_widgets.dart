import 'package:flutter/material.dart';

class IPhoneFrame extends StatelessWidget {
  final Widget child;
  const IPhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 19.5, // iPhone 14 Pro and Pixel 7 Pro
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final borderWidth = width * 0.040; // 4.6% of width
          final borderRadius = width * 0.18; // 12% of width
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(borderWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class AndroidFrame extends StatelessWidget {
  final Widget child;
  const AndroidFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 19.5, // Pixel 7 Pro
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final borderWidth = width * 0.020; // 4.1% of width
          final borderRadius = width * 0.070; // 13.6% of width
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(borderWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

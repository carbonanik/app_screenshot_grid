import 'package:flutter/material.dart';

abstract class BackgroundType {
  const BackgroundType();
}

class BackgroundColor extends BackgroundType {
  final Color color;
  const BackgroundColor(this.color);
}

class BackgroundGradient extends BackgroundType {
  final Gradient gradient;
  const BackgroundGradient(this.gradient);
}

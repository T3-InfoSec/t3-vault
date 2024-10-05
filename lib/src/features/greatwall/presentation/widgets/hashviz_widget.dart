import 'package:flutter/material.dart';

import 'hashviz_painter.dart';

class HashvizWidget extends StatelessWidget {
  final List<int> imageData;
  final int size;
  final int numColors;
  final double saturation;
  final double brightness;
  final int minHue;
  final int maxHue;

  const HashvizWidget({
    super.key,
    required this.imageData,
    required this.size,
    required this.numColors,
    this.saturation = 0.7,
    this.brightness = 0.8,
    this.minHue = 90,
    this.maxHue = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: HashvizPainter(
          imageData: imageData,
          size: size,
          numColors: numColors,
          saturation: saturation,
          brightness: brightness,
          minHue: minHue,
          maxHue: maxHue,
        ),
      ),
    );
  }
}

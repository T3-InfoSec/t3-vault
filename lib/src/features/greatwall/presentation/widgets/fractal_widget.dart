import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/fractal_painter.dart';

class FractalWidget extends StatelessWidget {
  final Uint8List imageData;
  final String funcType;
  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;
  final double realP;
  final double imagP;
  final int width;
  final int height;
  final double escapeRadius;
  final int maxIters;

  const FractalWidget({
    super.key,
    required this.imageData,
    required this.funcType,
    this.xMin = -2.5,
    this.xMax = 2.0,
    this.yMin = -2.0,
    this.yMax = 0.8,
    this.realP = 2.0,
    this.imagP = 0.0,
    this.width = 1024,
    this.height = 1024,
    this.escapeRadius = 4.0,
    this.maxIters = 30,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: CustomPaint(
        painter: FractalPainter(
          imagePixels: imageData,
          width: width,
          height: height,
        ),
      ),
    );
  }
}

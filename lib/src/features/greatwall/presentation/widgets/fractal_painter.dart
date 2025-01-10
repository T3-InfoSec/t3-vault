import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A [CustomPainter] to render fractal images on the canvas.
class FractalPainter extends CustomPainter {
  final ui.Image fractalImage;

  FractalPainter({required this.fractalImage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImageRect(
      fractalImage,
      Rect.fromLTWH(
          0, 0, fractalImage.width.toDouble(), fractalImage.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant FractalPainter oldDelegate) {
    return oldDelegate.fractalImage != fractalImage;
  }
}

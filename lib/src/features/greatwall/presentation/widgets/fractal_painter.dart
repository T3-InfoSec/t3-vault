import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A [CustomPainter] to render fractal images on the canvas.
class FractalPainter extends CustomPainter {
  final ui.Image fractalImage;

  /// Constructs a [FractalPainter] with the given fractal image.
  FractalPainter({required this.fractalImage});

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / fractalImage.width;
    final scaleY = size.height / fractalImage.height;

    // Scale and draw the fractal image on the canvas
    canvas.save();
    canvas.scale(scaleX, scaleY);
    canvas.drawImage(fractalImage, Offset.zero, Paint());
    canvas.restore();
  }

  /// Always returns `true` to indicate that the painter should repaint whenever
  /// the widget needs to update.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

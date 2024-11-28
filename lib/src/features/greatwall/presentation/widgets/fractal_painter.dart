import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A [CustomPainter] that renders fractal images based on raw pixel data.
class FractalPainter extends CustomPainter {
  final Uint8List imagePixels;
  final int width;
  final int height;

  /// Creates a [FractalPainter] with the given raw pixel data and dimensions.
  ///
  /// The [imagePixels] represents the raw pixel data (RGBA format) of the
  /// fractal image, while [width] and [height] specify the image dimensions.
  FractalPainter({
    required this.imagePixels,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / width;
    final scaleY = size.height / height;

    // Create an image from raw pixel data.
    ui.decodeImageFromPixels(
      imagePixels, // Raw pixel data (RGBA format).
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image image) {
        // Draw the scaled image on the canvas.
        canvas.save();
        canvas.scale(scaleX, scaleY);
        canvas.drawImage(image, Offset.zero, Paint());
        canvas.restore();
      },
    );
  }

  /// Always returns `true` to indicate that the painter should repaint whenever
  /// the widget needs to update.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

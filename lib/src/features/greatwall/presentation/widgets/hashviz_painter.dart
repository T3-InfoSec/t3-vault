import 'package:flutter/material.dart';

/// A [CustomPainter] that draws a hash-based pattern on a canvas.
///
/// This painter takes a list of integers, [imageData], to represent the pattern,
/// where each value defines the color of the corresponding block in the grid.
/// The grid has a size defined by [size], and each block is painted with either
/// the foreground color [color], the background color [bgColor], or the spot
/// color [spotColor], depending on the value in [imageData].
///
/// The default foreground color is Shamrock Green, the background color is
/// Pastel Green, and the spot color is Spring Green.
class HashvizPainter extends CustomPainter {
  final List<int> imageData;
  final int size;
  final Color color;
  final Color bgColor;
  final Color spotColor;

  /// Creates a [HashvizPainter].
  ///
  /// The [imageData] parameter is a list of integers representing the image
  /// pattern to be drawn, and [size] defines the number of rows and columns
  /// in the grid. Optionally, you can specify a custom [color] for the foreground,
  /// a [bgColor] for the background, and a [spotColor] for specific pattern
  /// spots. If not provided, these colors default to Shamrock Green for
  /// the foreground, Pastel Green for the background, and Spring Green
  /// for the spots.
  HashvizPainter({
    required this.imageData,
    required this.size,
    this.color = const Color(0xFF009E60), // Shamrock Green
    this.bgColor = const Color(0xFF77DD77), // Pastel Green
    this.spotColor = const Color(0xFF00FF7F), // Spring Green
  });

  /// Paints the hash-based pattern on the given [canvas] using the available
  /// [canvasSize].
  ///
  /// The canvas is first filled with [bgColor], and then each block is drawn
  /// based on the values in [imageData]. A value of 0 leaves the background
  /// color intact, 1 paints the block with [color], and 2 uses [spotColor].
  @override
  void paint(Canvas canvas, Size canvasSize) {
    final bgPaint = Paint()..color = bgColor;
    final colorPaint = Paint()..color = color;
    final spotPaint = Paint()..color = spotColor;

    final blockSize = Size(canvasSize.width / size, canvasSize.height / size);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height), bgPaint);

    // Draw the blocks for the pattern based on `imageData`
    for (int i = 0; i < imageData.length; i++) {
      // if data is 0, leave the background
      if (imageData[i] != 0) {
        final row = (i / size).floor();
        final col = (i % size);

        final paint = imageData[i] == 1 ? colorPaint : spotPaint;

        // if data is 2, choose spot color, if 1 choose foreground
        canvas.drawRect(
          Rect.fromLTWH(
            col * blockSize.width,
            row * blockSize.height,
            blockSize.width + 1,
            blockSize.height + 1,
          ),
          paint,
        );
      }
    }
  }

  /// Always returns `true` to indicate that the painter should repaint whenever
  /// the widget needs to update.
  ///
  /// This ensures that the pattern is redrawn each time the widget rebuilds.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

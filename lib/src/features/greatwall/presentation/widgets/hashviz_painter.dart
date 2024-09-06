import 'package:flutter/material.dart';

// TODO: Add documentation
class HashvizPainter extends CustomPainter {
  final List<int> imageData;
  final int size;
  final Color color;
  final Color bgColor;
  final Color spotColor;

  /// Constructor for the [HashvizPainter] class.
  ///
  /// - Parameters:
  ///   - [imageData]: List of integers representing the image pattern to be drawn.
  ///   - [size]: The size of the pattern grid.
  ///   - [color]: The color used for the foreground (default is black).
  ///   - [bgColor]: The color used for the background (default is yellow).
  HashvizPainter({
    required this.imageData,
    required this.size,
    this.color = Colors.black,
    this.bgColor = Colors.yellowAccent,
    this.spotColor = Colors.lightBlue,
  });

  /// Paints the hash-based pattern onto the canvas.
  ///
  /// - Parameters:
  ///   - [canvas]: The canvas to draw on.
  ///   - [canvasSize]: The size of the canvas.
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

  /// Determines whether the painter needs to repaint.
  ///
  /// - Returns: `true` to always repaint.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

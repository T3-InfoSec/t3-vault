import 'package:flutter/material.dart';

/// A [CustomPainter] that draws a hash-based pattern on a canvas.
///
/// This class takes an image pattern and renders it using specified colors.
/// The pattern is represented by a list of integers, where different values
/// are used to determine the color of each block in the pattern.
///
/// - [imageData] A list of integers representing the image pattern to be drawn.
/// - [size] The size of the pattern grid, defining the number of rows and columns.
/// - [color] The foreground color for the pattern blocks (default is Shamrock Green).
/// - [bgColor] The background color of the canvas (default is Pastel Green).
/// - [spotColor] The color used for specific pattern spots (default is Spring Green).
///
/// The [paint] method draws the pattern onto the canvas based on [imageData],
/// using the specified colors.
/// The [shouldRepaint] method always returns `true`
/// to ensure that the painter is always redrawn when the widget needs to be updated.
class HashvizPainter extends CustomPainter {
  final List<int> imageData;
  final int size;
  final int numColors;

  final List<Color> fixedColors = const [
    Color(0xFF009E60), // Shamrock Green (bgColor)
    Color(0xFF01796F), // Pine Green [1]
    Color(0xFF808000), // Olive Green [2]
    Color(0xFF2E8B57), // Sea Green [3]
    Color(0xFF00FF00), // Lime Green [4]
    Color(0xFFD0F0C0), // Tea Green [5]
    Color(0xFF228B22), // Forest Green [6]
    Color(0xFF00A36C), // Jade Green [7]
    Color(0xFF7FFF00), // Chartreuse Green [8]
  ];

  /// Constructor for the [HashvizPainter] class.
  ///
  /// - Parameters:
  ///   - [imageData]: List of integers representing the image pattern to be drawn.
  ///   - [size]: The size of the pattern grid.
  ///   - [numColors]: The number of colours to use in the pattern 
  HashvizPainter({
    required this.imageData,
    required this.size,
    required this.numColors,
  });

  /// Paints the hash-based pattern onto the canvas.
  ///
  /// - Parameters:
  ///   - [canvas]: The canvas to draw on.
  ///   - [canvasSize]: The size of the canvas.
  @override
  void paint(Canvas canvas, Size canvasSize) {
    final bgPaint = Paint()..color = fixedColors[0];

    final blockSize = Size(canvasSize.width / size, canvasSize.height / size);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height), bgPaint);

    final colorsToUse = fixedColors.sublist(0, numColors);

    // Draw the blocks for the pattern based on `imageData`
    for (int i = 0; i < imageData.length; i++) {
      // if data is 0, leave the background
      if (imageData[i] != 0) {
        final row = (i / size).floor();
        final col = (i % size);

        final paint = Paint()..color = colorsToUse[imageData[i] % colorsToUse.length];

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

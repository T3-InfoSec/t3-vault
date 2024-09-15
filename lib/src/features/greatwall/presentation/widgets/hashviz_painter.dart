import 'package:flutter/material.dart';

/// A [CustomPainter] that draws a hash-based pattern using a set of fixed colors.
///
/// This painter takes a list of integers representing an image pattern and
/// renders it as a grid of colored blocks. The colors used for the pattern
/// are selected from a predefined set of fixed colors. The number of colors
/// used in the pattern is determined by [numColors].
///
/// The first color in the list is used as the background color for the canvas.
/// The remaining colors are assigned to the pattern blocks based on the
/// values in [imageData].
class HashvizPainter extends CustomPainter {
  final List<int> imageData;
  final int size;
  final int numColors;

  /// A predefined set of fixed colors used for the pattern.
  ///
  /// The first color, Shamrock Green, is used as the background color, while
  /// the rest are used to paint the pattern blocks based on [imageData].
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

  /// Creates an instance of [HashvizPainter].
  ///
  /// The [imageData] parameter contains a list of integers representing the
  /// pattern to be drawn, while [size] defines the dimensions of the pattern grid
  /// (i.e., the number of rows and columns). The [numColors] parameter specifies
  /// how many colors from [fixedColors] will be used for rendering the pattern.
  HashvizPainter({
    required this.imageData,
    required this.size,
    required this.numColors,
  });

  /// Paints the hash-based pattern onto the canvas.
  ///
  /// The canvas is first filled with the background color (Shamrock Green),
  /// after which the pattern blocks are drawn based on [imageData]. The blocks
  /// are painted with colors selected from [fixedColors], where the number of
  /// colors used is controlled by [numColors].
  ///
  /// Each block's color is determined by the corresponding value in [imageData],
  /// and the color is chosen using a modulo operation to cycle through the
  /// available colors if necessary.
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

        final paint = Paint()
          ..color = colorsToUse[imageData[i] % colorsToUse.length];

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

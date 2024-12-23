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
  final double saturation;
  final double brightness;
  final int minHue;
  final int maxHue;

  /// Creates an instance of [HashvizPainter].
  ///
  /// The [imageData] parameter contains a list of integers representing the
  /// pattern to be drawn, while [size] defines the dimensions of the pattern grid
  /// (i.e., the number of rows and columns). The [numColors] parameter specifies
  /// how many colors will be generated for rendering the pattern.
  /// The [saturation], [brightness], [minHue], and [maxHue] parameters control
  /// the color generation with better control over luminosity, 
  /// and are optional with default values of 0.7, 0.8, 90, and 150 respectively.
  HashvizPainter({
    required this.imageData,
    required this.size,
    required this.numColors,
    this.saturation = 0.7,
    this.brightness = 0.8,
    this.minHue = 90,
    this.maxHue = 150,
  });

  /// Paints the hash-based pattern onto the canvas.
  ///
  /// The canvas is first filled with the background color,
  /// after which the pattern blocks are drawn based on [imageData].
  /// The blocks are painted with dynamically generated colors.
  ///
  /// Each block's color is determined by the corresponding value in [imageData],
  /// and the color is chosen using a modulo operation to cycle through the
  /// available colors if necessary.
  @override
  void paint(Canvas canvas, Size canvasSize) {
    final dynamicColors = generateDynamicColors();
    final bgPaint = Paint()..color = dynamicColors[0];

    final blockSize = Size(canvasSize.width / size, canvasSize.height / size);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height), bgPaint);

    // Draw the blocks for the pattern based on `imageData`
    for (int i = 0; i < imageData.length; i++) {
      // if data is 0, leave the background
      if (imageData[i] != 0) {
        final row = (i / size).floor();
        final col = (i % size);

        final paint = Paint()
          ..color = dynamicColors[imageData[i] % dynamicColors.length];

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
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// Generates a list of colors dynamically based on [numColors] using HSVColor.
  ///
  /// The hue (H) component will vary, and we will control the saturation (S)
  /// and brightness (V) components to keep the colors within a certain range.
  List<Color> generateDynamicColors() {
    const int fixedAlpha = 255;

    double step = (maxHue - minHue) / (numColors - 1);

    List<Color> colors = [];
    for (int i = 0; i < numColors; i++) {
      double hueValue = minHue + (i * step);
      var color = HSVColor.fromAHSV(
        fixedAlpha / 255.0, // Alpha needs to be in the range 0.0 - 1.0
        hueValue,
        saturation,
        brightness,
      ).toColor(); // Convert HSV to Color (RGB)
      colors.add(color);
    }

    return colors;
  }
}

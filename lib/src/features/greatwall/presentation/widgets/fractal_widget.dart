import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/fractal_painter.dart';

class FractalWidget extends StatelessWidget {
  final Uint8List imageData;
  final int width;
  final int height;

  const FractalWidget({
    super.key,
    required this.imageData,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder<ui.Image>(
          future: _generateFractal(imageData),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return CustomPaint(
                size: constraints.biggest,
                painter: FractalPainter(fractalImage: snapshot.data!),
              );
            } else {
              return const Center(child: Text('Failed to load fractal image.'));
            }
          },
        );
      },
    );
  }
  
  Future<ui.Image> _generateFractal(Uint8List imageData) {

    // Generate the gradient color palette
    final palette = generateGradientPalette(256);

    // Map fractal values to RGBA pixels
    final rgbaPixels = mapFractalToPixels(imageData, palette);

    // Decode RGBA pixels into a ui.Image
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      rgbaPixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image img) => completer.complete(img),
    );
    return completer.future;
  }

  /// Generates a gradient color palette as RGBA values.
  ///
  /// The palette transitions from blue to red, returning each color as a list of RGBA values.
  List<List<int>> generateGradientPalette(int length) {
    List<List<int>> palette = [];
    for (int i = 0; i < length; i++) {
      double ratio = i / (length - 1);
      int red = (255 * ratio).toInt();
      int blue = 255 - red;
      palette.add([red, 0, blue, 255]); // Add RGBA values directly
    }
    return palette;
  }

  /// Converts fractal values to RGBA pixel data using a pre-mapped palette.
  ///
  /// [fractalPixels] are the raw fractal values, [palette] is a pre-mapped list of RGBA values,
  /// and the result is directly suitable for rendering with Flutter.
  Uint8List mapFractalToPixels(Uint8List fractalPixels, List<List<int>> palette) {
    final rgbaPixels = Uint8List(fractalPixels.length * 4); // 4 bytes per pixel (RGBA)

    for (int i = 0; i < fractalPixels.length; i++) {
      final color = palette[fractalPixels[i]];
      rgbaPixels[i * 4] = color[0];     // Red
      rgbaPixels[i * 4 + 1] = color[1]; // Green
      rgbaPixels[i * 4 + 2] = color[2]; // Blue
      rgbaPixels[i * 4 + 3] = color[3]; // Alpha
    }
    return rgbaPixels;
  }
}

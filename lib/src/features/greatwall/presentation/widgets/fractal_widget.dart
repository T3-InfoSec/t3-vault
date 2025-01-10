import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FractalWidget extends StatelessWidget {
  final Future<Uint8List> imageData;
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
        return FutureBuilder<Uint8List>(
          future: imageData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return _FractalView(
                frame: snapshot.data!,
                width: width,
                height: height,
                size: constraints.biggest,
              );
            } else {
              return const Center(child: Text('Failed to load fractal frame.'));
            }
          },
        );
      },
    );
  }
}

class _FractalView extends StatelessWidget {
  final Uint8List frame;
  final int width;
  final int height;
  final Size size;

  const _FractalView({
    required this.frame,
    required this.width,
    required this.height,
    required this.size,
  });

  Future<ui.Image> _decodeImage(Uint8List grayPixels) {
    final rgbaPixels = Uint8List(width * height * 4);

    for (int i = 0; i < grayPixels.length; i++) {
      final grayValue = grayPixels[i];
      final offset = i * 4;

      rgbaPixels[offset] = grayValue; // Red
      rgbaPixels[offset + 1] = grayValue; // Green
      rgbaPixels[offset + 2] = grayValue; // Blue
      rgbaPixels[offset + 3] = 255; // Alpha
    }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _decodeImage(frame),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return CustomPaint(
            size: size,
            painter: FractalPainter(
              fractalImage: snapshot.data!,
            ),
          );
        } else {
          return const Center(child: Text('Failed to decode fractal frame.'));
        }
      },
    );
  }
}

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

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/fractal_painter.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/utils/generate_fractal.dart';

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
        return FutureBuilder<ui.Image>(
          future:
              imageData.then((data) => generateFractal(data, width, height)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return CustomPaint(
                size: constraints.biggest,
                painter: FractalPainter(fractalImage: snapshot.data!),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: Text('Failed to load fractal image.'));
            }
          },
        );
      },
    );
  }
}

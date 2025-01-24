import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/fractal_painter.dart';

class AnimatedFractalView extends StatefulWidget {
  final List<Uint8List> frames;
  final int width;
  final int height;
  final Size size;

  const AnimatedFractalView({
    super.key,
    required this.frames,
    required this.width,
    required this.height,
    required this.size,
  });

  @override
  State<AnimatedFractalView> createState() => _AnimatedFractalViewState();
}

class _AnimatedFractalViewState extends State<AnimatedFractalView>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late Future<List<ui.Image>> _decodedFrames;
  int _currentFrame = 0;

  @override
  void initState() {
    super.initState();
    _decodedFrames = _decodeFractalFrames(widget.frames);

    _ticker = Ticker((_) {
      setState(() {
        _currentFrame = (_currentFrame + 1) % widget.frames.length;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Future<List<ui.Image>> _decodeFractalFrames(List<Uint8List> frames) async {
    return Future.wait(frames.map((frame) async => _decodeImage(frame)));
  }

  Future<ui.Image> _decodeImage(Uint8List grayPixels) {
    final rgbaPixels = Uint8List(widget.width * widget.height * 4);

    for (int i = 0; i < widget.width * widget.height; i++) {
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
      widget.width,
      widget.height,
      ui.PixelFormat.rgba8888,
      (ui.Image img) => completer.complete(img),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ui.Image>>(
      future: _decodedFrames,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return CustomPaint(
            size: widget.size,
            painter:
                FractalPainter(fractalImage: snapshot.data![_currentFrame]),
          );
        } else {
          return const Center(child: Text('Failed to decode fractal frames.'));
        }
      },
    );
  }
}

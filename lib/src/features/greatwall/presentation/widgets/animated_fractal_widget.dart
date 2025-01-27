import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:t3_vault/src/features/greatwall/presentation/widgets/animated_fractal_view.dart';

class AnimatedFractalWidget extends StatelessWidget {
  final Future<List<Uint8List>> frameDataFuture;
  final int width;
  final int height;

  const AnimatedFractalWidget({
    super.key,
    required this.frameDataFuture,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder<List<Uint8List>>(
          future: frameDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final frameDataList = snapshot.data!;
              return AnimatedFractalView(
                frames: frameDataList,
                width: width,
                height: height,
                size: constraints.biggest,
              );
            } else {
              return const Center(
                  child: Text('Failed to load fractal frames.'));
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'hashviz_painter.dart';

class HashvizWidget extends StatelessWidget {
  final List<int> imageData;
  final int size;

  const HashvizWidget({
    super.key,
    required this.imageData,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: HashvizPainter(
          imageData: imageData,
          size: size,
        ),
      ),
    );
  }
}

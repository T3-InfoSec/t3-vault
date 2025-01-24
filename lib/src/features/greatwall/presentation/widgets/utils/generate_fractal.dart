import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

Future<ui.Image> generateFractal(Uint8List grayPixels, int width, int height) {
  final rgbaPixels = Uint8List(width * height * 4);

  for (int i = 0; i < width * height; i++) {
    final grayValue = grayPixels[i];
    final offset = i * 4;

    rgbaPixels[offset] = (grayValue * 2).clamp(0, 255);
    rgbaPixels[offset + 1] = (grayValue * 0.5).clamp(0, 255).toInt();
    rgbaPixels[offset + 2] = (grayValue * 0.2).clamp(0, 255).toInt();
    rgbaPixels[offset + 3] = 255;
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

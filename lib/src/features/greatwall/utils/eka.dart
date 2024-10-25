import 'dart:math';
import 'package:convert/convert.dart';

class Eka {
  /// Generates a new Random 32-digit hexadecimal encryption key (EKA).
  String generate() {
    final random = Random.secure();
    return hex.encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  /// Converts the EKA into 8 chunks of 4 hexadecimal digits each for better UX.
  List<String> toUxChunks(String eka) {
    if (eka.length != 32) {
      throw ArgumentError('Invalid EKA: Must be a 32-character hexadecimal string.');
    }
    return List<String>.generate(8, (i) => eka.substring(i * 4, (i + 1) * 4));
  }

  /// Restores an EKA from 8 chunks of 4 characters each.
  String fromUxChunks(List<String> chunks) {
    if (chunks.length != 8 || chunks.any((chunk) => chunk.length != 4)) {
      throw ArgumentError('Invalid chunks: Must contain 8 chunks of 4 characters each.');
    }
    return chunks.join();
  }
}

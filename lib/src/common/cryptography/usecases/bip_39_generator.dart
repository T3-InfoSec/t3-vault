import 'dart:math';
import 'dart:typed_data';

import 'package:t3_formosa/formosa.dart';

class Bip39generator {
  final Formosa _formosa;

  Bip39generator({FormosaTheme theme = FormosaTheme.bip39}) : _formosa = Formosa(formosaTheme: theme);

  /// Generates a six words bip39 seed using random entropy.
  String generataSixWordsSeed() {
    Uint8List randomEntropy = Uint8List(8);
    Random random = Random();
    for (int i = 0; i < randomEntropy.length; i++) {
      randomEntropy[i] = random.nextInt(256); // Generates a number between 0 and 255
    }
    return _formosa.toFormosa(randomEntropy);
  }

  /// Derives a BIP39 key from a given [key] by converting it to a Uint8List and
  /// applying the Formosa conversion.
  String deriveTwelveWordsSeed(String key) {
    Uint8List derivationHashResultBytes = Uint8List.fromList(
      key.codeUnits.take(16).toList(), // Take the first 16 bytes
    );
    return _formosa.toFormosa(derivationHashResultBytes);
  }
}

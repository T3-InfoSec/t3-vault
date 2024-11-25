import 'dart:math';
import 'dart:typed_data';

import 'package:t3_formosa/formosa.dart';

/// Pa0 represents the initial seed input into the derivation protocol.
/// From this seed, the protocol will derive SA0 and other critical components.
///
/// This seed is encrypted using an ephemeral key (Eka) for storage security.
class Pa0 {
  static const int byteMaxValue = 256; // Maximum value for a single byte (0-255).

  final String seed;
  List<int> seedEncrypted;

  /// Constructs a [Pa0] instance.
  ///
  /// If no [seed] is provided, a six-words BIP39 seed will be generated automatically.
  Pa0({String? seed})
      : seed = seed ?? _generateSixWordsSeed(),
        seedEncrypted = [];

  /// Generates a six-words BIP39 seed using random entropy and bip39 as Formosa theme.
  static String _generateSixWordsSeed() {
    Uint8List randomEntropy = Uint8List(8);
    Random random = Random();
    for (int i = 0; i < randomEntropy.length; i++) {
      randomEntropy[i] = random.nextInt(byteMaxValue);
    }
    FormosaTheme theme = FormosaTheme.bip39;
    Formosa formosa = Formosa(formosaTheme: theme);
    return formosa.toFormosa(randomEntropy);
  }
}

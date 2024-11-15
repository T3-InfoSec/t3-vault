import 'dart:math';
import 'dart:typed_data';

import 'package:t3_formosa/formosa.dart';

/// Pa0 represents the initial seed input into the derivation protocol.
/// From this seed, the protocol will derive SA0 and other critical components.
///
/// This seed is encrypted using an ephemeral key (Eka) for storage security.
class Pa0 {
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
      randomEntropy[i] = random.nextInt(256); // Generates a number between 0 and 255
    }
    FormosaTheme theme = FormosaTheme.bip39;
    Formosa formosa = Formosa(formosaTheme: theme);
    return formosa.toFormosa(randomEntropy);
  }
}

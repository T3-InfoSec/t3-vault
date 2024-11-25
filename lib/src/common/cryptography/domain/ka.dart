import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:t3_formosa/formosa.dart';

/// The final seed resulting from the tacit derivation process, originating from the PA0 seed.
///
/// This class is responsible for deriving a BIP39 key (`seedBip39`) using an encoded hash
/// (`encodedHash`) as input and applying the derivation theme specified by `_formosa`.
class KA {
  static const int keyLength = 16;

  final Formosa _formosa;
  final Uint8List hash;
  final String encodedHash;
  late final String seedBip39;

  /// Initializes the `KA` instance with a `hash` and the specified [theme].
  /// Automatically encodes [encodedHash] from [hash] and derives the [seedBip39]
  /// during construction.
  ///
  /// - [hash]: The input hash to be encoded.
  /// - [theme]: The derivation theme to be used by Formosa (default is BIP39).
  KA(this.hash, {FormosaTheme theme = FormosaTheme.bip39})
      : _formosa = Formosa(formosaTheme: theme, entropy: hash),
        encodedHash = hex.encode(hash) {
    seedBip39 = _formosa.seed;
  }
}

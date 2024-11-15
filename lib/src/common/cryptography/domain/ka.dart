import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:t3_formosa/formosa.dart';

/// The final key resulting from the tacit derivation process, originating from the PA0 seed.
///
/// This class is responsible for deriving a BIP39 key (`seedBip39`) using an encoded hash
/// (`encodedHash`) as input and applying the derivation theme specified by `_formosa`.
class KA {
  final Formosa _formosa;
  
  final Uint8List hash;
  final String encodedHash;
  late final String seedBip39;

  /// Initializes the `KA` instance with an `hash` and the specified [theme].
  /// Automatically encode [encodedHash] from [hash] and derives the [seedBip39]
  /// during construction.
  KA(this.hash, {FormosaTheme theme = FormosaTheme.bip39})
      : _formosa = Formosa(formosaTheme: theme), encodedHash = hex.encode(hash) {
    seedBip39 = _deriveTwelveWordsSeed(encodedHash);
  }

  /// Derives a BIP39 key from the given [key].
  ///
  /// Takes the first 16 characters of the key, converts them to bytes,
  /// and applies the Formosa conversion.
  String _deriveTwelveWordsSeed(String key) {
    Uint8List derivationHashResultBytes = Uint8List.fromList(
      key.codeUnits.take(16).toList(), // Take the first 16 bytes
    );
    return _formosa.toFormosa(derivationHashResultBytes);
  }
}

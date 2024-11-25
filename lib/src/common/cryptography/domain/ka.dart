import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:t3_formosa/formosa.dart';

/// The final key resulting from the tacit derivation process, originating from the PA0 seed.
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
      : _formosa = Formosa(formosaTheme: theme),
        encodedHash = hex.encode(hash) {
    seedBip39 = _deriveTwelveWordsSeed(encodedHash);
  }

  /// Derives a BIP39 key from the given [key].
  ///
  /// This method takes the first [keyLength] characters of the input [key],
  /// converts them to bytes, and applies the Formosa conversion to generate
  /// a BIP39-compliant 12-word seed.
  String _deriveTwelveWordsSeed(String key) {
    Uint8List derivationHashResultBytes = Uint8List.fromList(
      key.codeUnits.take(keyLength).toList(),
    );
    return _formosa.toFormosa(derivationHashResultBytes);
  }
}

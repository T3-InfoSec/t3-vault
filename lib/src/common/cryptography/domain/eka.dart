import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:t3_vault/src/common/cryptography/domain/pa0.dart';
import 'package:t3_vault/src/common/cryptography/usecases/encryption_service.dart';

/// Eka is an ephemeral encryption key used to encrypt critical data such as Pa0.
/// Eka acts as a last resort option for retrieving PA0 if the original entry seed is forgotten.
class Eka {
  String key;

  Eka() : key = _generateHexadecimalKey();

  /// Generates a secure random hexadecimal key, formatted into 4-character blocks
  /// separated by spaces for readability.
  ///
  /// Generates a 32-character hexadecimal sequence.
  /// Then formats the hexadecimal key into 4-character blocks separated by spaces,
  /// using `replaceAllMapped` with the regex pattern `.{4}`, which matches every group of 4 characters.
  /// For each 4-character match, a space is appended and calls `trim()` to remove any trailing spaces.
  static String _generateHexadecimalKey() {
    final random = Random.secure();
    final buffer = StringBuffer();

    for (int i = 0; i < 32; i++) {
      buffer.write(random.nextInt(16).toRadixString(16));
    }

    return buffer.toString().toUpperCase().replaceAllMapped(
      RegExp(r".{4}"),
      (match) => "${match.group(0)} ",
    ).trim();
  }

  /// Encrypts the [pa0] instance using this Eka and stores the result
  /// in the `seedEncrypted` attribute of [pa0].
  ///
  /// This method requires that `generateHexadecimalKey` has been called previously,
  /// otherwise it will throw an exception.
  Future<void> encryptPa0(Pa0 pa0) async {
    if (key.isEmpty) {
      throw Exception("Eka key is not generated.");
    }
    
    Uint8List encode = utf8.encode(pa0.seed);
    pa0.seedEncrypted = await EncryptionService().encrypt(encode, key);
  }
}

import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:tlp_client/tlp_client.dart';

class TLPEncryptionService {
  TLP tlpInstance = TLP(bits: 256);
  final _base2 = BigInt.from(2);
  final baseG = BigInt.from(2);

  /// Generate a TLP-based encryption key based on the time parameter `t`.
  BigInt generateCode(BigInt t) {
    final prime1 = tlpInstance.generatedPrime;
    final prime2 = tlpInstance.generatedPrime;
    final carmichael = tlpInstance.calculateCarmichael(prime1, prime2);
    final fastExponent = tlpInstance.modExp(_base2, t, carmichael);
    final product = tlpInstance.comupteProductOfPrime(prime1, prime2);

    final fastPower = tlpInstance.modExp(baseG, fastExponent, product);

    return fastPower;
  }

  /// Encrypts the given message using AES and the TLP-generated encryption key.
  String encrypt(String message, BigInt encryptionKey) {
    final key = Key.fromUtf8(encryptionKey.toString().padRight(32, '0').substring(0, 32));
    final iv = IV.fromLength(16); // Use a random IV for security

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(message, iv: iv);

    // Return the IV and the ciphertext concatenated together as base64
    return '${base64.encode(iv.bytes)}:${encrypted.base64}';
  }

  /// Decrypts the given encrypted message using AES and the TLP-generated encryption key.
  String decrypt(String encryptedData, BigInt encryptionKey) {
    final parts = encryptedData.split(':');
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);

    final key = Key.fromUtf8(encryptionKey.toString().padRight(32, '0').substring(0, 32));

    final encrypter = Encrypter(AES(key));

    return encrypter.decrypt(encrypted, iv: iv);
  }
}

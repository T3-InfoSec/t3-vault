import 'dart:convert';
import 'package:cryptography/cryptography.dart';

class EncryptionService {

  /// Encrypts a string [pa0] using AES-GCM with the derived ephemeral key [eka].
  ///
  /// This method is designed to securely encrypt the string data [pa0] by first
  /// deriving a 256-bit AES encryption key from the provided [eka] using a 
  /// key derivation function. The [AesGcm.with256bits()] algorithm is employed 
  /// for encryption, ensuring both confidentiality and authenticity of the 
  /// resulting encrypted data.
  ///
  /// The encryption process generates a `SecretBox` containing the ciphertext,
  /// a nonce (randomly generated for each encryption operation), and a MAC 
  /// (Message Authentication Code) that protects the integrity and authenticity 
  /// of the encrypted data.
  Future<List<int>> encryptPA0(String pa0, String eka) async {
    final key = await deriveKey(eka);
    final algorithm = AesGcm.with256bits();

    final secretBox = await algorithm.encrypt(
      utf8.encode(pa0),
      secretKey: key,
    );

    return secretBox.concatenation();
  }

  /// Decrypts an encrypted string [pa0Encrypted] using AES-GCM with the derived ephemeral key [eka].
  ///
  /// The [pa0Encrypted] parameter is expected to be a single byte list containing a concatenation
  /// of the nonce, ciphertext, and MAC (Message Authentication Code). This byte structure allows
  /// easy storage and transmission, ensuring all necessary components for decryption are present.
  ///
  /// This method extracts the `nonce` from the first 12 bytes of [pa0Encrypted], as AES-GCM requires a
  /// unique nonce for each encryption to maintain security. Then retrieves the `ciphertext` and `MAC` 
  /// from the remaining bytes. It creates a `SecretBox` object with the extracted nonce, ciphertext, 
  /// and MAC, which the AES-GCM algorithm requires for decryption. And finally, the method decrypts 
  /// the data and returns the original string [pa0].
  Future<String> decryptPA0(List<int> pa0Encrypted, String eka) async {
    final key = await deriveKey(eka);
    final algorithm = AesGcm.with256bits();

    final nonce = pa0Encrypted.sublist(0, 12);
    final ciphertextWithMac = pa0Encrypted.sublist(12);

    final secretBox = SecretBox(
      ciphertextWithMac.sublist(0, ciphertextWithMac.length - 16),
      nonce: nonce,
      mac: Mac(ciphertextWithMac.sublist(ciphertextWithMac.length - 16)),
    );

    final decryptedBytes = await algorithm.decrypt(
      secretBox,
      secretKey: key,
    );

    return utf8.decode(decryptedBytes);
  }

  /// Derives a 256-bit AES encryption key from the provided [key] string using the Argon2id algorithm.
  ///
  /// This method is designed to generate a secure key suitable for AES-GCM encryption by applying
  /// the Argon2id key derivation function on the input [key].
  Future<SecretKey> deriveKey(String key) async {
    final argon2 = Argon2id(
      parallelism: 4,
      iterations: 1, 
      memory: 1024, 
      hashLength: 32, // 256 bits
    );

    final secretKey = await argon2.deriveKey(
      secretKey: SecretKey(utf8.encode(key)),
      nonce: [],
    );

    return secretKey;
  }
}

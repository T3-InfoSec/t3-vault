import 'package:flutter_test/flutter_test.dart';
import 'package:t3_vault/src/features/memorization_assistant/tlp_enc_service.dart';

void main() {
  group('TLPEncryptionService Encryption and Decryption Tests', () {
    late TLPEncryptionService service;

    setUp(() {
      service = TLPEncryptionService();
    });

    test('Encrypt and Decrypt: Valid Scenario', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "Hello, TLP!";

      // Encrypt the message
      final encryptedData = service.encrypt(message, encryptionKey);

      // Decrypt the message
      final decryptedMessage = service.decrypt(encryptedData, encryptionKey);

      expect(encryptedData, isNotEmpty);
      expect(decryptedMessage, equals(message));
    });

    test('Decrypt: Invalid Scenario with Modified Encrypted Data', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "Hello, TLP!";

      // Encrypt the message
      final encryptedData = service.encrypt(message, encryptionKey);

      // Modify the encrypted data
      final modifiedEncryptedData = encryptedData.replaceFirst('!', '?');

      // Attempt to decrypt the modified data
      expect(() => service.decrypt(modifiedEncryptedData, encryptionKey), throwsFormatException);
    });

    test('Encrypt and Decrypt: Edge Case with Empty Message', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "";

      // Encrypt the empty message
      final encryptedData = service.encrypt(message, encryptionKey);

      // Decrypt the empty message
      final decryptedMessage = service.decrypt(encryptedData, encryptionKey);

      expect(encryptedData, isNotEmpty);
      expect(decryptedMessage, equals(message));
    });

    test('Encrypt and Decrypt: Edge Case with Long Message', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "A" * 10000; // Very long message

      // Encrypt the long message
      final encryptedData = service.encrypt(message, encryptionKey);

      // Decrypt the long message
      final decryptedMessage = service.decrypt(encryptedData, encryptionKey);

      expect(encryptedData, isNotEmpty);
      expect(decryptedMessage, equals(message));
    });

    test('Encrypt and Decrypt: Edge Case with Special Characters', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "!@#\$%^&*()_+[]{}|;:,.<>?";

      // Encrypt the message with special characters
      final encryptedData = service.encrypt(message, encryptionKey);

      // Decrypt the message
      final decryptedMessage = service.decrypt(encryptedData, encryptionKey);

      expect(encryptedData, isNotEmpty);
      expect(decryptedMessage, equals(message));
    });

    test('Encrypt and Decrypt: Edge Case with Whitespace', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "   Leading and trailing spaces   ";

      // Encrypt the message with whitespace
      final encryptedData = service.encrypt(message, encryptionKey);

      // Decrypt the message
      final decryptedMessage = service.decrypt(encryptedData, encryptionKey);

      expect(encryptedData, isNotEmpty);
      expect(decryptedMessage, equals(message));
    });

    test('Encrypt and Decrypt: Edge Case with Very Large Encryption Key', () {
      final timeParameter = BigInt.from(123456789);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "Key should still work.";

      // Encrypt the message with a large encryption key
      final encryptedData = service.encrypt(message, encryptionKey);

      // Decrypt the message
      final decryptedMessage = service.decrypt(encryptedData, encryptionKey);

      expect(encryptedData, isNotEmpty);
      expect(decryptedMessage, equals(message));
    });

    test('Decrypt: Invalid Key Scenario', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "Hello, TLP!";

      // Encrypt the message
      final encryptedData = service.encrypt(message, encryptionKey);

      // Generate a different encryption key
      final differentKey = service.generateCode(BigInt.from(54321));

      // Attempt to decrypt the encrypted data with a different key
      expect(() => service.decrypt(encryptedData, differentKey), throwsFormatException);
    });

    test('Encrypt and Decrypt: Edge Case with Numeric Message', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "1234567890";

      // Encrypt the numeric message
      final encryptedData = service.encrypt(message, encryptionKey);

      // Decrypt the numeric message
      final decryptedMessage = service.decrypt(encryptedData, encryptionKey);

      expect(encryptedData, isNotEmpty);
      expect(decryptedMessage, equals(message));
    });

    test('Encrypt and Decrypt: Edge Case with Unicode Characters', () {
      final timeParameter = BigInt.from(12345);
      final encryptionKey = service.generateCode(timeParameter);
      final message = "こんにちは世界"; // "Hello, World" in Japanese

      // Encrypt the message with Unicode characters
      final encryptedData = service.encrypt(message, encryptionKey);

      // Decrypt the message
      final decryptedMessage = service.decrypt(encryptedData, encryptionKey);

      expect(encryptedData, isNotEmpty);
      expect(decryptedMessage, equals(message));
    });
  });
}

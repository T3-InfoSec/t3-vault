import 'package:flutter_test/flutter_test.dart';
import 'package:t3_vault/src/features/greatwall/domain/usecases/encryption_service.dart';

void main() {
  final encryptionService = EncryptionService();

  group('EncryptionService Tests', () {
    const eka = "temporaryEphemeralKey";
    const pa0 = "This is a test string";

    test('deriveKey should derive a 256-bit key from eka', () async {
      final derivedKey = await encryptionService.deriveKey(eka);
      final keyBytes = await derivedKey.extractBytes();

      expect(keyBytes.length, 32);
    });

    test('encryptPA0 should encrypt pa0 with AES-GCM and produce concatenated data', () async {
      final encryptedData = await encryptionService.encryptPA0(pa0, eka);

      expect(encryptedData, isNotNull);
      expect(encryptedData.length, greaterThan(12 + 16));
    });

    test('decryptPA0 should decrypt encrypted data back to original pa0', () async {
      final encryptedData = await encryptionService.encryptPA0(pa0, eka);

      final decryptedData = await encryptionService.decryptPA0(encryptedData, eka);

      expect(decryptedData, pa0);
    });
  });
}

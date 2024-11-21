import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:t3_vault/src/common/cryptography/usecases/encryption_service.dart';

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
      final encryptedData = await encryptionService.encrypt(pa0, eka);

      expect(encryptedData, isNotNull);
      expect(encryptedData.length, greaterThan(12 + 16));
    });

    test('decryptPA0 should decrypt encrypted data back to original pa0', () async {
      final encryptedData = await encryptionService.encrypt(pa0, eka);

      final decryptedData = await encryptionService.decrypt(encryptedData, eka);

      expect(decryptedData, pa0);
    });

    test('encrypt should produce unique nonces for each encryption', () async {
      final List<List<int>> previousNonces = [];
      const int testIterations = 10000;

      for (int i = 0; i < testIterations; i++) {
        final pa0 = List.generate(16, (_) => Random().nextInt(256)).join();
        final encryptedData = await encryptionService.encrypt(pa0, eka);

        final nonce = encryptedData.sublist(0, 12);

        final isDuplicate = previousNonces.any((prevNonce) => listEquals(prevNonce, nonce));
        expect(isDuplicate, isFalse, reason: 'Nonce repetition detected.');

        previousNonces.add(nonce);
      }
    }, timeout: const Timeout(Duration(seconds: 60)), skip: true);
  });
}

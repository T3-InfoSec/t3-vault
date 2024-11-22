import 'package:flutter_test/flutter_test.dart';
import 'package:t3_vault/src/common/cryptography/usecases/key_generator.dart';

void main() {
  group('KeyGenerator', () {
    late KeyGenerator keyGenerator;

    setUp(() {
      keyGenerator = KeyGenerator();
    });

    test('generateHexadecimalKey generates a key with 32 hexadecimal characters in groups of 4 separated by spaces', () {
      String key = keyGenerator.generateHexadecimalKey();
      
      expect(key.length, 39, reason: 'The length of the generated key is not correct.');

      final groups = key.split(' ');
      expect(groups.length, 8, reason: 'The generated key does not have the correct blocks.');
      for (var group in groups) {
        expect(group.length, 4, reason: 'Each block must be exactly 4 characters long.');
        expect(RegExp(r'^[A-F0-9]{4}$').hasMatch(group), isTrue, reason: 'Each block must contain only hexadecimal characters.');
      }
    });

    test('generateHexadecimalKey generates different keys on subsequent calls', () {
      String key1 = keyGenerator.generateHexadecimalKey();
      String key2 = keyGenerator.generateHexadecimalKey();
      expect(key1, isNot(key2), reason: 'Each call must generate a different key.');
    });

    test('generateHexadecimalKey always generates uppercase keys', () {
      String key = keyGenerator.generateHexadecimalKey();
      expect(key, equals(key.toUpperCase()), reason: 'The key should be in capital letters.');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:t3_vault/src/common/cryptography/usecases/bip_39_generator.dart';

void main() {
  group('Bip39generator', () {
    late Bip39generator bip39generator;

    setUp(() {
      bip39generator = Bip39generator();
    });

    test('generataSixWordsSeed generates a seed with six words', () {
      String seed = bip39generator.generataSixWordsSeed();
      expect(seed.split(' ').length, 6, reason: 'The seed generated does not have six words.');
    });

    test('generataSixWordsSeed generates different seeds on subsequent calls', () {
      String seed1 = bip39generator.generataSixWordsSeed();
      String seed2 = bip39generator.generataSixWordsSeed();
      expect(seed1, isNot(seed2), reason: 'The seeds generated should be different for each call.');
    });

    test('deriveTwelveWordsSeed generates a seed with twelve words from a given key', () {
      String seed = bip39generator.deriveTwelveWordsSeed('exampleKey');
      expect(seed.split(' ').length, 12, reason: 'The derived seed does not have twelve words.');
    });

    test('deriveTwelveWordsSeed generates consistent output for the same key', () {
      String seed1 = bip39generator.deriveTwelveWordsSeed('exampleKey');
      String seed2 = bip39generator.deriveTwelveWordsSeed('exampleKey');
      expect(seed1, seed2, reason: 'Seed derivation should be consistent for the same key.');
    });

    test('deriveTwelveWordsSeed generates different seeds for different keys', () {
      String seed1 = bip39generator.deriveTwelveWordsSeed('exampleKey');
      String seed2 = bip39generator.deriveTwelveWordsSeed('exampleKeyNumber2');
      expect(seed1, isNot(seed2), reason: 'The derived seeds should be different for different keys.');
    });
  });
}

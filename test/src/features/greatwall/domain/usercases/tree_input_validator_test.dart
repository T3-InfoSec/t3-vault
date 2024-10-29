


import 'package:flutter_test/flutter_test.dart';
import 'package:t3_vault/src/features/greatwall/domain/usecases/tree_input_validator.dart';

void main() {
  group('TreeInputValidator', () {
    test('validateArity should return error for values less than 2', () {
      expect(TreeInputValidator.validateArity('1'), 'Choose tree arity from 2 to 256');
    });

    test('validateArity should return error for values greater than 256', () {
      expect(TreeInputValidator.validateArity('257'), 'Choose tree arity from 2 to 256');
    });

    test('validateArity should return error for non-integer values', () {
      expect(TreeInputValidator.validateArity('abc'), 'Choose tree arity from 2 to 256');
    });

    test('validateArity should return null for values between 2 and 256', () {
      expect(TreeInputValidator.validateArity('2'), isNull);
      expect(TreeInputValidator.validateArity('256'), isNull);
    });

    test('validateDepth should return error for values less than 1', () {
      expect(TreeInputValidator.validateDepth('0'), 'Choose tree depth from 1 to 256');
    });

    test('validateDepth should return error for values greater than 256', () {
      expect(TreeInputValidator.validateDepth('257'), 'Choose tree depth from 1 to 256');
    });

    test('validateDepth should return error for non-integer values', () {
      expect(TreeInputValidator.validateDepth('abc'), 'Choose tree depth from 1 to 256');
    });

    test('validateDepth should return null for values between 1 and 256', () {
      expect(TreeInputValidator.validateDepth('1'), isNull);
      expect(TreeInputValidator.validateDepth('256'), isNull);
    });

    test('validateTimeLock should return error for values less than 1', () {
      expect(TreeInputValidator.validateTimeLock('0'), 'Choose TLP param from 1 to 2016');
    });

    test('validateTimeLock should return error for values greater than 2016', () {
      expect(TreeInputValidator.validateTimeLock('2017'), 'Choose TLP param from 1 to 2016');
    });

    test('validateTimeLock should return error for non-integer values', () {
      expect(TreeInputValidator.validateTimeLock('abc'), 'Choose TLP param from 1 to 2016');
    });

    test('validateTimeLock should return null for values between 1 and 2016', () {
      expect(TreeInputValidator.validateTimeLock('1'), isNull);
      expect(TreeInputValidator.validateTimeLock('2016'), isNull);
    });
  });
}

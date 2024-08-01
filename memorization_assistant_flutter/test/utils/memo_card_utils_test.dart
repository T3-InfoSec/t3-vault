import 'package:flutter_test/flutter_test.dart';

import 'package:intl/intl.dart';

import 'package:memorization_assistant_flutter/utils/memo_card_utils.dart';

void main() {
  group('MemoCardUtils', () {
    
    group('formatDueDate', () {
      test('should return "Not scheduled" when the due date is null', () {
        final result = MemoCardUtils.formatDueDate(null);
        expect(result, 'Not scheduled');
      });

      test('should return formatted date string for a valid due date', () {
        final DateTime date = DateTime(2024, 8, 2, 15, 30);
        final result = MemoCardUtils.formatDueDate(date);
        expect(result, DateFormat('yyyy-MM-dd HH:mm').format(date.toLocal()));
      });
    });

    group('mapStatusToLabel', () {
      test('should return "new" for status 0', () {
        final result = MemoCardUtils.mapStatusToLabel(0);
        expect(result, 'new');
      });

      test('should return "learning" for status 1', () {
        final result = MemoCardUtils.mapStatusToLabel(1);
        expect(result, 'learning');
      });

      test('should return "review" for status 2', () {
        final result = MemoCardUtils.mapStatusToLabel(2);
        expect(result, 'review');
      });

      test('should return "relearning" for status 3', () {
        final result = MemoCardUtils.mapStatusToLabel(3);
        expect(result, 'relearning');
      });

      test('should return "unknown" for an undefined status code', () {
        final result = MemoCardUtils.mapStatusToLabel(999);
        expect(result, 'unknown');
      });
    });
  });
}

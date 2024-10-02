import 'package:flutter_test/flutter_test.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/memo_card_converter.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/memo_card_entity.dart';

void main() {
  group('MemoCardConverter', () {
    test('toEntity converts MemoCard to MemoCardEntity correctly', () {
      // Arrange
      final memoCard = MemoCard(
        knowledge: 'Sample knowledge',
        due: DateTime(2024, 10, 5),
        lastReview: DateTime(2024, 10, 1),
        stability: 0.85,
        difficulty: 0.4,
        elapsedDays: 4,
        scheduledDays: 7,
        reps: 5,
        lapses: 1,
        stateIndex: 2,
      );

      // Act
      final entity = MemoCardConverter.toEntity(memoCard);

      // Assert
      expect(entity.knowledge, memoCard.knowledge);
      expect(entity.due, memoCard.due);
      expect(entity.lastReview, memoCard.card.lastReview);
      expect(entity.stability, memoCard.card.stability);
      expect(entity.difficulty, memoCard.card.difficulty);
      expect(entity.elapsedDays, memoCard.card.elapsedDays);
      expect(entity.scheduledDays, memoCard.card.scheduledDays);
      expect(entity.reps, memoCard.card.reps);
      expect(entity.lapses, memoCard.card.lapses);
      expect(entity.stateIndex, memoCard.state.index);
    });

    test('fromEntity converts MemoCardEntity to MemoCard correctly', () {
      // Arrange
      final entity = MemoCardEntity(
        knowledge: 'Sample knowledge',
        due: DateTime(2024, 10, 5),
        lastReview: DateTime(2024, 10, 1),
        stability: 0.85,
        difficulty: 0.4,
        elapsedDays: 4,
        scheduledDays: 7,
        reps: 5,
        lapses: 1,
        stateIndex: 2,
      );

      // Act
      final memoCard = MemoCardConverter.fromEntity(entity);

      // Assert
      expect(memoCard.knowledge, entity.knowledge);
      expect(memoCard.due, entity.due);
      expect(memoCard.card.lastReview, entity.lastReview);
      expect(memoCard.card.stability, entity.stability);
      expect(memoCard.card.difficulty, entity.difficulty);
      expect(memoCard.card.elapsedDays, entity.elapsedDays);
      expect(memoCard.card.scheduledDays, entity.scheduledDays);
      expect(memoCard.card.reps, entity.reps);
      expect(memoCard.card.lapses, entity.lapses);
      expect(memoCard.card.state.index, entity.stateIndex);
    });

    test('toEntity and fromEntity maintain data consistency', () {
      // Arrange
      final memoCard = MemoCard(
        knowledge: 'Another knowledge sample',
        due: DateTime(2024, 11, 5),
        lastReview: DateTime(2024, 11, 1),
        stability: 0.9,
        difficulty: 0.3,
        elapsedDays: 3,
        scheduledDays: 6,
        reps: 7,
        lapses: 2,
        stateIndex: 1,
      );

      // Act
      final entity = MemoCardConverter.toEntity(memoCard);
      final restoredMemoCard = MemoCardConverter.fromEntity(entity);

      // Assert
      expect(restoredMemoCard.knowledge, memoCard.knowledge);
      expect(restoredMemoCard.due, memoCard.due);
      expect(restoredMemoCard.card.lastReview, memoCard.card.lastReview);
      expect(restoredMemoCard.card.stability, memoCard.card.stability);
      expect(restoredMemoCard.card.difficulty, memoCard.card.difficulty);
      expect(restoredMemoCard.card.elapsedDays, memoCard.card.elapsedDays);
      expect(restoredMemoCard.card.scheduledDays, memoCard.card.scheduledDays);
      expect(restoredMemoCard.card.reps, memoCard.card.reps);
      expect(restoredMemoCard.card.lapses, memoCard.card.lapses);
      expect(restoredMemoCard.state.index, memoCard.state.index);
    });
  });
}

import 'memo_card_entity.dart';
import 'package:t3_memassist/memory_assistant.dart';

/// A utility class for converting between [MemoCard] and [MemoCardEntity].
///
/// It ensures that the conversion handles all necessary fields for the 
/// memorization algorithm to work correctly across the application's data 
/// layers.
class MemoCardConverter {

  /// Converts a [MemoCard] into a [MemoCardEntity].
  ///
  /// This method takes a [MemoCard] and extracts its fields to create 
  /// a corresponding [MemoCardEntity]. This is used when 
  /// saving the memorization card details to persistent storage.
  static MemoCardEntity toEntity(MemoCard memoCard) {
    return MemoCardEntity(
      knowledge: memoCard.knowledge,
      due: memoCard.due,
      lastReview: memoCard.card.lastReview,
      stability: memoCard.card.stability,
      difficulty: memoCard.card.difficulty,
      elapsedDays: memoCard.card.elapsedDays,
      scheduledDays: memoCard.card.scheduledDays,
      reps: memoCard.card.reps,
      lapses: memoCard.card.lapses,
      stateIndex: memoCard.state.index,
    );
  }

  /// Converts a [MemoCardEntity] back into a [MemoCard].
  ///
  /// This method takes a [MemoCardEntity] and reconstructs a [MemoCard] 
  /// object from it. This is used when retrieving stored 
  /// memorization card details from a database.
  static MemoCard fromEntity(MemoCardEntity entity) {
    return MemoCard(
      knowledge: entity.knowledge,
      due: entity.due,
      lastReview: entity.lastReview,
      stability: entity.stability,
      difficulty: entity.difficulty,
      elapsedDays: entity.elapsedDays,
      scheduledDays: entity.scheduledDays,
      reps: entity.reps,
      lapses: entity.lapses,
      stateIndex: entity.stateIndex,
    );
  }
}

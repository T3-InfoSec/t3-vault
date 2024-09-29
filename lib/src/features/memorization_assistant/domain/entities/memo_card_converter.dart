import 'memo_card_entity.dart';
import 'package:t3_memassist/memory_assistant.dart';

class MemoCardConverter {

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

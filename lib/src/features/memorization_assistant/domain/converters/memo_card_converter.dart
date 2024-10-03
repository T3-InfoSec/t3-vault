import 'package:great_wall/great_wall.dart';
import 'package:t3_memassist/memory_assistant.dart';

import '../entities/formosa_tacit_knowledge_entity.dart';
import '../entities/hashviz_tacit_knowledge_entity.dart';
import '../entities/memo_card_entity.dart';

import 'tacit_knowledge_converter.dart';

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
    // Serialize tacit knowledge using the helper method.
    final serializedKnowledge = memoCard.knowledge;
    serializedKnowledge['tacitKnowledge'] = _serializeTacitKnowledge(memoCard.knowledge['tacitKnowledge']);

    return MemoCardEntity(
      knowledge: serializedKnowledge,
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
    final deserializedKnowledge = entity.knowledge;
    deserializedKnowledge['tacitKnowledge'] = _deserializeTacitKnowledge(entity.knowledge['tacitKnowledge']);

    return MemoCard(
      knowledge: deserializedKnowledge,
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

  /// Helper method to convert tacit knowledge for both Formosa and HashViz types.
  static dynamic _serializeTacitKnowledge(dynamic tacitKnowledge) {
    if (tacitKnowledge is FormosaTacitKnowledge) {
      return TacitKnowledgeConverter.fromFormosaTacitKnowledge(tacitKnowledge);
    } else if (tacitKnowledge is HashVizTacitKnowledge) {
      return TacitKnowledgeConverter.fromHashvizTacitKnowledge(tacitKnowledge);
    }
    return tacitKnowledge;
  }

  /// Helper method to deserialize tacit knowledge back to its respective type.
  static dynamic _deserializeTacitKnowledge(dynamic tacitKnowledgeEntity) {
    if (tacitKnowledgeEntity is FormosaTacitKnowledgeEntity) {
      return TacitKnowledgeConverter.toFormosaTacitKnowledge(tacitKnowledgeEntity);
    } else if (tacitKnowledgeEntity is HashvizTacitKnowledgeEntity) {
      return TacitKnowledgeConverter.toHashvizTacitKnowledge(tacitKnowledgeEntity);
    }
    return tacitKnowledgeEntity;
  }
}

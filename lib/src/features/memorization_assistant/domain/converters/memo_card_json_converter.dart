import 'package:t3_memassist/memory_assistant.dart';
import 'package:uuid/uuid.dart';

class MemoCardConverter {
  static const _uuid = Uuid();

  /// Converts a MemoCard object to JSON format.
  static Map<String, dynamic> toJson(MemoCard memoCard) {
    Map<String, dynamic> jsonMemoCard;
    switch (memoCard.runtimeType) {
      case const (TacitKnowledgeMemoCard):
        jsonMemoCard = generateTacitKnowledgeJson(memoCard);
        break;
      default:
        jsonMemoCard = generateBasicKnowledgeJson(memoCard);
    }
    
    return jsonMemoCard;
  }

  /// Converts JSON to a MemoCard object.
  static MemoCard fromJson(Map<String, dynamic> json) {
    final knowledge = json['knowledge'];
    final cardType = json['cardType'];

    MemoCard memoCard;

    switch (cardType) {
      case 'Pa0MemoCard':
        memoCard = Pa0MemoCard(
          pa0: knowledge['pa0'],
          deck: Deck(json['deckId'], json['deckName']),
          due: DateTime.parse(json['due']),
          lastReview: DateTime.parse(json['lastReview']),
          stability: json['stability'],
          difficulty: json['difficulty'],
          elapsedDays: json['elapsedDays'],
          scheduledDays: json['scheduledDays'],
          reps: json['reps'],
          lapses: json['lapses'],
          stateIndex: json['stateIndex'],
        );
      case 'TacitKnowledgeMemoCard':
        memoCard = TacitKnowledgeMemoCard(
          knowledge: {
            'node': knowledge['node'],
            'selectedNode': knowledge['selectedNode'],
            'treeArity': knowledge['treeArity'],
          },
          title: json['title'],
          deck: Deck(json['deckId'], json['deckName']),
          due: DateTime.parse(json['due']),
          lastReview: DateTime.parse(json['lastReview']),
          stability: json['stability'],
          difficulty: json['difficulty'],
          elapsedDays: json['elapsedDays'],
          scheduledDays: json['scheduledDays'],
          reps: json['reps'],
          lapses: json['lapses'],
          stateIndex: json['stateIndex'],
        );
      case 'EkaMemoCard':
        memoCard = EkaMemoCard(
          eka: knowledge['eka'],
          deck: Deck(json['deckId'], json['deckName']),
          due: DateTime.parse(json['due']),
          lastReview: DateTime.parse(json['lastReview']),
          stability: json['stability'],
          difficulty: json['difficulty'],
          elapsedDays: json['elapsedDays'],
          scheduledDays: json['scheduledDays'],
          reps: json['reps'],
          lapses: json['lapses'],
          stateIndex: json['stateIndex'],
        );
      default:
        return MemoCard(
          knowledge: knowledge,
          title: json['title'],
          deck: Deck(json['deckId'], json['deckName']),
          due: DateTime.parse(json['due']),
          lastReview: DateTime.parse(json['lastReview']),
          stability: json['stability'],
          difficulty: json['difficulty'],
          elapsedDays: json['elapsedDays'],
          scheduledDays: json['scheduledDays'],
          reps: json['reps'],
          lapses: json['lapses'],
          stateIndex: json['stateIndex'],
        );
    }

    return memoCard;
  }

  static Map<String, dynamic> generateBasicKnowledgeJson(MemoCard memoCard) {
    return {
      'knowledge': memoCard.knowledge,
      'title': memoCard.title,
      'cardType': memoCard.runtimeType.toString(),
      'deckId': memoCard.deck.id,
      'deckName': memoCard.deck.name,
      'due': memoCard.due.toIso8601String(),
      'lastReview': memoCard.card.lastReview.toIso8601String(),
      'stability': memoCard.card.stability,
      'difficulty': memoCard.card.difficulty,
      'elapsedDays': memoCard.card.elapsedDays,
      'scheduledDays': memoCard.card.scheduledDays,
      'reps': memoCard.card.reps,
      'lapses': memoCard.card.lapses,
      'stateIndex': memoCard.card.state.index,
    };
  }

  static Map<String, dynamic> generateTacitKnowledgeJson(MemoCard memoCard) {
    final knowledge = memoCard.knowledge;

    return {
      'knowledge': {
        'node': knowledge['node'],
        'selectedNode': knowledge['selectedNode'],
        'treeArity': knowledge['treeArity'],
      },
      'title': memoCard.title,
      'cardType': memoCard.runtimeType.toString(),
      'deckId': memoCard.deck.id,
      'deckName': memoCard.deck.name,
      'due': memoCard.due.toIso8601String(),
      'lastReview': memoCard.card.lastReview.toIso8601String(),
      'stability': memoCard.card.stability,
      'difficulty': memoCard.card.difficulty,
      'elapsedDays': memoCard.card.elapsedDays,
      'scheduledDays': memoCard.card.scheduledDays,
      'reps': memoCard.card.reps,
      'lapses': memoCard.card.lapses,
      'stateIndex': memoCard.card.state.index,
    };
  }

  /// Returns a newly generated UUID as a string.
  static String generateId() {
    return _uuid.v4();
  }
}

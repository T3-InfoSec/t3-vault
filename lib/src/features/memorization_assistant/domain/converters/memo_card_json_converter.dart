import 'package:flutter/material.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_formosa/formosa.dart';
import 'package:t3_memassist/memory_assistant.dart';

class MemoCardConverter {

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
        memoCard = Sa0MemoCard(
          sa0: knowledge['pa0'],
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
          id: json['id']
        );
      case 'TacitKnowledgeMemoCard':
        TacitKnowledge? tacitKnowledge = getTacitKnowledge(knowledge);
        memoCard = TacitKnowledgeMemoCard(
          knowledge: {
            'level': knowledge['level'],
            'node': knowledge['node'],
            'selectedNode': knowledge['selectedNode'],
            'treeArity': knowledge['treeArity'],
            'treeDepth': knowledge['treeDepth'],
            if (tacitKnowledge != null) 'tacitKnowledge': tacitKnowledge,
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
          id: json['id'],
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
          id: json['id'],
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
          id: json['id'],
        );
    }

    return memoCard;
  }

  static String? extractDeckIdFromJson(Map<String, dynamic> json) {
    try {
      return json['deckId'] as String?;
    } catch (e) {
      debugPrint('Error decoding payload: $e');
      return null;
    }
  }

  static String? extractMemoCardIdFromJson(Map<String, dynamic> json) {
    try {
      return json['id'] as String?;
    } catch (e) {
      debugPrint('Error decoding payload: $e');
      return null;
    }
  }

  static Map<String, dynamic> generateBasicKnowledgeJson(MemoCard memoCard) {
    return {
      'knowledge': memoCard.knowledge,
      'title': memoCard.title,
      'id': memoCard.id,
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
    final tacitKnowledge = knowledge['tacitKnowledge'];
    final formosaThemeName = tacitKnowledge.configs['formosaTheme']?.name;
    final tacitKnowledgeType = _getTacitKnowledgeType(tacitKnowledge);
    final tacitKnowledgeConfigs =
        _getConfigsWithFormosaThemeName(formosaThemeName, tacitKnowledge);

    return {
      'knowledge': {
        'level': knowledge['level'],
        'node': knowledge['node'],
        'selectedNode': knowledge['selectedNode'],
        'treeArity': knowledge['treeArity'],
        'treeDepth': knowledge['treeDepth'],
        'tacitKnowledgeConfigs': tacitKnowledgeConfigs,
        'tacitKnowledgeType': tacitKnowledgeType,
      },
      'title': memoCard.title,
      'id': memoCard.id,
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

  /// Creates a configuration map including the Formosa theme name.
  ///
  /// Combines existing configurations from [tacitKnowledge] and adds
  /// [formosaThemeName], if provided, returning a map containing the
  /// configurations.
  static Map<String, dynamic> _getConfigsWithFormosaThemeName(
      formosaThemeName, tacitKnowledge) {
    final configs = <String, dynamic>{};
    if (tacitKnowledge.configs != null) {
      configs.addAll(tacitKnowledge.configs);
    }
    if (formosaThemeName != null) {
      configs['formosaTheme'] = formosaThemeName;
    }
    return configs;
  }

  /// Identifies the type of tacit knowledge.
  ///
  /// Checks if [tacitKnowledge] is of type [FormosaTacitKnowledge] or
  /// [HashVizTacitKnowledge] and returns a corresponding string or an
  /// empty string if unknown.
  static String _getTacitKnowledgeType(tacitKnowledge) {
    String tacitKnowledgeType;
    if (tacitKnowledge is FormosaTacitKnowledge) {
      tacitKnowledgeType = 'FormosaTacitKnowledge';
    } else if (tacitKnowledge is HashVizTacitKnowledge) {
      tacitKnowledgeType = 'HashVizTacitKnowledge';
    } else {
      tacitKnowledgeType = "";
    }
    return tacitKnowledgeType;
  }

  static TacitKnowledge? getTacitKnowledge(knowledge) {
    TacitKnowledge? tacitKnowledge;

    if (knowledge.containsKey('tacitKnowledgeConfigs')) {
      final tacitKnowledgeConfigs = knowledge['tacitKnowledgeConfigs'];
      final tacitKnowledgeType = knowledge['tacitKnowledgeType'];

      // Create TacitKnowledge instance based on its type
      if (tacitKnowledgeType == 'FormosaTacitKnowledge') {
        final formosaThemeName = tacitKnowledgeConfigs['formosaTheme'];
        FormosaTheme? formosaTheme;

        if (formosaThemeName != null) {
          formosaTheme = FormosaTheme.values
              .firstWhere((theme) => theme.name == formosaThemeName);
        }
        tacitKnowledgeConfigs['formosaTheme'] = formosaTheme;
        tacitKnowledge = FormosaTacitKnowledge(
          configs: tacitKnowledgeConfigs,
        );
      } else if (tacitKnowledgeType == 'HashVizTacitKnowledge') {
        tacitKnowledge = HashVizTacitKnowledge(
          configs: tacitKnowledgeConfigs,
        );
      }
    }
    return tacitKnowledge;
  }
}

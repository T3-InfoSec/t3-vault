import 'package:great_wall/great_wall.dart';
import 'package:t3_formosa/formosa.dart';
import 'package:t3_memassist/memory_assistant.dart';
import 'package:uuid/uuid.dart';

class MemoCardConverter {
  static const _uuid = Uuid();

  /// Converts a MemoCard object to JSON format.
  static Map<String, dynamic> toJson(MemoCard memoCard) {
    final knowledge = memoCard.knowledge;
    final tacitKnowledge = knowledge['tacitKnowledge'];
    final formosaThemeName = tacitKnowledge.configs['formosaTheme']?.name;
    String? tacitKnowledgeType = _getTacitKnowledgeType(tacitKnowledge);

    Map<String, dynamic> tacitKnowledgeConfigs =
        _getConfigsWithFormosaThemeName(formosaThemeName, tacitKnowledge);

    return {
      'knowledge': {
        'treeArity': knowledge['treeArity'],
        'treeDepth': knowledge['treeDepth'],
        'timeLockPuzzleParam': knowledge['timeLockPuzzleParam'],
        'tacitKnowledgeConfigs': tacitKnowledgeConfigs,
        'tacitKnowledgeType': tacitKnowledgeType,
      },
      'deck': memoCard.deck,
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

  /// Converts JSON to a MemoCard object.
  static MemoCard fromJson(Map<String, dynamic> json) {
    final knowledge = json['knowledge'];

    TacitKnowledge? tacitKnowledge;

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

    return MemoCard(
      knowledge: {
        ...knowledge,
        'tacitKnowledge': tacitKnowledge,
      },
      deck: json['deck'],
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

  /// Returns a newly generated UUID as a string.
  static String generateId() {
    return _uuid.v4();
  }
}

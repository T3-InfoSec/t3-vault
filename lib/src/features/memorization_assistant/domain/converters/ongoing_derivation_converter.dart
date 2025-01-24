import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/intermediate_derivation_state_entity.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/ongoing_derivation_entity.dart';

class OngoingDerivationConverter {
  /// Converts a JSON object into an `OngoingDerivationEntity` instance.
  static OngoingDerivationEntity fromJson(Map<String, dynamic> json) {
    return OngoingDerivationEntity(
      treeArity: json['treeArity'] as int,
      treeDepth: json['treeDepth'] as int,
      timeLockPuzzleParam: json['timeLockPuzzleParam'] as int,
      tacitKnowledge: getTacitKnowledge(json)!,
      encryptedSa0: json['encryptedSa0'] as String,
      intermediateDerivationStates: (json['intermediateDerivationStates'] as List)
          .map((state) => IntermediateDerivationStateEntity(
                encryptedValue: state['value'] as String,
                currentIteration: state['currentIteration'] as int,
                totalIterations: state['totalIterations'] as int,
              ))
          .toList(),
    );
  }

  /// Converts an `OngoingDerivationEntity` instance into a JSON object.
  static Map<String, dynamic> toJson(OngoingDerivationEntity entity) {
    final tacitKnowledge = entity.tacitKnowledge;
    final formosaThemeName = tacitKnowledge.configs['formosaTheme']?.name;
        final tacitKnowledgeType = _getTacitKnowledgeType(tacitKnowledge);
    final tacitKnowledgeConfigs =
        _getConfigsWithFormosaThemeName(formosaThemeName, tacitKnowledge);
    return {
      'treeArity': entity.treeArity,
      'treeDepth': entity.treeDepth,
      'timeLockPuzzleParam': entity.timeLockPuzzleParam,
      'tacitKnowledgeConfigs': tacitKnowledgeConfigs,
      'tacitKnowledgeType': tacitKnowledgeType,
      'encryptedSa0': entity.encryptedSa0,
      'intermediateDerivationStates': entity.intermediateDerivationStates.map((state) {
        return {
          'value': state.encryptedValue,
          'currentIteration': state.currentIteration,
          'totalIterations': state.totalIterations,
        };
      }).toList(),
    };
  }

// TODO: move next duplicated methods to an utils file.

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
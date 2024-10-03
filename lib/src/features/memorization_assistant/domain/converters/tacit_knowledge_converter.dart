import 'dart:convert';

import 'package:great_wall/great_wall.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/formosa_tacit_knowledge_entity.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/hashviz_tacit_knowledge_entity.dart';

/// A utility class for converting between [TacitKnowledge] and its respective
/// entity types.
class TacitKnowledgeConverter {
  /// Converts a [FormosaTacitKnowledge] object into a [FormosaTacitKnowledgeEntity].
  static FormosaTacitKnowledgeEntity fromFormosaTacitKnowledge(
      FormosaTacitKnowledge tacitKnowledge) {
    final encodedParam = _encodeParam(tacitKnowledge.param);
    return FormosaTacitKnowledgeEntity(
      configs: tacitKnowledge.configs,
      paramName: encodedParam['paramName'],
      paramInitialState: encodedParam['paramInitialState'],
      paramAdjustmentValue: encodedParam['paramAdjustmentValue'],
    );
  }

  /// Converts a [HashVizTacitKnowledge] object into a [HashvizTacitKnowledgeEntity].
  static HashvizTacitKnowledgeEntity fromHashvizTacitKnowledge(
      HashVizTacitKnowledge tacitKnowledge) {
    final encodedParam = _encodeParam(tacitKnowledge.param);
    return HashvizTacitKnowledgeEntity(
      configs: tacitKnowledge.configs,
      paramName: encodedParam['paramName'],
      paramInitialState: encodedParam['paramInitialState'],
      paramAdjustmentValue: encodedParam['paramAdjustmentValue'],
    );
  }

  /// Converts a [FormosaTacitKnowledgeEntity] back into a [FormosaTacitKnowledge].
  static FormosaTacitKnowledge toFormosaTacitKnowledge(
      FormosaTacitKnowledgeEntity entity) {
    return FormosaTacitKnowledge(
      configs: entity.configs,
      param: _decodeParam(
        entity.paramName,
        entity.paramInitialState,
        entity.paramAdjustmentValue,
      ),
    );
  }

  /// Converts a [HashvizTacitKnowledgeEntity] back into a [HashVizTacitKnowledge].
  static HashVizTacitKnowledge toHashvizTacitKnowledge(
      HashvizTacitKnowledgeEntity entity) {
    return HashVizTacitKnowledge(
      configs: entity.configs,
      param: _decodeParam(
        entity.paramName,
        entity.paramInitialState,
        entity.paramAdjustmentValue,
      ),
    );
  }

  /// Helper method to convert a [TacitKnowledgeParam] into its base64 encoded string fields.
  static Map<String, String?> _encodeParam(TacitKnowledgeParam? param) {
    if (param == null) {
      return {
        'paramName': null,
        'paramInitialState': null,
        'paramAdjustmentValue': null,
      };
    }
    return {
      'paramName': param.name,
      'paramInitialState': base64Encode(param.initialState),
      'paramAdjustmentValue': base64Encode(param.adjustmentValue),
    };
  }

  /// Helper method to decode base64 encoded strings back into a [TacitKnowledgeParam].
  static TacitKnowledgeParam? _decodeParam(String? paramName, String? initialState, String? adjustmentValue) {
    if (paramName == null || initialState == null || adjustmentValue == null) {
      return null;
    }
    return TacitKnowledgeParam(
      name: paramName,
      initialState: base64Decode(initialState),
      adjustmentValue: base64Decode(adjustmentValue),
    );
  }
}

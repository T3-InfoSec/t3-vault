import 'package:t3_vault/src/features/memorization_assistant/domain/entities/intermediate_derivation_state_entity.dart';

class IntermediateDerivationStateConverter {
  /// Converts a JSON object into an [IntermediateDerivationStateEntity] instance.
  static IntermediateDerivationStateEntity fromJson(Map<String, dynamic> json) {
    return IntermediateDerivationStateEntity(
      value: json['value'] as String,
      currentIteration: json['currentIteration'] as int,
      totalIterations: json['totalIterations'] as int,
    );
  }

  /// Converts an [intermediateState] into a JSON object.
  static Map<String, dynamic> toJson(IntermediateDerivationStateEntity intermediateState) {
    return {
      'value': intermediateState.value,
      'currentIteration': intermediateState.currentIteration,
      'totalIterations': intermediateState.totalIterations,
    };
  }
}

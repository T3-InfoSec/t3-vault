import 'package:great_wall/great_wall.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/intermediate_derivation_state_entity.dart';

/// Repository entity that represents an ongoing derivation
class OngoingDerivationEntity {
  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final TacitKnowledge tacitKnowledge;
  final String encryptedSa0;
  final List<IntermediateDerivationStateEntity> intermediateDerivationStates;

  OngoingDerivationEntity({
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.tacitKnowledge,
    required this.encryptedSa0,
    required this.intermediateDerivationStates,
  });
}

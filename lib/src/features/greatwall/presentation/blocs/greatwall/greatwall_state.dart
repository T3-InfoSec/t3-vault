import 'package:equatable/equatable.dart';
import 'package:great_wall/great_wall.dart';

sealed class GreatWallState extends Equatable {
  @override
  List<Object> get props => [];
}

final class GreatWallInitial extends GreatWallState {}

final class GreatWallTacitKnowledgeSelectSuccess extends GreatWallState {
  final String tacitKnowledge;

  GreatWallTacitKnowledgeSelectSuccess(this.tacitKnowledge);

  @override
  List<Object> get props => [tacitKnowledge];
}

class GreatWallInitialSuccess extends GreatWallState {
  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final TacitKnowledge tacitKnowledge;
  final String secretSeed;

  GreatWallInitialSuccess({
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.tacitKnowledge,
    required this.secretSeed,
  });

  @override
  List<Object> get props =>
      [treeArity, treeDepth, timeLockPuzzleParam, tacitKnowledge, secretSeed];
}

final class GreatWallDeriveInProgress extends GreatWallState {}

final class GreatWallDeriveStepSuccess extends GreatWallState {
  final int treeDepth;
  final int currentLevel;
  final List<dynamic> knowledgePalettes;
  final TacitKnowledge tacitKnowledge;

  GreatWallDeriveStepSuccess({
    required this.treeDepth,
    required this.currentLevel,
    required this.knowledgePalettes,
    required this.tacitKnowledge,
  });

  @override
  List<Object> get props =>
      [treeDepth, currentLevel, knowledgePalettes, tacitKnowledge];
}

final class GreatWallFinishSuccess extends GreatWallState {
  final String derivationHashResult;

  GreatWallFinishSuccess(this.derivationHashResult);

  @override
  List<Object> get props => [derivationHashResult];
}

// class GreatWallLoadedArityIndexes extends GreatWallState {
//   final int treeDepth;
//   final int currentLevel;
//   final List<dynamic> knowledgeValues;
//   final TacitKnowledge tacitKnowledge;
//
//   GreatWallLoadedArityIndexes({
//     required this.treeDepth,
//     required this.currentLevel,
//     required this.knowledgeValues,
//     required this.tacitKnowledge,
//   });
//
//   @override
//   List<Object> get props =>
//      [treeDepth, currentLevel, knowledgePalettes, tacitKnowledge];
// }

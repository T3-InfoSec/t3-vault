import 'package:equatable/equatable.dart';

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

final class GreatWallFormosaThemeSelectSuccess extends GreatWallState {
  final String theme;

  GreatWallFormosaThemeSelectSuccess(this.theme);

  @override
  List<Object> get props => [theme];
}

class GreatWallInitialSuccess extends GreatWallState {
  final String tacitKnowledge;
  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final String secretSeed;

  GreatWallInitialSuccess({
    required this.tacitKnowledge,
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.secretSeed,
  });

  @override
  List<Object> get props =>
      [tacitKnowledge, treeArity, treeDepth, timeLockPuzzleParam, secretSeed];
}

final class GreatWallDeriveInProgress extends GreatWallState {}

final class GreatWallDeriveStepSuccess extends GreatWallState {
  final int currentLevel;
  final List<dynamic> knowledgePalettes;
  final int treeDepth;

  GreatWallDeriveStepSuccess({
    required this.currentLevel,
    required this.knowledgePalettes,
    required this.treeDepth,
  });

  @override
  List<Object> get props => [currentLevel, knowledgePalettes];
}

final class GreatWallFinishSuccess extends GreatWallState {
  final String derivationHashResult;

  GreatWallFinishSuccess(this.derivationHashResult);

  @override
  List<Object> get props => [derivationHashResult];
}

// class GreatWallLoadedArityIndexes extends GreatWallState {
//   final int currentLevel;
//   final List<dynamic> knowledgeValues;
//   final int treeDepth;
//
//   GreatWallLoadedArityIndexes({
//     required this.currentLevel,
//     required this.knowledgeValues,
//     required this.treeDepth,
//   });
//
//   @override
//   List<Object> get props => [currentLevel, knowledgeValues, treeDepth];
// }

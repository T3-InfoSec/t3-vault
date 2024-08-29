import 'package:equatable/equatable.dart';

abstract class GreatWallState extends Equatable {
  @override
  List<Object> get props => [];
}

class GreatWallFormosaThemeState extends GreatWallState {
  final String selectedOption;

  GreatWallFormosaThemeState(this.selectedOption);

  @override
  List<Object> get props => [selectedOption];
}

class GreatWallInitial extends GreatWallState {}

class GreatWallInitialized extends GreatWallState {
  final String tacitKnowledge;
  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final String seed;

  GreatWallInitialized({
    required this.tacitKnowledge,
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.seed,
  });

  @override
  List<Object> get props => [tacitKnowledge, treeArity, treeDepth, timeLockPuzzleParam, seed];
}

class GreatWallLoading extends GreatWallState {}

class GreatWallDeriving extends GreatWallState {
  final int currentLevel;
  final List<dynamic> knowledgePalettes;

  GreatWallDeriving({
    required this.currentLevel,
    required this.knowledgePalettes,
  });

  @override
  List<Object> get props => [currentLevel, knowledgePalettes];
}

class GreatWallLoadedArityIndexes extends GreatWallState {
  final int currentLevel;
  final List<dynamic> knowledgeValues;
  final int treeDepth;

  GreatWallLoadedArityIndexes({
    required this.currentLevel,
    required this.knowledgeValues,
    required this.treeDepth,
  });

  @override
  List<Object> get props => [currentLevel, knowledgeValues, treeDepth];
}

class GreatWallFinished extends GreatWallState {
  final String derivationHashResult;

  GreatWallFinished(this.derivationHashResult);

  @override
  List<Object> get props => [derivationHashResult];
}

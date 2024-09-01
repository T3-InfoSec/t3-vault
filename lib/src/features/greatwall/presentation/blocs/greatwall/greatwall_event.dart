import 'package:equatable/equatable.dart';

sealed class GreatWallEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class GreatWallInitialized extends GreatWallEvent {

  final String tacitKnowledge;
  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final String secretSeed;
  final int? size;

  GreatWallInitialized({
    required this.tacitKnowledge,
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.secretSeed,
    this.size,
  });

  @override
  List<Object> get props =>
      [tacitKnowledge, treeDepth, timeLockPuzzleParam, secretSeed, size!];
}

final class GreatWallReset extends GreatWallEvent {}

final class GreatWallTacitKnowledgeSelected extends GreatWallEvent {
  final String tacitKnowledge;

  GreatWallTacitKnowledgeSelected(this.tacitKnowledge);

  @override
  List<Object> get props => [tacitKnowledge];
}

final class GreatWallFormosaThemeSelected extends GreatWallEvent {
  final String theme;

  GreatWallFormosaThemeSelected(this.theme);

  @override
  List<Object> get props => [theme];
}

final class GreatWallDerivationStarted extends GreatWallEvent {}

final class GreatWallDerivationStepMade extends GreatWallEvent {
  final int choiceNumber;

  GreatWallDerivationStepMade(this.choiceNumber);

  @override
  List<Object> get props => [choiceNumber];
}

final class GreatWallDerivationFinished extends GreatWallEvent {}

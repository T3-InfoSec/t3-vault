import 'package:equatable/equatable.dart';

abstract class GreatWallEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GreatWallFormosaThemeSelected extends GreatWallEvent {
  final String selectedOption;

  GreatWallFormosaThemeSelected(this.selectedOption);

  @override
  List<Object> get props => [selectedOption];
}

class InitializeGreatWall extends GreatWallEvent {
  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final String seed;

  InitializeGreatWall({
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.seed,
  });

  @override
  List<Object> get props => [treeArity, treeDepth, timeLockPuzzleParam, seed];
}

class StartDerivation extends GreatWallEvent {}

class LoadArityIndexes extends GreatWallEvent {}

class MakeTacitDerivation extends GreatWallEvent {
  final int choiceNumber;

  MakeTacitDerivation(this.choiceNumber);

  @override
  List<Object> get props => [choiceNumber];
}

class AdvanceToNextLevel extends GreatWallEvent {}

class GoBackToPreviousLevel extends GreatWallEvent {}

class FinishDerivation extends GreatWallEvent {}

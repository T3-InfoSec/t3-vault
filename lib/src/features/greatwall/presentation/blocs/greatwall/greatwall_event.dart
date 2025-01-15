import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:great_wall/great_wall.dart';

sealed class GreatWallEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GreatWallArityChanged extends GreatWallEvent {
  final String arity;

  GreatWallArityChanged(this.arity);

  @override
  List<Object> get props => [arity];
}

class GreatWallDepthChanged extends GreatWallEvent {
  final String depth;

  GreatWallDepthChanged(this.depth);

  @override
  List<Object> get props => [depth];
}

class GreatWallTimeLockChanged extends GreatWallEvent {
  final String timeLock;

  GreatWallTimeLockChanged(this.timeLock);

  @override
  List<Object> get props => [timeLock];
}

final class GreatWallInitialized extends GreatWallEvent {
  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final TacitKnowledge tacitKnowledge;
  final String sa0Mnemonic;

  GreatWallInitialized({
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.tacitKnowledge,
    required this.sa0Mnemonic,
  });

  @override
  List<Object> get props =>
      [treeDepth, timeLockPuzzleParam, tacitKnowledge, sa0Mnemonic];
}

final class GreatWallReset extends GreatWallEvent {}

final class GreatWallTacitKnowledgeSelected extends GreatWallEvent {
  final TacitKnowledge tacitKnowledge;

  GreatWallTacitKnowledgeSelected(this.tacitKnowledge);

  @override
  List<Object> get props => [tacitKnowledge];
}

final class GreatWallSymmetricToggled extends GreatWallEvent {}

final class GreatWallPasswordVisibilityToggled extends GreatWallEvent {}

final class GreatWallDerivationStarted extends GreatWallEvent {}

final class GreatWallDerivationStepMade extends GreatWallEvent {
  final String choice;

  GreatWallDerivationStepMade(this.choice);

  @override
  List<Object> get props => [choice];
}

final class GreatWallDerivationFinished extends GreatWallEvent {}

final class GreatWallKAVisibilityToggled extends GreatWallEvent {}

final class GreatWallPracticeLevel extends GreatWallEvent {
  final Uint8List node;

  GreatWallPracticeLevel(this.node);

  @override
  List<Object> get props => [node];
}

final class GreatWallPracticeStepMade extends GreatWallEvent {
  final Uint8List currentHash;
  final int choiceNumber;

  GreatWallPracticeStepMade({
    required this.currentHash,
    required this.choiceNumber,
  });

  @override
  List<Object> get props => [currentHash, choiceNumber];
}

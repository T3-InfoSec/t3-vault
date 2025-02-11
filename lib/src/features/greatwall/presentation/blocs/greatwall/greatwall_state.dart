import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:great_wall/great_wall.dart';

sealed class GreatWallState extends Equatable {
  @override
  List<Object> get props => [];
}

class GreatWallInputValid extends GreatWallState {}

class GreatWallInputInvalid extends GreatWallState {
  final Map<String, String> errors;

  GreatWallInputInvalid(this.errors);

  @override
  List<Object> get props => [errors];
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
  final String sa0Mnemonic;

  GreatWallInitialSuccess({
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.tacitKnowledge,
    required this.sa0Mnemonic,
  });

  @override
  List<Object> get props =>
      [treeArity, treeDepth, timeLockPuzzleParam, tacitKnowledge, sa0Mnemonic];
}

final class GreatWallInputsInProgress extends GreatWallState {
  final bool isSymmetric;
  final bool isPasswordVisible;

  GreatWallInputsInProgress(this.isSymmetric, this.isPasswordVisible);

  @override
  List<Object> get props => [isSymmetric, isPasswordVisible];
}

final class GreatWallDeriveInProgress extends GreatWallState {}

final class GreatWallDeriveStepSuccess extends GreatWallState {
  final int treeDepth;
  final int currentLevel;
  final Map<Choice, TacitKnowledge> knowledgePalettes;
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
  final Uint8List derivationHashResult;
  final List<Uint8List> savedNodes;
  final int treeArity;
  final int treeDepth;
  final bool isKAVisible;

  GreatWallFinishSuccess({
    required this.derivationHashResult,
    required this.savedNodes,
    required this.treeArity,
    required this.treeDepth,
    required this.isKAVisible
  });

  @override
  List<Object> get props => [derivationHashResult, savedNodes, treeArity, treeDepth, isKAVisible];
}

final class GreatWallPracticeLevelStarted extends GreatWallState {
  final Map<Choice, TacitKnowledge> knowledgePalettes;
  final GreatWall greatWall;
  
  GreatWallPracticeLevelStarted({
    required this.knowledgePalettes,
    required this.greatWall,
  });

  @override
  List<Object> get props => [knowledgePalettes];
}

final class GreatWallPracticeLevelFinish extends GreatWallState {
  final Uint8List selectedNode;
  
  GreatWallPracticeLevelFinish({
    required this.selectedNode,
  });

  @override
  List<Object> get props => [selectedNode];
}

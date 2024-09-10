import 'package:equatable/equatable.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_formosa/formosa.dart';

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

final class GreatWallFormosaThemeSelectSuccess extends GreatWallState {
  final FormosaTheme theme;

  GreatWallFormosaThemeSelectSuccess(this.theme);

  @override
  List<Object> get props => [theme];
}

class GreatWallInitialSuccess extends GreatWallState {

  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final TacitKnowledgeTypes tacitKnowledgeType;
  final Map<String, dynamic> tacitKnowledgeConfigs;
  final String secretSeed;

  GreatWallInitialSuccess({
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.tacitKnowledgeType,
    required this.tacitKnowledgeConfigs,
    required this.secretSeed,
  });

  @override
  List<Object> get props =>
      [treeArity, treeDepth, timeLockPuzzleParam, tacitKnowledgeType, tacitKnowledgeConfigs, secretSeed];
}

final class GreatWallPasswordVisibility extends GreatWallState {
  final bool isPasswordVisible;

  GreatWallPasswordVisibility(this.isPasswordVisible);

  @override
  List<Object> get props => [isPasswordVisible];
}

final class GreatWallDeriveInProgress extends GreatWallState {}

final class GreatWallDeriveStepSuccess extends GreatWallState {
  final int currentLevel;
  final List<dynamic> knowledgePalettes;
  final int treeDepth;
  final Map<String, dynamic> tacitKnowledgeConfigs;

  GreatWallDeriveStepSuccess({
    required this.currentLevel,
    required this.knowledgePalettes,
    required this.treeDepth,
    required this.tacitKnowledgeConfigs,
  });

  @override
  List<Object> get props => [currentLevel, knowledgePalettes];
}

final class GreatWallFinishSuccess extends GreatWallState {
  final String derivationHashResult;
  final bool isKAVisible;

  GreatWallFinishSuccess(this.derivationHashResult, this.isKAVisible);

  @override
  List<Object> get props => [derivationHashResult, isKAVisible];
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

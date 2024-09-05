import 'package:equatable/equatable.dart';
import 'package:t3_formosa/formosa.dart';
import 'package:great_wall/great_wall.dart';

sealed class GreatWallEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class GreatWallInitialized extends GreatWallEvent {

  final int treeArity;
  final int treeDepth;
  final int timeLockPuzzleParam;
  final TacitKnowledgeTypes tacitKnowledgeType;
  final Map<String, dynamic> tacitKnowledgeConfigs;
  final String secretSeed;

  GreatWallInitialized({
    required this.treeArity,
    required this.treeDepth,
    required this.timeLockPuzzleParam,
    required this.tacitKnowledgeType,
    required this.tacitKnowledgeConfigs,
    required this.secretSeed,
  });

  @override
  List<Object> get props =>
      [treeDepth, timeLockPuzzleParam, tacitKnowledgeType, tacitKnowledgeConfigs, secretSeed];
}

final class GreatWallReset extends GreatWallEvent {}

final class GreatWallTacitKnowledgeSelected extends GreatWallEvent {
  final String tacitKnowledge;

  GreatWallTacitKnowledgeSelected(this.tacitKnowledge);

  @override
  List<Object> get props => [tacitKnowledge];
}

final class GreatWallFormosaThemeSelected extends GreatWallEvent {
  final FormosaTheme theme;

  GreatWallFormosaThemeSelected(this.theme);

  @override
  List<Object> get props => [theme];
}

final class GreatWallPasswordVisibilityToggled extends GreatWallEvent {}

final class GreatWallDerivationStarted extends GreatWallEvent {}

final class GreatWallDerivationStepMade extends GreatWallEvent {
  final int choiceNumber;

  GreatWallDerivationStepMade(this.choiceNumber);

  @override
  List<Object> get props => [choiceNumber];
}

final class GreatWallDerivationFinished extends GreatWallEvent {}

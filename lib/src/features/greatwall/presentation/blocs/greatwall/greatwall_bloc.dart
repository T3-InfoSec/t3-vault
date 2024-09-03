import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:great_wall/great_wall.dart';

import 'bloc.dart';

class GreatWallBloc extends Bloc<GreatWallEvent, GreatWallState> {
  GreatWall? _greatWall;
  int _currentLevel = 1;
  dynamic nodes;

  GreatWallBloc() : super(GreatWallInitial()) {
    on<GreatWallFormosaThemeSelected>(_onGreatWallFormosaThemeSelected);
    on<GreatWallInitialized>(_onGreatWallInitialized);
    on<GreatWallReset>(_onGreatWallReset);
    on<GreatWallDerivationStarted>(_onGreatWallDerivationStarted);
    on<GreatWallDerivationStepMade>(_onDerivationStepMade);
    on<GreatWallDerivationFinished>(_onGreatWallDerivationFinished);
  }

  void _onDerivationStepMade(
      GreatWallDerivationStepMade event, Emitter<GreatWallState> emit) async {
    emit(GreatWallDeriveInProgress());

    await Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        _greatWall!.makeTacitDerivation(choiceNumber: event.choiceNumber);
      },
    );
    if (event.choiceNumber == 0 && _currentLevel > 1) {
      _currentLevel--;
    } else {
      _currentLevel++;
    }

    emit(
      GreatWallDeriveStepSuccess(
        currentLevel: _greatWall!.derivationLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        treeDepth: _greatWall!.treeDepth,
        savedDerivedStates: _greatWall!.savedDerivedStates,
      ),
    );
  }

  Future<void> _onGreatWallDerivationFinished(
      GreatWallDerivationFinished event, Emitter<GreatWallState> emit) async {
    await Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        _greatWall!.finishDerivation();
      },
    );

    emit(
      GreatWallFinishSuccess(
        derivationHashResult: _greatWall!.derivationHashResult!.toString(),
        savedDerivedStates: _greatWall!.savedDerivedStates,
      ),
    );
  }

  Future<void> _onGreatWallDerivationStarted(
      GreatWallDerivationStarted event, Emitter<GreatWallState> emit) async {
    emit(GreatWallDeriveInProgress());

    await Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        _greatWall!.startDerivation();
      },
    );

    emit(
      GreatWallDeriveStepSuccess(
        currentLevel: _currentLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        treeDepth: _greatWall!.treeDepth,
        savedDerivedStates: _greatWall!.savedDerivedStates,
      ),
    );
  }

  void _onGreatWallFormosaThemeSelected(
      GreatWallFormosaThemeSelected event, Emitter<GreatWallState> emit) {
    emit(GreatWallFormosaThemeSelectSuccess(event.theme));
  }

  void _onGreatWallInitialized(
      GreatWallInitialized event, Emitter<GreatWallState> emit) {
    _greatWall = GreatWall(
      treeArity: event.treeArity,
      treeDepth: event.treeDepth,
      timeLockPuzzleParam: event.timeLockPuzzleParam,
      tacitKnowledgeType: event.tacitKnowledgeType,
      tacitKnowledgeConfigs: event.tacitKnowledgeConfigs,
    );

    _greatWall!.seed0 = event.secretSeed;

    emit(
      GreatWallInitialSuccess(
        treeArity: event.treeArity,
        treeDepth: event.treeDepth,
        timeLockPuzzleParam: event.timeLockPuzzleParam,
        tacitKnowledgeType: event.tacitKnowledgeType,
        tacitKnowledgeConfigs: event.tacitKnowledgeConfigs,
        secretSeed: event.secretSeed,
      ),
    );
  }

  void _onGreatWallReset(GreatWallReset event, Emitter<GreatWallState> emit) {
    _greatWall = null;
    _currentLevel = 1;

    emit(GreatWallInitial());
  }
}

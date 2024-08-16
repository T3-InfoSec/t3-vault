import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:great_wall/great_wall.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/greatwall/greatwall_state.dart';

class GreatWallBloc extends Bloc<GreatWallEvent, GreatWallState> {
  GreatWall? _greatWall;
  int _currentLevel = 0;

  GreatWallBloc() : super(GreatWallInitial()) {
    on<GreatWallFormosaThemeSelected>(_onThemeSelected);
    on<InitializeGreatWall>(_onInitializeGreatWall);
    on<StartDerivation>(_onStartDerivation);
    on<LoadArityIndexes>(_onLoadArityIndexes);
    on<MakeTacitDerivation>(_onMakeTacitDerivation);
    on<AdvanceToNextLevel>(_onAdvanceToNextLevel);
    on<GoBackToPreviousLevel>(_onGoBackToPreviousLevel);
    on<FinishDerivation>(_onFinishDerivation);
    on<LoadResult>(_onLoadResult);
  }

  void _onThemeSelected(
      GreatWallFormosaThemeSelected event, Emitter<GreatWallState> emit) {
    emit(GreatWallFormosaThemeState(event.selectedOption));
  }

  void _onInitializeGreatWall(
      InitializeGreatWall event, Emitter<GreatWallState> emit) {
    _greatWall = GreatWall(
      treeArity: event.treeArity,
      treeDepth: event.treeDepth,
      timeLockPuzzleParam: event.timeLockPuzzleParam,
    );

    _greatWall!.seed0 = event.seed;

    emit(GreatWallInitialized(
      tacitKnowledge: 'Formosa',
      treeArity: event.treeArity,
      treeDepth: event.treeDepth,
      timeLockPuzzleParam: event.timeLockPuzzleParam,
      seed: event.seed,
    ));
  }

  Future<void> _onStartDerivation(StartDerivation event, Emitter<GreatWallState> emit) async {
    emit(GreatWallLoading());
    await Future.delayed(const Duration(seconds: 3)); // TODO: modify [startDerivation()] to return Future so we can await.

    if (_greatWall != null) {
      _greatWall!.startDerivation();
      emit(GreatWallDeriving(
        currentLevel: _greatWall!.derivationLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes
            .map((e) => e.toString())
            .toList(),
      ));
    }
  }

  void _onLoadArityIndexes(LoadArityIndexes event, Emitter<GreatWallState> emit) {
    if (_greatWall != null) {
      emit(GreatWallLoadedArityIndexes(
        currentLevel: _currentLevel,
        arityIndexes: _greatWall!.currentLevelKnowledgePalettes
            .map((e) => e.toString())
            .toList(),
        treeDepth: _greatWall!.treeDepth,
      ));
    }
  }

  void _onMakeTacitDerivation(
      MakeTacitDerivation event, Emitter<GreatWallState> emit) {
    if (_greatWall != null) {
      _greatWall!.makeTacitDerivation(choiceNumber: event.choiceNumber);

      emit(GreatWallDeriving(
        currentLevel: _greatWall!.derivationLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes
            .map((e) => e.toString())
            .toList(),
      ));
    }
  }

  void _onAdvanceToNextLevel(
      AdvanceToNextLevel event, Emitter<GreatWallState> emit) {
    if (_greatWall != null && _currentLevel < _greatWall!.treeDepth) {
      _currentLevel++;
      emit(GreatWallLoadedArityIndexes(
        currentLevel: _currentLevel,
        arityIndexes: _greatWall!.currentLevelKnowledgePalettes
            .map((e) => e.toString())
            .toList(),
        treeDepth: _greatWall!.treeDepth,
      ));
    }
  }

  void _onGoBackToPreviousLevel(
      GoBackToPreviousLevel event, Emitter<GreatWallState> emit) {
    if (_greatWall != null && _currentLevel > 1) {
      _currentLevel--;
      emit(GreatWallLoadedArityIndexes(
        currentLevel: _currentLevel,
        arityIndexes: _greatWall!.currentLevelKnowledgePalettes
            .map((e) => e.toString())
            .toList(),
        treeDepth: _greatWall!.treeDepth,
      ));
    }
  }

  void _onFinishDerivation(
      FinishDerivation event, Emitter<GreatWallState> emit) {
    if (_greatWall != null) {
      _greatWall!.finishDerivation();

      emit(GreatWallFinished(_greatWall!.derivationHashResult!.toString()));
    }
  }

  void _onLoadResult(LoadResult event, Emitter<GreatWallState> emit) {
    if (_greatWall != null) {
      if (_greatWall!.derivationHashResult != null) {
        emit(GreatWallFinished(_greatWall!.derivationHashResult!.toString()));
      }
    }
  }
}

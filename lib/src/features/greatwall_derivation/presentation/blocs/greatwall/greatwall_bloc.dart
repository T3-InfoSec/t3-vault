import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:great_wall/great_wall.dart';

import 'greatwall_event.dart';
import 'greatwall_state.dart';

class GreatWallBloc extends Bloc<GreatWallEvent, GreatWallState> {
  GreatWall? _greatWall;
  int _currentLevel = 1;

  GreatWallBloc() : super(GreatWallInitial()) {
    on<GreatWallFormosaThemeSelected>(_onThemeSelected);
    on<InitializeGreatWall>(_onInitializeGreatWall);
    on<StartDerivation>(_onStartDerivation);
    on<LoadArityIndexes>(_onLoadArityIndexes);
    on<MakeTacitDerivation>(_onMakeTacitDerivation);
    on<AdvanceToNextLevel>(_onAdvanceToNextLevel);
    on<GoBackToPreviousLevel>(_onGoBackToPreviousLevel);
    on<FinishDerivation>(_onFinishDerivation);
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

  Future<void> _onStartDerivation(
      StartDerivation event, Emitter<GreatWallState> emit) async {
    emit(GreatWallLoading());

    if (_greatWall != null) {
      _greatWall!.startDerivation();
      await Future.delayed(const Duration(seconds: 3));
      emit(
        GreatWallDeriving(
          currentLevel: _greatWall!.derivationLevel,
          knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        ),
      );
    }
  }

  void _onLoadArityIndexes(
      LoadArityIndexes event, Emitter<GreatWallState> emit) {
    if (_greatWall != null) {
      emit(
        GreatWallLoadedArityIndexes(
          currentLevel: _currentLevel,
          knowledgeValues: _greatWall!.currentLevelKnowledgePalettes,
          treeDepth: _greatWall!.treeDepth,
        ),
      );
    }
  }

  void _onMakeTacitDerivation(
      MakeTacitDerivation event, Emitter<GreatWallState> emit) {
    if (_greatWall != null) {
      _greatWall!.makeTacitDerivation(choiceNumber: event.choiceNumber);

      emit(
        GreatWallDeriving(
          currentLevel: _greatWall!.derivationLevel,
          knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        ),
      );
    }
  }

  void _onAdvanceToNextLevel(
      AdvanceToNextLevel event, Emitter<GreatWallState> emit) {
    if (_greatWall != null && _currentLevel < _greatWall!.treeDepth) {
      _currentLevel++;
      emit(
        GreatWallLoadedArityIndexes(
          currentLevel: _currentLevel,
          knowledgeValues: _greatWall!.currentLevelKnowledgePalettes,
          treeDepth: _greatWall!.treeDepth,
        ),
      );
    }
  }

  void _onGoBackToPreviousLevel(
      GoBackToPreviousLevel event, Emitter<GreatWallState> emit) {
    if (_greatWall != null && _currentLevel > 1) {
      _currentLevel--;
      emit(
        GreatWallLoadedArityIndexes(
          currentLevel: _currentLevel,
          knowledgeValues: _greatWall!.currentLevelKnowledgePalettes,
          treeDepth: _greatWall!.treeDepth,
        ),
      );
    }
  }

  Future<void> _onFinishDerivation(
      FinishDerivation event, Emitter<GreatWallState> emit) async {
    if (_greatWall != null) {
      _greatWall!.finishDerivation();
      await Future.delayed(const Duration(seconds: 3));

      emit(GreatWallFinished(_greatWall!.derivationHashResult!.toString()));
    }
  }
}

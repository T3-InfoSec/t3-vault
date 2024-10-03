import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:great_wall/great_wall.dart';

import 'bloc.dart';

class GreatWallBloc extends Bloc<GreatWallEvent, GreatWallState> {
  GreatWall? _greatWall;
  int _currentLevel = 1;

  GreatWallBloc() : super(GreatWallInitial()) {
    on<GreatWallInitialized>(_onGreatWallInitialized);
    on<GreatWallReset>(_onGreatWallReset);
    on<GreatWallDerivationStarted>(_onGreatWallDerivationStarted);
    on<GreatWallDerivationStepMade>(_onDerivationStepMade);
    on<GreatWallDerivationFinished>(_onGreatWallDerivationFinished);
  }

  void _onDerivationStepMade(
      GreatWallDerivationStepMade event, Emitter<GreatWallState> emit) async {
    emit(GreatWallDeriveInProgress(progress: 0));
    await Future.delayed(const Duration(milliseconds: 25));

    await Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        _greatWall!.makeTacitDerivation(choiceNumber: event.choiceNumber);
      },
    );
    emit(GreatWallDeriveInProgress(progress: 100));
    await Future.delayed(const Duration(milliseconds: 10));
    if (event.choiceNumber == 0 && _currentLevel > 1) {
      _currentLevel--;
    } else {
      _currentLevel++;
    }

    emit(
      GreatWallDeriveStepSuccess(
        treeDepth: _greatWall!.treeDepth,
        currentLevel: _greatWall!.derivationLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        tacitKnowledge: _greatWall!.derivationTacitKnowledge,
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
        _greatWall!.derivationHashResult!.toString(),
      ),
    );
  }

  Future<void> _onGreatWallDerivationStarted(
      GreatWallDerivationStarted event, Emitter<GreatWallState> emit) async {
    emit(GreatWallDeriveInProgress(progress: 0));
    await Future.delayed(const Duration(milliseconds: 25));

    await _greatWall!.startDerivation(
      onProgress: (int progress) {
        emit(GreatWallDeriveInProgress(progress: progress));
      },
    );
    await Future.delayed(const Duration(milliseconds: 10));

    emit(
      GreatWallDeriveStepSuccess(
        treeDepth: _greatWall!.treeDepth,
        currentLevel: _currentLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        tacitKnowledge: _greatWall!.derivationTacitKnowledge,
      ),
    );
  }

  void _onGreatWallInitialized(
      GreatWallInitialized event, Emitter<GreatWallState> emit) {
    _greatWall = GreatWall(
      treeArity: event.treeArity,
      treeDepth: event.treeDepth,
      timeLockPuzzleParam: event.timeLockPuzzleParam,
      tacitKnowledge: event.tacitKnowledge,
    );

    _greatWall!.seed0 = event.secretSeed;

    emit(
      GreatWallInitialSuccess(
        treeArity: event.treeArity,
        treeDepth: event.treeDepth,
        timeLockPuzzleParam: event.timeLockPuzzleParam,
        tacitKnowledge: event.tacitKnowledge,
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

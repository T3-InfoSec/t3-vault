import 'dart:math';

import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_vault/src/features/greatwall/domain/usecases/tree_input_validator.dart';
import 'package:t3_vault/src/features/greatwall/utils/eka.dart';

import 'bloc.dart';

class GreatWallBloc extends Bloc<GreatWallEvent, GreatWallState> {
  GreatWall? _greatWall;
  int _currentLevel = 1;
  final ekaUtil = Eka();

  GreatWallBloc() : super(GreatWallInitial()) {
    on<GreatWallSymmetricToggled>(_onGreatWallSymmetricToggled);
    on<GreatWallPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<GreatWallArityChanged>(_onGreatWallArityChanged);
    on<GreatWallDepthChanged>(_onGreatWallDepthChanged);
    on<GreatWallTimeLockChanged>(_onGreatWallTimeLockChanged);
    on<GreatWallInitialized>(_onGreatWallInitialized);
    on<GreatWallReset>(_onGreatWallReset);
    on<GreatWallDerivationStarted>(_onGreatWallDerivationStarted);
    on<GreatWallDerivationStepMade>(_onDerivationStepMade);
    on<GreatWallDerivationFinished>(_onGreatWallDerivationFinished);
    on<GreatWallKAVisibilityToggled>(_onKAVisibilityToggled);
  }

  void _onDerivationStepMade(GreatWallDerivationStepMade event, Emitter<GreatWallState> emit) async {
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
        treeDepth: _greatWall!.treeDepth,
        currentLevel: _greatWall!.derivationLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        tacitKnowledge: _greatWall!.derivationTacitKnowledge,
      ),
    );
  }

  Future<void> _onGreatWallDerivationFinished(GreatWallDerivationFinished event, Emitter<GreatWallState> emit) async {
    await Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        _greatWall!.finishDerivation();
      },
    );

    emit(
      GreatWallFinishSuccess(hex.encode(_greatWall!.derivationHashResult!), false),
    );
  }

  Future<void> _onGreatWallDerivationStarted(GreatWallDerivationStarted event, Emitter<GreatWallState> emit) async {
    emit(GreatWallDeriveInProgress());

    await Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        _greatWall!.startDerivation();
      },
    );

    emit(
      GreatWallDeriveStepSuccess(
        treeDepth: _greatWall!.treeDepth,
        currentLevel: _currentLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        tacitKnowledge: _greatWall!.derivationTacitKnowledge,
      ),
    );
  }

  void _onPasswordVisibilityToggled(GreatWallPasswordVisibilityToggled event, Emitter<GreatWallState> emit) {
    if (state is GreatWallInputsInProgress) {
      final currentState = state as GreatWallInputsInProgress;
      emit(GreatWallInputsInProgress(currentState.isSymmetric, !currentState.isPasswordVisible));
    } else {
      emit(GreatWallInputsInProgress(true, false));
    }
  }

  void _onGreatWallSymmetricToggled(GreatWallSymmetricToggled event, Emitter<GreatWallState> emit) {
    if (state is GreatWallInputsInProgress) {
      final currentState = state as GreatWallInputsInProgress;
      emit(GreatWallInputsInProgress(!currentState.isSymmetric, currentState.isPasswordVisible));
    } else {
      emit(GreatWallInputsInProgress(true, false));
    }
  }

  void _onGreatWallArityChanged(GreatWallArityChanged event, Emitter<GreatWallState> emit) {
    final errors = <String, String>{};

    final arityError = TreeInputValidator.validateArity(event.arity);
    if (arityError != null) {
      errors['treeArity'] = arityError;
    }

    if (errors.isNotEmpty) {
      emit(GreatWallInputInvalid(errors));
    } else {
      emit(GreatWallInputValid());
    }
  }

  void _onGreatWallDepthChanged(GreatWallDepthChanged event, Emitter<GreatWallState> emit) {
    final errors = <String, String>{};

    final depthError = TreeInputValidator.validateDepth(event.depth);
    if (depthError != null) {
      errors['treeDepth'] = depthError;
    }

    if (errors.isNotEmpty) {
      emit(GreatWallInputInvalid(errors));
    } else {
      emit(GreatWallInputValid());
    }
  }

  void _onGreatWallTimeLockChanged(GreatWallTimeLockChanged event, Emitter<GreatWallState> emit) {
    final errors = <String, String>{};

    final timeLockError = TreeInputValidator.validateTimeLock(event.timeLock);
    if (timeLockError != null) {
      errors['treeTimeLock'] = timeLockError;
    }

    if (errors.isNotEmpty) {
      emit(GreatWallInputInvalid(errors));
    } else {
      emit(GreatWallInputValid());
    }
  }

  void _onGreatWallInitialized(GreatWallInitialized event, Emitter<GreatWallState> emit) {
    // generate eka on initialization
    final eka = ekaUtil.generate();
    if (kDebugMode) {
      print('eka: $eka and UX ${ekaUtil.toUxChunks(eka)}');
    }
    
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

  void _onKAVisibilityToggled(GreatWallKAVisibilityToggled event, Emitter<GreatWallState> emit) {
    if (state is GreatWallFinishSuccess) {
      final currentState = state as GreatWallFinishSuccess;
      emit(GreatWallFinishSuccess(currentState.derivationHashResult, !currentState.isKAVisible));
    }
  }

  void _onGreatWallReset(GreatWallReset event, Emitter<GreatWallState> emit) {
    _greatWall = null;
    _currentLevel = 1;

    emit(GreatWallInitial());
  }
}

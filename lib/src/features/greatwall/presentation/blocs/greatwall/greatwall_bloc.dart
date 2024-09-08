import 'package:convert/convert.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_vault/src/features/greatwall/domain/usecases/tree_input_validator.dart';

import 'bloc.dart';

class GreatWallBloc extends Bloc<GreatWallEvent, GreatWallState> {
  GreatWall? _greatWall;
  int _currentLevel = 1;

  GreatWallBloc() : super(GreatWallInitial()) {
    on<GreatWallFormosaThemeSelected>(_onGreatWallFormosaThemeSelected);
    on<GreatWallPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<GreatWallArityChanged>(_onGreatWallArityChanged);
    on<GreatWallDepthChanged>(_onGreatWallDepthChanged);
    on<GreatWallTimeLockChanged>(_onGreatWallTimeLockChanged);
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
      GreatWallFinishSuccess(hex.encode(_greatWall!.derivationHashResult!)),
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
      ),
    );
  }

  void _onGreatWallFormosaThemeSelected(
      GreatWallFormosaThemeSelected event, Emitter<GreatWallState> emit) {
    emit(GreatWallFormosaThemeSelectSuccess(event.theme));
  }

  void _onPasswordVisibilityToggled(
      GreatWallPasswordVisibilityToggled event, Emitter<GreatWallState> emit) {
    if (state is GreatWallPasswordVisibility) {
      final currentState = state as GreatWallPasswordVisibility;
      emit(GreatWallPasswordVisibility(!currentState.isPasswordVisible));
    } else {
      emit(GreatWallPasswordVisibility(true));
    }
  }

  void _onGreatWallArityChanged(
      GreatWallArityChanged event, Emitter<GreatWallState> emit) {
    final errors = <String, String>{};

    final arityError = TreeInputValidator.validateArity(event.arity);
    if (arityError != null) {
      errors['treeArity'] = arityError;
    }

    if (errors.isNotEmpty) {
      emit(GreatWallInputInvalid(errors));
    }
  }

    void _onGreatWallDepthChanged(
      GreatWallDepthChanged event, Emitter<GreatWallState> emit) {
    final errors = <String, String>{};

    final depthError = TreeInputValidator.validateArity(event.depth);
    if (depthError != null) {
      errors['treeDepth'] = depthError;
    }

    if (errors.isNotEmpty) {
      emit(GreatWallInputInvalid(errors));
    }
  }

      void _onGreatWallTimeLockChanged(
      GreatWallTimeLockChanged event, Emitter<GreatWallState> emit) {
    final errors = <String, String>{};

    final timeLockError = TreeInputValidator.validateArity(event.timeLock);
    if (timeLockError != null) {
      errors['treeTimeLock'] = timeLockError;
    }

    if (errors.isNotEmpty) {
      emit(GreatWallInputInvalid(errors));
    }
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

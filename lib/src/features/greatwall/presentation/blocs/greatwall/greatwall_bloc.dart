import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:great_wall/great_wall.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';
import 'package:t3_vault/src/features/greatwall/domain/usecases/tree_input_validator.dart';

import 'bloc.dart';

class GreatWallBloc extends Bloc<GreatWallEvent, GreatWallState> {
  GreatWall? _greatWall;
  int _currentLevel = 1;

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
    on<GreatWallPracticeLevel>(_onGreatWallPracticeLevel);
    on<GreatWallPracticeStepMade>(_onGreatWallPracticeStepMade);
  }

  void _onDerivationStepMade(
      GreatWallDerivationStepMade event, Emitter<GreatWallState> emit) async {
    emit(GreatWallDeriveInProgress());

    await Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        _greatWall!.makeTacitDerivation(choice: event.choice);
      },
    );
    if (event.choice == "0" && _currentLevel > 1) {
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
          derivationHashResult: _greatWall!.derivationHashResult!,
          savedNodes: _greatWall!.savedDerivedStates.values.toList(),
          treeArity: _greatWall!.treeArity,
          treeDepth: _greatWall!.treeDepth,
          isKAVisible:  false),
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
        treeDepth: _greatWall!.treeDepth,
        currentLevel: _currentLevel,
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        tacitKnowledge: _greatWall!.derivationTacitKnowledge,
      ),
    );
  }

  void _onPasswordVisibilityToggled(
      GreatWallPasswordVisibilityToggled event, Emitter<GreatWallState> emit) {
    if (state is GreatWallInputsInProgress) {
      final currentState = state as GreatWallInputsInProgress;
      emit(GreatWallInputsInProgress(currentState.isSymmetric, !currentState.isPasswordVisible));
    } else {
      emit(GreatWallInputsInProgress(true, false));
    }
  }

  void _onGreatWallSymmetricToggled(
      GreatWallSymmetricToggled event, Emitter<GreatWallState> emit) {
    if (state is GreatWallInputsInProgress) {
      final currentState = state as GreatWallInputsInProgress;
      emit(GreatWallInputsInProgress(!currentState.isSymmetric, currentState.isPasswordVisible));
    } else {
      emit(GreatWallInputsInProgress(true, false));
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
    } else {
      emit(GreatWallInputValid());
    }
  }

  void _onGreatWallDepthChanged(
      GreatWallDepthChanged event, Emitter<GreatWallState> emit) {
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

  void _onGreatWallTimeLockChanged(
      GreatWallTimeLockChanged event, Emitter<GreatWallState> emit) {
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

  void _onGreatWallInitialized(
      GreatWallInitialized event, Emitter<GreatWallState> emit) {
    _greatWall = GreatWall(
      treeArity: event.treeArity,
      treeDepth: event.treeDepth,
      timeLockPuzzleParam: event.timeLockPuzzleParam,
      tacitKnowledge: event.tacitKnowledge,
    );

    _greatWall!.sa0 = Sa0(Formosa.fromMnemonic(event.sa0Mnemonic));
    
    emit(
      GreatWallInitialSuccess(
        treeArity: event.treeArity,
        treeDepth: event.treeDepth,
        timeLockPuzzleParam: event.timeLockPuzzleParam,
        tacitKnowledge: event.tacitKnowledge,
        sa0Mnemonic: event.sa0Mnemonic,
      ),
    );
  }

  void _onKAVisibilityToggled(
      GreatWallKAVisibilityToggled event, Emitter<GreatWallState> emit) {
    if (state is GreatWallFinishSuccess) {
      final currentState = state as GreatWallFinishSuccess;
      emit(GreatWallFinishSuccess(
          derivationHashResult: currentState.derivationHashResult, 
          savedNodes: currentState.savedNodes,
          treeArity: _greatWall!.treeArity,
          treeDepth: _greatWall!.treeDepth,
          isKAVisible: !currentState.isKAVisible
      ));
    }
  }

  void _onGreatWallReset(GreatWallReset event, Emitter<GreatWallState> emit) {
    _greatWall!.initialDerivation();

    emit(GreatWallInitial());
  }

  void _onGreatWallPracticeLevel(GreatWallPracticeLevel event, Emitter<GreatWallState> emit) {
    _greatWall!.generateLevelKnowledgePalettes(event.node);

    emit(
      GreatWallPracticeLevelStarted(
        knowledgePalettes: _greatWall!.currentLevelKnowledgePalettes,
        greatWall: _greatWall!,
      ));
  }

  void _onGreatWallPracticeStepMade(
      GreatWallPracticeStepMade event, Emitter<GreatWallState> emit) {
    var selectedNode = _greatWall!.getSelectedNode(event.currentHash, event.choiceNumber.toString());

    emit(
      GreatWallPracticeLevelFinish(
        selectedNode: selectedNode,
      ),
    );
  }
}

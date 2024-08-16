import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/tree_inputs/tree_inputs_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/tree_inputs/tree_inputs_state.dart';

class TreeInputsBloc extends Bloc<TreeInputsEvent, TreeInputsState> {
  TreeInputsBloc() : super(TreeInputsInitial()) {
    on<ThemeChanged>(_onThemeChanged);
    on<TlpChanged>(_onTlpChanged);
    on<DepthChanged>(_onDepthChanged);
    on<ArityChanged>(_onArityChanged);
    on<PasswordChanged>(_onPasswordChanged);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<TreeInputsState> emit) {
    emit(TreeInputsUpdated(
      selectedTheme: event.selectedTheme,
      tlp: state.tlp,
      depth: state.depth,
      arity: state.arity,
      password: state.password,
    ));
  }

  void _onTlpChanged(TlpChanged event, Emitter<TreeInputsState> emit) {
    emit(TreeInputsUpdated(
      selectedTheme: state.selectedTheme,
      tlp: event.tlp,
      depth: state.depth,
      arity: state.arity,
      password: state.password,
    ));
  }

  void _onDepthChanged(DepthChanged event, Emitter<TreeInputsState> emit) {
    emit(TreeInputsUpdated(
      selectedTheme: state.selectedTheme,
      tlp: state.tlp,
      depth: event.depth,
      arity: state.arity,
      password: state.password,
    ));
  }

  void _onArityChanged(ArityChanged event, Emitter<TreeInputsState> emit) {
    emit(TreeInputsUpdated(
      selectedTheme: state.selectedTheme,
      tlp: state.tlp,
      depth: state.depth,
      arity: event.arity,
      password: state.password,
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<TreeInputsState> emit) {
    emit(TreeInputsUpdated(
      selectedTheme: state.selectedTheme,
      tlp: state.tlp,
      depth: state.depth,
      arity: state.arity,
      password: event.password,
    ));
  }
}

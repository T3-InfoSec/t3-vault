import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/derivation_level/derivation_level_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/derivation_level/derivation_level_state.dart';

class DerivationLevelBloc
    extends Bloc<DerivationLevelEvent, DerivationLevelState> {
  DerivationLevelBloc() : super(DerivationLevelInitial()) {
    on<LoadArityIndexes>(_onLoadArityIndexes);
    on<SelectArityIndex>(_onSelectArityIndex);
  }

  void _onLoadArityIndexes(
    LoadArityIndexes event,
    Emitter<DerivationLevelState> emit,
  ) {
    final List<String> arityIndexes = [
      "moment weapon pact",
      "bone exact certain",
      "affair muffin display",
      "net cancel snack"
    ];
    emit(DerivationLevelLoaded(arityIndexes: arityIndexes));
  }

  void _onSelectArityIndex(
    SelectArityIndex event,
    Emitter<DerivationLevelState> emit,
  ) {
    emit(DerivationLevelLoaded(
      arityIndexes: state.arityIndexes,
      selectedIndex: event.selectedIndex,
    ));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/derivation_result/derivation_result_event.dart';
import 'package:t3_vault/src/features/greatwall_derivation/presentation/bloc/derivation_result/derivation_result_state.dart';

class DerivationResultBloc
    extends Bloc<DerivationResultEvent, DerivationResultState> {
  DerivationResultBloc() : super(const DerivationResultInitial()) {
    on<LoadResult>(_onLoadResult);
    on<ResetResult>(_onResetResult);
  }

  void _onLoadResult(LoadResult event, Emitter<DerivationResultState> emit) {
    const String kaResult =
        "3bd62811a6386e35ab18ea341c9b9766dc7b7ee3b84049e6f71ca33f6e552b0cb652a42846b44131018394727ee49beb239f79570369bdda4b8092640b1976ed9fdd3be0878c01f91f2ee28667f5d510dc7fe19136257441eed5e40eafcca552bc05373f1fa05c4b73f3286dc9d1733fc49b45df1dbc9a5216cfdd0848b7177b";

    emit(const DerivationResultLoaded(kaResult: kaResult));
  }

  void _onResetResult(ResetResult event, Emitter<DerivationResultState> emit) {
    emit(const DerivationResultInitial());
  }
}

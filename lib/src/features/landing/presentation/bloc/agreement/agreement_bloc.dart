import 'package:bloc/bloc.dart';

import 'bloc.dart';

class AgreementBloc extends Bloc<AgreementEvent, AgreementState> {
  AgreementBloc() : super(AgreementStateReject()) {
    on<AgreementSuspended>(_onAgreementEvent);
    on<AgreementAccepted>(_onAgreementEvent);
    on<AgreementRejected>(_onAgreementEvent);
  }

  Future<void> _onAgreementEvent(
    AgreementEvent event,
    Emitter<AgreementState> emit,
  ) async {
    if (event is AgreementSuspended) {
      return emit(AgreementStateSuspend());
    }

    if (event is AgreementAccepted) {
      return emit(AgreementStateAccept());
    }

    if (event is AgreementRejected) {
      return emit(AgreementStateReject());
    }
  }
}

import 'package:bloc/bloc.dart';

import 'bloc.dart';

class InitializingServicesBloc
    extends Bloc<InitializingServicesEvent, InitializingServicesState> {
  InitializingServicesBloc() : super(InitializingServicesStateFail()) {
    on<InitializingServicesFailed>(_onInitializingServicesEvent);
    on<InitializingServicesSucceeded>(_onInitializingServicesEvent);
  }

  Future<void> _onInitializingServicesEvent(
    InitializingServicesEvent event,
    Emitter<InitializingServicesState> emit,
  ) async {
    if (event is InitializingServicesFailed) {
      return emit(InitializingServicesStateFail());
    }

    if (event is InitializingServicesSucceeded) {
      return emit(InitializingServicesStateSuccess());
    }
  }
}

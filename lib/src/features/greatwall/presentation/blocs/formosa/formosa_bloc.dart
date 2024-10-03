import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class FormosaBloc extends Bloc<FormosaEvent, FormosaState> {
  FormosaBloc() : super(FormosaInitial()) {
    on<FormosaInitialized>(_onFormosaInitialized);
    on<FormosaThemeSelected>(_onFormosaThemeSelected);
  }

  void _onFormosaThemeSelected(
      FormosaThemeSelected event, Emitter<FormosaState> emit) {
    emit(FormosaThemeSelectSuccess(theme: event.theme));
  }

  void _onFormosaInitialized(
      FormosaInitialized event, Emitter<FormosaState> emit) {
    emit(FormosaInitial());
  }
}

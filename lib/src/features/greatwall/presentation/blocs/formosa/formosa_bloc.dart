import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

import 'bloc.dart';

class FormosaBloc extends Bloc<FormosaEvent, FormosaState> {
  FormosaBloc() : super(FormosaInitial()) {
    on<FormosaInitialized>(_onFormosaInitialized);
    on<FormosaThemeSelected>(_onFormosaThemeSelected);
    on<FormosaMnemonicChanged>(_onFormosaMnemonicChanged);
  }

  void _onFormosaThemeSelected(
      FormosaThemeSelected event, Emitter<FormosaState> emit) {
    emit(FormosaThemeSelectSuccess(theme: event.theme));
  }

  void _onFormosaInitialized(
      FormosaInitialized event, Emitter<FormosaState> emit) {
    emit(FormosaInitial());
  }

  void _onFormosaMnemonicChanged(
      FormosaMnemonicChanged event, Emitter<FormosaState> emit) {
    try {
      final candidate = UnsafeFormosaCandidate.fromMnemonic(
        event.mnemonic,
        formosaTheme: FormosaTheme.bip39,
      );
      emit(FormosaMnemonicValidation(isValid: candidate.isValidFormosa()));
    } catch (_) {
      emit(FormosaMnemonicValidation(isValid: false));
    }
  }
}

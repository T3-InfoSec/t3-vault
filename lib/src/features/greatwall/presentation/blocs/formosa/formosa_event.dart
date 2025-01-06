import 'package:equatable/equatable.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

sealed class FormosaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class FormosaInitialized extends FormosaEvent {}

final class FormosaThemeSelected extends FormosaEvent {
  final FormosaTheme theme;

  FormosaThemeSelected({required this.theme});

  @override
  List<Object> get props => [theme];
}

final class FormosaMnemonicChanged extends FormosaEvent {
  final String mnemonic;

  FormosaMnemonicChanged({required this.mnemonic});

  @override
  List<Object> get props => [mnemonic];
}

import 'package:equatable/equatable.dart';
import 'package:t3_crypto_objects/crypto_objects.dart';

sealed class FormosaState extends Equatable {
  @override
  List<Object> get props => [];
}

final class FormosaInitial extends FormosaState {}

final class FormosaThemeSelectSuccess extends FormosaState {
  final FormosaTheme theme;

  FormosaThemeSelectSuccess({required this.theme});

  @override
  List<Object> get props => [theme];
}

final class FormosaMnemonicValidation extends FormosaState {
  final bool isValid;

  FormosaMnemonicValidation({required this.isValid});

  @override
  List<Object> get props => [isValid];
}

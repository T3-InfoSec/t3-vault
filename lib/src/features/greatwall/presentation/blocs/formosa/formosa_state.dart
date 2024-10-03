import 'package:equatable/equatable.dart';
import 'package:t3_formosa/formosa.dart';

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

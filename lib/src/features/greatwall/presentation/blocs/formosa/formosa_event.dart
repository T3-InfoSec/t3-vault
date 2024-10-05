import 'package:equatable/equatable.dart';
import 'package:t3_formosa/formosa.dart';

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

import 'package:equatable/equatable.dart';

sealed class TreeInputsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ThemeChanged extends TreeInputsEvent {
  final String? selectedTheme;

  ThemeChanged(this.selectedTheme);

  @override
  List<Object?> get props => [selectedTheme];
}

final class TlpChanged extends TreeInputsEvent {
  final String tlp;

  TlpChanged(this.tlp);

  @override
  List<Object?> get props => [tlp];
}

final class DepthChanged extends TreeInputsEvent {
  final String depth;

  DepthChanged(this.depth);

  @override
  List<Object?> get props => [depth];
}

final class ArityChanged extends TreeInputsEvent {
  final String arity;

  ArityChanged(this.arity);

  @override
  List<Object?> get props => [arity];
}

final class PasswordChanged extends TreeInputsEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

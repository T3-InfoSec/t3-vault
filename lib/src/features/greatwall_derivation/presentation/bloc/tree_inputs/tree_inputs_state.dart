import 'package:equatable/equatable.dart';

sealed class TreeInputsState extends Equatable {
  final String? selectedTheme;
  final String tlp;
  final String depth;
  final String arity;
  final String password;

  const TreeInputsState({
    this.selectedTheme,
    this.tlp = '',
    this.depth = '',
    this.arity = '',
    this.password = '',
  });

  @override
  List<Object?> get props => [selectedTheme, tlp, depth, arity, password];
}

final class TreeInputsInitial extends TreeInputsState {}

final class TreeInputsUpdated extends TreeInputsState {
  const TreeInputsUpdated({
    super.selectedTheme,
    required super.tlp,
    required super.depth,
    required super.arity,
    required super.password,
  });
}

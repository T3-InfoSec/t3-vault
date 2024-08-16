import 'package:equatable/equatable.dart';

sealed class DerivationLevelEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LoadArityIndexes extends DerivationLevelEvent {}

final class SelectArityIndex extends DerivationLevelEvent {
  final String selectedIndex;

  SelectArityIndex(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

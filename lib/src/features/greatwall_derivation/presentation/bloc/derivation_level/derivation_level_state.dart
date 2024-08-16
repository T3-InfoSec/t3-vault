import 'package:equatable/equatable.dart';

sealed class DerivationLevelState extends Equatable {
  final List<String> arityIndexes;
  final String? selectedIndex;

  const DerivationLevelState({
    this.arityIndexes = const [],
    this.selectedIndex,
  });

  @override
  List<Object?> get props => [arityIndexes, selectedIndex];
}

final class DerivationLevelInitial extends DerivationLevelState {}

final class DerivationLevelLoaded extends DerivationLevelState {
  const DerivationLevelLoaded({
    required super.arityIndexes,
    super.selectedIndex,
  });
}

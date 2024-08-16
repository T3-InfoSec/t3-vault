import 'package:equatable/equatable.dart';

sealed class DerivationResultEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class LoadResult extends DerivationResultEvent {}

final class ResetResult extends DerivationResultEvent {}

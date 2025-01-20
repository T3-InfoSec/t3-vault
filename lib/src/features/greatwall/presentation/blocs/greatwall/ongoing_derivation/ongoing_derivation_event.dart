import 'package:equatable/equatable.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/ongoing_derivation_entity.dart';

sealed class OngoingDerivationEvent extends Equatable {
  const OngoingDerivationEvent();

  @override
  List<Object?> get props => [];
}

final class OngoingDerivationLoadRequested extends OngoingDerivationEvent {}

final class OngoingDerivationAdded extends OngoingDerivationEvent {
  final OngoingDerivationEntity ongoingDerivationEntity;

  const OngoingDerivationAdded({required this.ongoingDerivationEntity});

  @override
  List<Object?> get props => [ongoingDerivationEntity];
}

final class OngoingDerivationRemoved extends OngoingDerivationEvent {
  final OngoingDerivationEntity ongoingDerivationEntity;

  const OngoingDerivationRemoved({required this.ongoingDerivationEntity});

  @override
  List<Object?> get props => [ongoingDerivationEntity];
}

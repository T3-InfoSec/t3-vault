import 'package:equatable/equatable.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/entities/ongoing_derivation_entity.dart';

sealed class OngoingDerivationState extends Equatable {
  final OngoingDerivationEntity? ongoingDerivationEntity;

  const OngoingDerivationState({required this.ongoingDerivationEntity});

  @override
  List<Object?> get props => [ongoingDerivationEntity];
}

final class OngoingDerivationEmpty extends OngoingDerivationState {
  const OngoingDerivationEmpty() : super(ongoingDerivationEntity: null);
}

final class OngoingDerivationAddSuccess extends OngoingDerivationState {
  const OngoingDerivationAddSuccess({required super.ongoingDerivationEntity});
}

final class OngoingDerivationRemoveSuccess extends OngoingDerivationState {
  const OngoingDerivationRemoveSuccess({required super.ongoingDerivationEntity});
}

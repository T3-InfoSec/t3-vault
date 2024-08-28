import 'package:equatable/equatable.dart';

sealed class AgreementState extends Equatable {
  const AgreementState();

  @override
  List<Object?> get props => [];
}

final class AgreementStateSuspend extends AgreementState {}

final class AgreementStateAccept extends AgreementState {}

final class AgreementStateReject extends AgreementState {}

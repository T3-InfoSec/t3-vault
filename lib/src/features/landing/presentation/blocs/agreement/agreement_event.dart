import 'package:equatable/equatable.dart';

sealed class AgreementEvent extends Equatable {
  const AgreementEvent();

  @override
  List<Object?> get props => [];
}

final class AgreementSuspended extends AgreementEvent {}

final class AgreementAccepted extends AgreementEvent {}

final class AgreementRejected extends AgreementEvent {}

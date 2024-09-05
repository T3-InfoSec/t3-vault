import 'package:equatable/equatable.dart';

sealed class InitializingServicesEvent extends Equatable {
  const InitializingServicesEvent();

  @override
  List<Object?> get props => [];
}

final class InitializingServicesFailed extends InitializingServicesEvent {}

final class InitializingServicesSucceeded extends InitializingServicesEvent {}

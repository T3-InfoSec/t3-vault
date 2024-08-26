import 'package:equatable/equatable.dart';

sealed class InitializingServicesState extends Equatable {
  const InitializingServicesState();

  @override
  List<Object?> get props => [];
}

final class InitializingServicesStateFail extends InitializingServicesState {}

final class InitializingServicesStateSuccess
    extends InitializingServicesState {}

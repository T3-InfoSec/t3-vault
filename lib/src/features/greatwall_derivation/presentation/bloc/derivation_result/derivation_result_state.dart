import 'package:equatable/equatable.dart';

sealed class DerivationResultState extends Equatable {
  final String kaResult;

  const DerivationResultState({required this.kaResult});

  @override
  List<Object?> get props => [kaResult];
}

final class DerivationResultInitial extends DerivationResultState {
  const DerivationResultInitial() : super(kaResult: "");
}

final class DerivationResultLoaded extends DerivationResultState {
  const DerivationResultLoaded({required super.kaResult});
}

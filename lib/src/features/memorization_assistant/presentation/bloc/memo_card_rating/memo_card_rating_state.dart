import 'package:equatable/equatable.dart';

sealed class MemoCardRatingState extends Equatable {
  const MemoCardRatingState();

  @override
  List<Object?> get props => [];
}

final class MemoCardRatingStateAgain extends MemoCardRatingState {}

final class MemoCardRatingStateHard extends MemoCardRatingState {}

final class MemoCardRatingStateGood extends MemoCardRatingState {}

final class MemoCardRatingStateEasy extends MemoCardRatingState {}

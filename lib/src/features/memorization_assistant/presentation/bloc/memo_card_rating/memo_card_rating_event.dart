import 'package:equatable/equatable.dart';

sealed class MemoCardRatingEvent extends Equatable {
  const MemoCardRatingEvent();

  @override
  List<Object?> get props => [];
}

final class MemoCardRatedAgain extends MemoCardRatingEvent {}

final class MemoCardRatedHard extends MemoCardRatingEvent {}

final class MemoCardRatedGood extends MemoCardRatingEvent {}

final class MemoCardRatedEasy extends MemoCardRatingEvent {}

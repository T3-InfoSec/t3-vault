import 'package:equatable/equatable.dart';

sealed class MemoCardRatingEvent extends Equatable {
  const MemoCardRatingEvent();
}

final class MemoCardRatingPressed extends MemoCardRatingEvent {
  final String rating;

  const MemoCardRatingPressed({required this.rating});

  @override
  List<Object?> get props => [rating];
}

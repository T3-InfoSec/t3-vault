import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';

sealed class MemoCardRatingEvent extends Equatable {
  const MemoCardRatingEvent();
}

final class MemoCardRatingPressed extends MemoCardRatingEvent {
  final String rating;
  final MemoCard memoCard;

  const MemoCardRatingPressed({required this.rating, required this.memoCard});

  @override
  List<Object?> get props => [rating, memoCard];
}

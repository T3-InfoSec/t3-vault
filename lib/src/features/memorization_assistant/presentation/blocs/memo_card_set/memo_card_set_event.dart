import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';

sealed class MemoCardSetEvent extends Equatable {
  const MemoCardSetEvent();

  @override
  List<Object?> get props => [];
}

final class MemoCardSetLoadRequested extends MemoCardSetEvent {}

final class MemoCardSetUnchanged extends MemoCardSetEvent {}

final class MemoCardSetCardsAdding extends MemoCardSetEvent {}

final class MemoCardSetCardsAdded extends MemoCardSetEvent {
  final List<MemoCard> memoCards;

  const MemoCardSetCardsAdded({required this.memoCards});

  @override
  List<Object?> get props => [memoCards];
}

final class MemoCardSetCardRemoved extends MemoCardSetEvent {
  final MemoCard memoCard;

  const MemoCardSetCardRemoved({required this.memoCard});

  @override
  List<Object?> get props => [memoCard];
}

import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';

sealed class MemoCardSetEvent extends Equatable {
  const MemoCardSetEvent();

  @override
  List<Object?> get props => [];
}

final class MemoCardSetLoadRequested extends MemoCardSetEvent {}

final class MemoCardSetUnchanged extends MemoCardSetEvent {}

final class MemoCardSetCardAdded extends MemoCardSetEvent {
  final MemoCard memoCard;

  const MemoCardSetCardAdded({required this.memoCard});

  @override
  List<Object?> get props => [memoCard];
}

final class MemoCardSetCardRemoved extends MemoCardSetEvent {
  final MemoCard memoCard;

  const MemoCardSetCardRemoved({required this.memoCard});

  @override
  List<Object?> get props => [memoCard];
}

class MemoCardSetCardUpdated extends MemoCardSetEvent {
  final MemoCard updatedMemoCard;

  const MemoCardSetCardUpdated({required this.updatedMemoCard});
}

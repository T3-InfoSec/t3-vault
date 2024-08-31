import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';

sealed class MemoCardSetState extends Equatable {
  final List<MemoCard> memoCardSet = <MemoCard>[];

  MemoCardSetState();

  @override
  List<Object?> get props => [memoCardSet];
}

final class MemoCardSetEmpty extends MemoCardSetState {}

final class MemoCardSetChangeNothing extends MemoCardSetState {
  MemoCardSetChangeNothing({required memoCards}) {
    memoCardSet.addAll(memoCards);
  }

  @override
  List<Object?> get props => [memoCardSet];
}

final class MemoCardSetAddSuccess extends MemoCardSetState {
  MemoCardSetAddSuccess({required memoCards}) {
    memoCardSet.addAll(memoCards);
  }

  @override
  List<Object?> get props => [memoCardSet];
}

final class MemoCardSetRemoveSuccess extends MemoCardSetState {
  MemoCardSetRemoveSuccess({required memoCards}) {
    memoCardSet.addAll(memoCards);
  }

  @override
  List<Object?> get props => [memoCardSet];
}

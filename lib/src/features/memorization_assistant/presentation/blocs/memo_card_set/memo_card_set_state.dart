import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';

sealed class MemoCardSetState extends Equatable {
  final Set<MemoCard> memoCardSet;

  const MemoCardSetState({required this.memoCardSet});

  @override
  List<Object?> get props => [memoCardSet];
}

final class MemoCardSetEmpty extends MemoCardSetState {
  MemoCardSetEmpty() : super(memoCardSet: {});
}

final class MemoCardSetChangeNothing extends MemoCardSetState {
  const MemoCardSetChangeNothing({required Set<MemoCard> memoCards}) : super(memoCardSet: memoCards);
}

final class MemoCardSetAdding extends MemoCardSetState {
  const MemoCardSetAdding({required Set<MemoCard> memoCards}) : super(memoCardSet: memoCards);
}

final class MemoCardSetAddSuccess extends MemoCardSetState {
  const MemoCardSetAddSuccess({required Set<MemoCard> memoCards}) : super(memoCardSet: memoCards);
}

final class MemoCardSetRemoveSuccess extends MemoCardSetState {
  const MemoCardSetRemoveSuccess({required Set<MemoCard> memoCards}) : super(memoCardSet: memoCards);
}

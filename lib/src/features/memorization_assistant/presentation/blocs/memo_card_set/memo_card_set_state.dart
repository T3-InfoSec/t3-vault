import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';

sealed class MemoCardSetState extends Equatable {
  final List<MemoCard> memoCardSet;

  const MemoCardSetState({required this.memoCardSet});

  @override
  List<Object?> get props => [memoCardSet];
}

final class MemoCardSetEmpty extends MemoCardSetState {
  MemoCardSetEmpty() : super(memoCardSet: []);
}

final class MemoCardSetChangeNothing extends MemoCardSetState {
  const MemoCardSetChangeNothing({required List<MemoCard> memoCards}) : super(memoCardSet: memoCards);
}

final class MemoCardSetAdding extends MemoCardSetState {
  const MemoCardSetAdding({required List<MemoCard> memoCards}) : super(memoCardSet: memoCards);
}

final class MemoCardSetAddSuccess extends MemoCardSetState {
  const MemoCardSetAddSuccess({required List<MemoCard> memoCards}) : super(memoCardSet: memoCards);
}

final class MemoCardSetRemoveSuccess extends MemoCardSetState {
  const MemoCardSetRemoveSuccess({required List<MemoCard> memoCards}) : super(memoCardSet: memoCards);
}

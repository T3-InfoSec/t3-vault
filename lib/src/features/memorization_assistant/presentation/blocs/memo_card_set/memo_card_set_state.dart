import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';

sealed class MemoCardSetState extends Equatable {
  final List<MemoCard> memoCardCollection = const <MemoCard>[];

  const MemoCardSetState();

  @override
  List<Object?> get props => [memoCardCollection];
}

final class MemoCardSetEmpty extends MemoCardSetState {
  const MemoCardSetEmpty();

  @override
  List<Object?> get props => [memoCardCollection];
}

final class MemoCardSetAddSuccess extends MemoCardSetState {
  const MemoCardSetAddSuccess({memoCardCollection});

  @override
  List<Object?> get props => [memoCardCollection];
}

final class MemoCardSetRemoveSuccess extends MemoCardSetState {
  const MemoCardSetRemoveSuccess({memoCardCollection});

  @override
  List<Object?> get props => [memoCardCollection];
}

import 'package:equatable/equatable.dart';
import 'package:t3_memassist/memory_assistant.dart';

sealed class MemoCardSetState extends Equatable {
  final List<MemoCard> memoCardSet;

  const MemoCardSetState({this.memoCardSet = const []});
  @override
  List<Object?> get props => [memoCardSet];
}

final class MemoCardSetEmpty extends MemoCardSetState {
  const MemoCardSetEmpty() : super();
}

final class MemoCardSetChangeNothing extends MemoCardSetState {
  const MemoCardSetChangeNothing({required List<MemoCard> memoCards}) 
      : super(memoCardSet: memoCards); 

  @override
  List<Object?> get props => [memoCardSet];
}

final class MemoCardSetAddSuccess extends MemoCardSetState {
  const MemoCardSetAddSuccess({required List<MemoCard> memoCards}) 
      : super(memoCardSet: memoCards);

  @override
  List<Object?> get props => [memoCardSet];
}

final class MemoCardSetRemoveSuccess extends MemoCardSetState {
  const MemoCardSetRemoveSuccess({required List<MemoCard> memoCards}) 
      : super(memoCardSet: memoCards); 

  @override
  List<Object?> get props => [memoCardSet];
}
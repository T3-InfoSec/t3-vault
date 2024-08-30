import 'package:bloc/bloc.dart';

import 'bloc.dart';

class MemoCardSetBloc
    extends Bloc<MemoCardSetEvent, MemoCardSetState> {
  MemoCardSetBloc() : super(MemoCardSetEmpty()) {
    on<MemoCardSetCardAdded>(_onMemoCardCollectionEvent);
    on<MemoCardSetCardRemoved>(_onMemoCardCollectionEvent);
  }

  Future<void> _onMemoCardCollectionEvent(
    MemoCardSetEvent event,
    Emitter<MemoCardSetState> emit,
  ) async {
    if (event is MemoCardSetCardAdded) {
      state.memoCardSet.add(event.memoCard);
      return emit(MemoCardSetAddSuccess(memoCards: state.memoCardSet));
    }

    if (event is MemoCardSetCardRemoved) {
      if (state.memoCardSet.isEmpty) {
        return emit(MemoCardSetEmpty());
      } else {
        state.memoCardSet.add(event.memoCard);
        state.memoCardSet.remove(event.memoCard);
        return emit(MemoCardSetRemoveSuccess(memoCards: state.memoCardSet));
      }
    }
  }
}

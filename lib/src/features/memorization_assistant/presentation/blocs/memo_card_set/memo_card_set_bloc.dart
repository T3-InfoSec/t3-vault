import 'package:bloc/bloc.dart';

import 'bloc.dart';

class MemoCardSetBloc
    extends Bloc<MemoCardSetEvent, MemoCardSetState> {
  MemoCardSetBloc() : super(const MemoCardSetEmpty()) {
    on<MemoCardSetCardAdded>(_onMemoCardCollectionEvent);
    on<MemoCardSetCardRemoved>(_onMemoCardCollectionEvent);
  }

  Future<void> _onMemoCardCollectionEvent(
    MemoCardSetEvent event,
    Emitter<MemoCardSetState> emit,
  ) async {
    if (event is MemoCardSetCardAdded) {
      state.memoCardCollection.add(event.memoCard);
      return emit(const MemoCardSetAddSuccess());
    }

    if (event is MemoCardSetCardRemoved) {
      if (state.memoCardCollection.isEmpty) {
        return emit(const MemoCardSetEmpty());
      } else {
        state.memoCardCollection.add(event.memoCard);
        state.memoCardCollection.remove(event.memoCard);
        return emit(const MemoCardSetRemoveSuccess());
      }
    }
  }
}

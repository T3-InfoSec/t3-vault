import 'package:bloc/bloc.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/memo_card_set_repository.dart';

import 'bloc.dart';

class MemoCardSetBloc
    extends Bloc<MemoCardSetEvent, MemoCardSetState> {
      final MemoCardSetRepository repository;
  MemoCardSetBloc({required this.repository}) : super(const MemoCardSetEmpty()) {
    on<MemoCardSetUnchanged>(_onMemoCardSetEvent);
    on<MemoCardSetCardAdded>(_onMemoCardSetEvent);
    on<MemoCardSetCardRemoved>(_onMemoCardSetEvent);

    _initialize();
  }

  Future<void> _initialize() async {
    add(MemoCardSetUnchanged());
  }

  Future<void> _onMemoCardSetEvent(
    MemoCardSetEvent event,
    Emitter<MemoCardSetState> emit,
  ) async {
    if (event is MemoCardSetUnchanged) {
      final memoCards = await repository.getMemoCardSet();
      return emit(MemoCardSetChangeNothing(memoCards: memoCards));
    }

    if (event is MemoCardSetCardAdded) {
      await repository.addMemoCard(event.memoCard);
      final memoCards = await repository.getMemoCardSet();

      return emit(MemoCardSetAddSuccess(memoCards: memoCards));
    }

    if (event is MemoCardSetCardRemoved) {
      await repository.removeMemoCard(event.memoCard);
      final memoCards = await repository.getMemoCardSet();
      if (memoCards.isEmpty) {
        return emit(const MemoCardSetEmpty());
      } else {
        return emit(MemoCardSetRemoveSuccess(memoCards: memoCards));
      }
    }
  }
}

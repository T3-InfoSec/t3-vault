import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/memo_card_json_repository.dart';

class MemoCardSetBloc
    extends Bloc<MemoCardSetEvent, MemoCardSetState> {
  final MemoCardRepository memoCardRepository;
  
  MemoCardSetBloc({required this.memoCardRepository}) : super(MemoCardSetEmpty()) {
    on<MemoCardSetLoadRequested>(_onMemoCardSetEvent);
    on<MemoCardSetUnchanged>(_onMemoCardSetEvent);
    on<MemoCardSetCardsAdding>(_onMemoCardSetEvent);
    on<MemoCardSetCardsAdded>(_onMemoCardSetEvent);
    on<MemoCardSetCardRemoved>(_onMemoCardSetEvent);
  }

  Future<void> _onMemoCardSetEvent(
    MemoCardSetEvent event,
    Emitter<MemoCardSetState> emit,
  ) async {

    if (event is MemoCardSetLoadRequested) {
      await _loadMemoCardsFromRepository();
      return emit(MemoCardSetChangeNothing(memoCards: memoCardRepository.memoCards));
    }

    if (event is MemoCardSetUnchanged) {
      return emit(MemoCardSetChangeNothing(memoCards: memoCardRepository.memoCards));
    }

    if (event is MemoCardSetCardsAdding) {
      return emit(MemoCardSetAdding(memoCards: memoCardRepository.memoCards));
    }

    if (event is MemoCardSetCardsAdded) {
      await memoCardRepository.addMemoCard(event.memoCards);
      return emit(MemoCardSetAddSuccess(memoCards: memoCardRepository.memoCards));
    }

    if (event is MemoCardSetCardRemoved) {
      await memoCardRepository.removeMemoCard(event.memoCard.id);
      if (memoCardRepository.memoCards.isEmpty) {
        return emit(MemoCardSetEmpty());
      } else {
        return emit(MemoCardSetRemoveSuccess(memoCards: memoCardRepository.memoCards));
      }
    }
  }

  Future<void> _loadMemoCardsFromRepository() async {
      await memoCardRepository.readMemoCards();
  }
}
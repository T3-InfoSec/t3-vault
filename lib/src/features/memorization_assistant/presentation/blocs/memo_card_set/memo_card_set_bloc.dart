import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/memo_card_json_repository.dart';

class MemoCardSetBloc
    extends Bloc<MemoCardSetEvent, MemoCardSetState> {
  final MemoCardRepository memoCardRepository;
  
  MemoCardSetBloc({required this.memoCardRepository}) : super(MemoCardSetEmpty()) {
    on<MemoCardSetLoadRequested>(_onMemoCardSetEvent);
    on<MemoCardSetUnchanged>(_onMemoCardSetEvent);
    on<MemoCardSetCardAdded>(_onMemoCardSetEvent);
    on<MemoCardSetCardRemoved>(_onMemoCardSetEvent);
    // _loadMemoCardsFromRepository();
  }

  Future<void> _onMemoCardSetEvent(
    MemoCardSetEvent event,
    Emitter<MemoCardSetState> emit,
  ) async {

    if (event is MemoCardSetLoadRequested) {
      await _loadMemoCardsFromRepository();
      return emit(MemoCardSetChangeNothing(memoCards: memoCardRepository.memoCardIdMap.values.toList()));
    }

    if (event is MemoCardSetUnchanged) {
      return emit(MemoCardSetChangeNothing(memoCards: memoCardRepository.memoCardIdMap.values.toList()));
    }

    if (event is MemoCardSetCardAdded) {
      await memoCardRepository.addMemoCard(event.memoCard);
      return emit(MemoCardSetAddSuccess(memoCards: memoCardRepository.memoCardIdMap.values.toList()));
    }

    if (event is MemoCardSetCardRemoved) {
      await memoCardRepository.removeMemoCard(event.memoCard);
      if (memoCardRepository.memoCardIdMap.isEmpty) {
        return emit(MemoCardSetEmpty());
      } else {
        return emit(MemoCardSetRemoveSuccess(memoCards: memoCardRepository.memoCardIdMap.values.toList()));
      }
    }
  }

  Future<void> _loadMemoCardsFromRepository() async {
      await memoCardRepository.readMemoCards();
  }

}
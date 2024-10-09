import 'bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:t3_memassist/memory_assistant.dart';

import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/memo_card_json_repository.dart';

class MemoCardSetBloc
    extends Bloc<MemoCardSetEvent, MemoCardSetState> {
  final MemoCardRepository memoCardRepository;
  
  MemoCardSetBloc({required this.memoCardRepository}) : super(MemoCardSetEmpty()) {
    on<MemoCardSetUnchanged>(_onMemoCardSetEvent);
    on<MemoCardSetCardAdded>(_onMemoCardSetEvent);
    on<MemoCardSetCardRemoved>(_onMemoCardSetEvent);
  }

  Future<void> _onMemoCardSetEvent(
    MemoCardSetEvent event,
    Emitter<MemoCardSetState> emit,
  ) async {
    List<MemoCard> memoCardSet = await memoCardRepository.readMemoCards();

    if (event is MemoCardSetUnchanged) {
      return emit(MemoCardSetChangeNothing(memoCards: memoCardSet));
    }

    if (event is MemoCardSetCardAdded) {
      memoCardSet.add(event.memoCard);
      await memoCardRepository.writeMemoCards(memoCardSet);
      return emit(MemoCardSetAddSuccess(memoCards: memoCardSet));
    }

    if (event is MemoCardSetCardRemoved) {
      if (memoCardSet.isEmpty) {
        return emit(MemoCardSetEmpty());
      } else {
        memoCardSet.remove(event.memoCard);
        await memoCardRepository.writeMemoCards(memoCardSet);
        return emit(MemoCardSetRemoveSuccess(memoCards: memoCardSet));
      }
    }
  }
}

import 'package:t3_vault/src/features/memorization_assistant/domain/converters/memo_card_json_converter.dart';

import 'bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:t3_memassist/memory_assistant.dart';

import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/memo_card_json_repository.dart';

class MemoCardSetBloc
    extends Bloc<MemoCardSetEvent, MemoCardSetState> {
  final MemoCardRepository memoCardRepository;
  Map<String, MemoCard> _memoCardIdMap = {};
  
  MemoCardSetBloc({required this.memoCardRepository}) : super(MemoCardSetEmpty()) {
    on<MemoCardSetLoadRequested>(_onMemoCardSetEvent);
    on<MemoCardSetUnchanged>(_onMemoCardSetEvent);
    on<MemoCardSetCardAdded>(_onMemoCardSetEvent);
    on<MemoCardSetCardRemoved>(_onMemoCardSetEvent);
    on<MemoCardSetCardUpdated>(_onMemoCardSetEvent);
    _loadMemoCardsFromRepository();
  }

  Future<void> _onMemoCardSetEvent(
    MemoCardSetEvent event,
    Emitter<MemoCardSetState> emit,
  ) async {

    if (event is MemoCardSetLoadRequested) {
      await _loadMemoCardsFromRepository();
      return emit(MemoCardSetChangeNothing(memoCards: _memoCardIdMap.values.toList()));
    }

    if (event is MemoCardSetUnchanged) {
      return emit(MemoCardSetChangeNothing(memoCards: _memoCardIdMap.values.toList()));
    }

    if (event is MemoCardSetCardAdded) {
      final id = MemoCardConverter.generateId();
      _memoCardIdMap[id] = event.memoCard;
      await memoCardRepository.writeMemoCards(_memoCardIdMap);
      return emit(MemoCardSetAddSuccess(memoCards: _memoCardIdMap.values.toList()));
    }

    if (event is MemoCardSetCardRemoved) {
      if (_memoCardIdMap.isEmpty) {
        return emit(MemoCardSetEmpty());
      } else {
        final memoCardId = _getMemoCardId(event.memoCard);
        if (memoCardId != null) {
          _memoCardIdMap.remove(memoCardId);
          await memoCardRepository.writeMemoCards(_memoCardIdMap);
          return emit(MemoCardSetRemoveSuccess(memoCards: _memoCardIdMap.values.toList()));
        }
      }
    }

    if (event is MemoCardSetCardUpdated) {
      final memoCardId = _getMemoCardId(event.updatedMemoCard);
      if (memoCardId != null) {
        _memoCardIdMap[memoCardId] = event.updatedMemoCard;
        await memoCardRepository.writeMemoCards(_memoCardIdMap);
        return emit(MemoCardSetCardUpdatedSuccess(memoCards: _memoCardIdMap.values.toList()));
      }
    }
  }

  Future<void> _loadMemoCardsFromRepository() async {
      _memoCardIdMap = await memoCardRepository.readMemoCards();
  }

  String? _getMemoCardId(MemoCard memoCard) {
    return _memoCardIdMap.entries.firstWhere((entry) => entry.value == memoCard).key;
  }

}

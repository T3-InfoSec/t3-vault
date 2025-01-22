import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/profile_json_repository.dart';

import 'bloc.dart';

import 'package:bloc/bloc.dart';


class MemoCardSetBloc
    extends Bloc<MemoCardSetEvent, MemoCardSetState> {
  final ProfileRepository profileRepository;
  
  MemoCardSetBloc({required this.profileRepository}) : super(MemoCardSetEmpty()) {
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
      await () async {
          await profileRepository.readProfile();
      }();
      return emit(MemoCardSetChangeNothing(memoCards: profileRepository.memoCards));
    }

    if (event is MemoCardSetUnchanged) {
      return emit(MemoCardSetChangeNothing(memoCards: profileRepository.memoCards));
    }

    if (event is MemoCardSetCardsAdding) {
      return emit(MemoCardSetAdding(memoCards: profileRepository.memoCards));
    }

    if (event is MemoCardSetCardsAdded) {
      await profileRepository.addMemoCards(event.memoCards);
      return emit(MemoCardSetAddSuccess(memoCards: profileRepository.memoCards));
    }

    if (event is MemoCardSetCardRemoved) {
      await profileRepository.removeMemoCard(event.memoCard.id);
      if (profileRepository.memoCards.isEmpty) {
        return emit(MemoCardSetEmpty());
      } else {
        return emit(MemoCardSetRemoveSuccess(memoCards: profileRepository.memoCards));
      }
    }
  }
}
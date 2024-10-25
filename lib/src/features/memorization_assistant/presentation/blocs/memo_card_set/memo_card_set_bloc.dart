import 'bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/memo_card_json_repository.dart';

class ProfilesBloc
    extends Bloc<ProfileSetEvent, ProfileSetState> {
  final ProfileRepository memoCardRepository;
  
  ProfilesBloc({required this.memoCardRepository}) : super(ProfileSetEmpty()) {
    on<ProfileSetLoadRequested>(_onMemoCardSetEvent);
    on<ProfileSetUnchanged>(_onMemoCardSetEvent);
    on<ProfileSetAdded>(_onMemoCardSetEvent);
    on<MemoProfileSetMemoCardRemoved>(_onMemoCardSetEvent);
    _loadMemoCardsFromRepository();
  }

  Future<void> _onMemoCardSetEvent(
    ProfileSetEvent event,
    Emitter<ProfileSetState> emit,
  ) async {

    if (event is ProfileSetLoadRequested) {
      await _loadMemoCardsFromRepository();
      return emit(ProfileSetChangeNothing(profiles: memoCardRepository.profileIdMap.values.toList()));
    }

    if (event is ProfileSetUnchanged) {
      return emit(ProfileSetChangeNothing(profiles: memoCardRepository.profileIdMap.values.toList()));
    }

    if (event is ProfileSetAdded) {
      await memoCardRepository.addMemoCard(event.profile);
      return emit(ProfileSetAddSuccess(profiles: memoCardRepository.profileIdMap.values.toList()));
    }

    if (event is MemoProfileSetMemoCardRemoved) {
      await memoCardRepository.removeMemoCard(event.memoCard);
      if (memoCardRepository.profileIdMap.isEmpty) {
        return emit(ProfileSetEmpty());
      } else {
        return emit(ProfileSetRemoveSuccess(profiles: memoCardRepository.profileIdMap.values.toList()));
      }
    }
  }

  Future<void> _loadMemoCardsFromRepository() async {
      await memoCardRepository.readProfiles();
  }

}

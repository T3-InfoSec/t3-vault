import 'package:bloc/bloc.dart';
import 'package:t3_vault/src/features/memorization_assistant/domain/repositories/profile_json_repository.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/blocs.dart';

class MemoCardRatingBloc
    extends Bloc<MemoCardRatingEvent, MemoCardRatingState> {
  final ProfileRepository profileRepository;

  MemoCardRatingBloc({required this.profileRepository})
      : super(MemoCardRatedAgain()) {
    on<MemoCardRatingPressed>(_onMemoCardRatingEvent);
  }

  Future<void> _onMemoCardRatingEvent(
    MemoCardRatingPressed event,
    Emitter<MemoCardRatingState> emit,
  ) async {
    
    if (event.rating == 'Again') {
      emit(MemoCardRatedAgain());
    }

    else if (event.rating == 'Hard') {
      emit(MemoCardRatedHard());
    }

    else if (event.rating == 'Good') {
      emit(MemoCardRatedGood());
    }

    else if (event.rating == 'Easy') {
      emit(MemoCardRatedEasy());
    }

    profileRepository.updateMemoCard(event.memoCard);
  }
}

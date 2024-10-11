import 'package:bloc/bloc.dart';
import 'package:t3_memassist/memory_assistant.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/blocs.dart';

class MemoCardRatingBloc
    extends Bloc<MemoCardRatingEvent, MemoCardRatingState> {
  final MemoCardSetBloc memoCardSetBloc;

  MemoCardRatingBloc({required this.memoCardSetBloc})
      : super(MemoCardRatedAgain()) {
    on<MemoCardRatingPressed>(_onMemoCardRatingEvent);
  }

  Future<void> _onMemoCardRatingEvent(
    MemoCardRatingPressed event,
    Emitter<MemoCardRatingState> emit,
  ) async {

    MemoCard updatedMemoCard = event.memoCard;
    
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

    memoCardSetBloc.add(MemoCardSetCardUpdated(updatedMemoCard: updatedMemoCard));
  }
}

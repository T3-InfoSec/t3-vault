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
      return emit(MemoCardRatedAgain());
    }

    if (event.rating == 'Hard') {
      return emit(MemoCardRatedHard());
    }

    if (event.rating == 'Good') {
      return emit(MemoCardRatedGood());
    }

    if (event.rating == 'Easy') {
      return emit(MemoCardRatedEasy());
    }

    memoCardSetBloc.add(MemoCardSetCardUpdated(updatedMemoCard: updatedMemoCard));
  }
}

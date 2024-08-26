import 'package:bloc/bloc.dart';

import 'bloc.dart';

class MemoCardRatingBloc
    extends Bloc<MemoCardRatingEvent, MemoCardRatingState> {
  MemoCardRatingBloc() : super(MemoCardRatedAgain()) {
    on<MemoCardRatingPressed>(_onMemoCardRatingEvent);
  }

  Future<void> _onMemoCardRatingEvent(
    MemoCardRatingPressed event,
    Emitter<MemoCardRatingState> emit,
  ) async {
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
  }
}

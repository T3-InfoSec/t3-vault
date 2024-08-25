import 'package:bloc/bloc.dart';

import 'bloc.dart';

class MemoCardRatingBloc
    extends Bloc<MemoCardRatingEvent, MemoCardRatingState> {
  MemoCardRatingBloc() : super(MemoCardRatingStateGood()) {
    on<MemoCardRatedAgain>(_onMemoCardRatingEvent);
    on<MemoCardRatedHard>(_onMemoCardRatingEvent);
    on<MemoCardRatedGood>(_onMemoCardRatingEvent);
    on<MemoCardRatedEasy>(_onMemoCardRatingEvent);
  }

  Future<void> _onMemoCardRatingEvent(
    MemoCardRatingEvent event,
    Emitter<MemoCardRatingState> emit,
  ) async {
    if (event is MemoCardRatedAgain) {
      return emit(MemoCardRatingStateAgain());
    }

    if (event is MemoCardRatedHard) {
      return emit(MemoCardRatingStateHard());
    }

    if (event is MemoCardRatedGood) {
      return emit(MemoCardRatingStateGood());
    }

    if (event is MemoCardRatedEasy) {
      return emit(MemoCardRatingStateEasy());
    }
  }
}

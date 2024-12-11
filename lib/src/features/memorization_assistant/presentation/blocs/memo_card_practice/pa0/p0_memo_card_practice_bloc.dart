import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/pa0/p0_memo_card_practice_event.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/pa0/p0_memo_card_practice_state.dart';

class Pa0MemoCardPracticeBloc extends Bloc<P0MemoCardPracticeEvent, Pa0MemoCardPracticeState> {
  final String pa0Seed;

  Pa0MemoCardPracticeBloc(this.pa0Seed) : super(Pa0PracticeInProgress()) {
    on<SubmitWords>((event, emit) {
      final userInput = event.words.trim();
      final isCorrect = userInput == pa0Seed;
      emit(Pa0PracticeFeedback(isCorrect));
    });
  }
}

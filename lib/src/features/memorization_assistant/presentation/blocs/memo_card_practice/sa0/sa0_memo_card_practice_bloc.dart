import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/sa0/sa0_memo_card_practice_event.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/sa0/sa0_memo_card_practice_state.dart';

class Sa0MemoCardPracticeBloc extends Bloc<Sa0MemoCardPracticeEvent, Sa0MemoCardPracticeState> {
  final String sa0Mnemonic;

  Sa0MemoCardPracticeBloc(this.sa0Mnemonic) : super(Sa0PracticeInProgress()) {
    on<SubmitWords>((event, emit) {
      final userInput = event.words.trim();
      final isCorrect = userInput == sa0Mnemonic;
      emit(Sa0PracticeFeedback(isCorrect));
    });
  }
}

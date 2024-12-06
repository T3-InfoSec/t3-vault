import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/eka/eka_memo_card_practice_event.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/eka/eka_memo_card_practice_state.dart';

class EkaMemoCardPracticeBloc extends Bloc<EkaMemoCardPracticeEvent, EkaMemoCardPracticeState> {
  EkaMemoCardPracticeBloc() : super(EkaMemoCardPracticeInitial()) {
    on<SubmitAnswer>((event, emit) {
      emit(EkaMemoCardPracticeFeedback(event.isCorrect));
    });
  }
}

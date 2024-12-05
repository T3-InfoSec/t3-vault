import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t3_formosa/formosa.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/p0_memo_card_practice_event.dart';
import 'package:t3_vault/src/features/memorization_assistant/presentation/blocs/memo_card_practice/p0_memo_card_practice_state.dart';

class Pa0MemoCardPracticeBloc extends Bloc<P0MemoCardPracticeEvent, Pa0MemoCardPracticeState> {
  final List<String> words;
  int _currentWordIndex = 0;

  Pa0MemoCardPracticeBloc(this.words) : super(Pa0PracticeInitial()) {
    on<LoadNextWord>((event, emit) {
      if (_currentWordIndex < words.length) {
        final currentWord = words[_currentWordIndex];
        final options = _generateOptions(currentWord);
        emit(Pa0PracticeInProgress(currentWord, options));
      } else {
        emit(Pa0PracticeComplete());
      }
    });

    on<SelectWord>((event, emit) {
      final isCorrect = event.selectedWord == words[_currentWordIndex];
      emit(Pa0PracticeFeedback(isCorrect));

      if (isCorrect) {
        _currentWordIndex++;
      }

      Future.delayed(const Duration(seconds: 1), () {
        add(LoadNextWord());
      });
    });
  }

  List<String> _generateOptions(String correctWord) {
    final filteredWordList = FormosaTheme.bip39.data.wordList().where((word) => word != correctWord).toList();
    filteredWordList.shuffle(Random());
    final randomWords = filteredWordList.take(3).toList();
    final options = [...randomWords, correctWord];
    options.shuffle(Random());
    return options;
  }
}
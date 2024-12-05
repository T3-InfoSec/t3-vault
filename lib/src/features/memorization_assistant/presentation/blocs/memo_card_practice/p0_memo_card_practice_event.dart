import 'package:equatable/equatable.dart';

abstract class P0MemoCardPracticeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNextWord extends P0MemoCardPracticeEvent {}

class SelectWord extends P0MemoCardPracticeEvent {
  final String selectedWord;

  SelectWord(this.selectedWord);

  @override
  List<Object?> get props => [selectedWord];
}
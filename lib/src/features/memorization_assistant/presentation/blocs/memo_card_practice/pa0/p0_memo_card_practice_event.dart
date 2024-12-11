import 'package:equatable/equatable.dart';

abstract class P0MemoCardPracticeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitWords extends P0MemoCardPracticeEvent {
  final String words;

  SubmitWords(this.words);

  @override
  List<Object?> get props => [words];
}

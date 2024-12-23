import 'package:equatable/equatable.dart';

abstract class Sa0MemoCardPracticeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitWords extends Sa0MemoCardPracticeEvent {
  final String words;

  SubmitWords(this.words);

  @override
  List<Object?> get props => [words];
}

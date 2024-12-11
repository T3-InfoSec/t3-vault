import 'package:equatable/equatable.dart';

abstract class Sa0MemoCardPracticeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Sa0PracticeInitial extends Sa0MemoCardPracticeState {}

class Sa0PracticeInProgress extends Sa0MemoCardPracticeState {

  Sa0PracticeInProgress();

  @override
  List<Object?> get props => [];
}

class Sa0PracticeFeedback extends Sa0MemoCardPracticeState {
  final bool isCorrect;

  Sa0PracticeFeedback(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class Sa0PracticeComplete extends Sa0MemoCardPracticeState {}
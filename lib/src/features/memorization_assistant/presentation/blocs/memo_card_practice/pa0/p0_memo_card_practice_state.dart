import 'package:equatable/equatable.dart';

abstract class Pa0MemoCardPracticeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Pa0PracticeInitial extends Pa0MemoCardPracticeState {}

class Pa0PracticeInProgress extends Pa0MemoCardPracticeState {

  Pa0PracticeInProgress();

  @override
  List<Object?> get props => [];
}

class Pa0PracticeFeedback extends Pa0MemoCardPracticeState {
  final bool isCorrect;

  Pa0PracticeFeedback(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class Pa0PracticeComplete extends Pa0MemoCardPracticeState {}
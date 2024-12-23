abstract class EkaMemoCardPracticeState {}

class EkaMemoCardPracticeInitial extends EkaMemoCardPracticeState {}

class EkaMemoCardPracticeFeedback extends EkaMemoCardPracticeState {
  final bool isCorrect;

  EkaMemoCardPracticeFeedback(this.isCorrect);
}

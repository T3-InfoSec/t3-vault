abstract class EkaMemoCardPracticeEvent {}

class SubmitAnswer extends EkaMemoCardPracticeEvent {
  final bool isCorrect;

  SubmitAnswer(this.isCorrect);
}

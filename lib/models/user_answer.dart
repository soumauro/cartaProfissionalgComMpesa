class UserAnswer {
  final int questionId;
  final String selectedAnswer;
  final bool isCorrect;

  UserAnswer({
    required this.questionId,
    required this.selectedAnswer,
    required this.isCorrect,
  });
}
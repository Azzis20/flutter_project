class Question {
  final int? id;
  final String question;
  final String subject;
  final String topic;
  final List<String> answers;
  final int correctAnswer;

  Question({
    required this.id,
    required this.question,
    required this.subject,
    required this.topic,
    required this.answers,
    required this.correctAnswer,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int?,
      question: map['question'] as String,
      subject: map['subject'] as String,
      topic: map['topic'] as String,
      answers: (map['answers'] as List)
          .map<String>((item) => item.toString())
          .toList(),
      correctAnswer: map['correctanswer'] as int,
    );
  }
}

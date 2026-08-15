class QuestionAnswer {
  final int questionId;
  final String selectedOption; // A, B, C, D or '' if skipped
  final String correctAnswer;
  final bool isCorrect;
  final bool isFlagged;
  final int timeSpentSeconds;

  QuestionAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.correctAnswer,
    required this.isCorrect,
    this.isFlagged = false,
    required this.timeSpentSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOption': selectedOption,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
      'isFlagged': isFlagged,
      'timeSpentSeconds': timeSpentSeconds,
    };
  }

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      questionId: json['questionId'] as int,
      selectedOption: json['selectedOption'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? 'A',
      isCorrect: json['isCorrect'] as bool? ?? false,
      isFlagged: json['isFlagged'] as bool? ?? false,
      timeSpentSeconds: json['timeSpentSeconds'] as int? ?? 0,
    );
  }
}

class TestResult {
  final String id;
  final String company;
  final String title;
  final DateTime date;
  final int totalQuestions;
  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final int totalTimeSeconds;
  final List<QuestionAnswer> answers;

  TestResult({
    required this.id,
    required this.company,
    required this.title,
    required this.date,
    required this.totalQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.skippedCount,
    required this.totalTimeSeconds,
    required this.answers,
  });

  double get scorePercentage =>
      totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0.0;

  double get accuracyPercentage =>
      (correctCount + incorrectCount) > 0
          ? (correctCount / (correctCount + incorrectCount)) * 100
          : 0.0;

  int get avgSecondsPerQuestion =>
      totalQuestions > 0 ? (totalTimeSeconds / totalQuestions).round() : 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'title': title,
      'date': date.toIso8601String(),
      'totalQuestions': totalQuestions,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'skippedCount': skippedCount,
      'totalTimeSeconds': totalTimeSeconds,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'] as String,
      company: json['company'] as String? ?? 'General',
      title: json['title'] as String? ?? 'Placement Test',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      correctCount: json['correctCount'] as int? ?? 0,
      incorrectCount: json['incorrectCount'] as int? ?? 0,
      skippedCount: json['skippedCount'] as int? ?? 0,
      totalTimeSeconds: json['totalTimeSeconds'] as int? ?? 0,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => QuestionAnswer.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

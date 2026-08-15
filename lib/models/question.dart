class Question {
  final int id;
  final String company;
  final String topic;
  final String subTopic;
  final String difficulty; // Easy, Medium, Hard
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer; // A, B, C, D
  final String explanation;
  final int estimatedSeconds;
  final bool isPro;

  Question({
    required this.id,
    required this.company,
    required this.topic,
    required this.subTopic,
    required this.difficulty,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.explanation,
    required this.estimatedSeconds,
    this.isPro = false,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      company: json['company'] as String? ?? 'General',
      topic: json['topic'] as String? ?? 'Aptitude',
      subTopic: json['subTopic'] as String? ?? 'General',
      difficulty: json['difficulty'] as String? ?? 'Easy',
      questionText: json['questionText'] as String? ?? '',
      optionA: json['optionA'] as String? ?? '',
      optionB: json['optionB'] as String? ?? '',
      optionC: json['optionC'] as String? ?? '',
      optionD: json['optionD'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? 'A',
      explanation: json['explanation'] as String? ?? '',
      estimatedSeconds: json['estimatedSeconds'] as int? ?? 45,
      isPro: json['isPro'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'topic': topic,
      'subTopic': subTopic,
      'difficulty': difficulty,
      'questionText': questionText,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'estimatedSeconds': estimatedSeconds,
      'isPro': isPro,
    };
  }

  String getOption(String choice) {
    switch (choice.toUpperCase()) {
      case 'A':
        return optionA;
      case 'B':
        return optionB;
      case 'C':
        return optionC;
      case 'D':
        return optionD;
      default:
        return '';
    }
  }
}

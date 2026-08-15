class UserSubmission {
  final String id;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String explanation;
  final String company;
  final String topic;
  final String difficulty;
  final String contributorEmail;
  final DateTime submittedAt;
  String status; // 'Pending', 'Approved', 'Rejected'

  UserSubmission({
    required this.id,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.explanation,
    required this.company,
    required this.topic,
    required this.difficulty,
    required this.contributorEmail,
    required this.submittedAt,
    this.status = 'Pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'company': company,
      'topic': topic,
      'difficulty': difficulty,
      'contributorEmail': contributorEmail,
      'submittedAt': submittedAt.toIso8601String(),
      'status': status,
    };
  }

  factory UserSubmission.fromJson(Map<String, dynamic> json) {
    return UserSubmission(
      id: json['id'] as String,
      questionText: json['questionText'] as String? ?? '',
      optionA: json['optionA'] as String? ?? '',
      optionB: json['optionB'] as String? ?? '',
      optionC: json['optionC'] as String? ?? '',
      optionD: json['optionD'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? 'A',
      explanation: json['explanation'] as String? ?? '',
      company: json['company'] as String? ?? 'General',
      topic: json['topic'] as String? ?? 'Aptitude',
      difficulty: json['difficulty'] as String? ?? 'Easy',
      contributorEmail: json['contributorEmail'] as String? ?? 'student@example.com',
      submittedAt: DateTime.tryParse(json['submittedAt'] as String? ?? '') ?? DateTime.now(),
      status: json['status'] as String? ?? 'Pending',
    );
  }
}

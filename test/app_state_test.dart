import 'package:flutter_test/flutter_test.dart';
import 'package:placementprep/models/question.dart';
import 'package:placementprep/models/company.dart';
import 'package:placementprep/models/user_profile.dart';
import 'package:placementprep/models/test_result.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Question Model Tests', () {
    test('Question.fromJson parses correctly', () {
      final jsonMap = {
        'id': 101,
        'company': 'TCS',
        'topic': 'Aptitude',
        'subTopic': 'Time & Work',
        'difficulty': 'Medium',
        'questionText': 'A can do a work in 10 days...',
        'optionA': '5 days',
        'optionB': '6 days',
        'optionC': '7 days',
        'optionD': '8 days',
        'correctAnswer': 'B',
        'explanation': 'Explanation here',
        'estimatedSeconds': 50,
        'isPro': false,
      };

      final q = Question.fromJson(jsonMap);
      expect(q.id, 101);
      expect(q.company, 'TCS');
      expect(q.topic, 'Aptitude');
      expect(q.correctAnswer, 'B');
      expect(q.getOption('B'), '6 days');
    });
  });

  group('Company Model Tests', () {
    test('Company.defaultCompanies returns populated list', () {
      final companies = Company.defaultCompanies();
      expect(companies.isNotEmpty, isTrue);
      expect(companies.any((c) => c.name == 'TCS'), isTrue);
      expect(companies.any((c) => c.name == 'Infosys'), isTrue);
    });
  });

  group('UserProfile Model Tests', () {
    test('UserProfile.guest initializes with defaults', () {
      final user = UserProfile.guest();
      expect(user.isGuest, isTrue);
      expect(user.isPro, isFalse);
      expect(user.isAdmin, isFalse);
      expect(user.streakDays, 0);
    });

    test('UserProfile.copyWith modifies fields accurately', () {
      final user = UserProfile.guest();
      final upgraded = user.copyWith(isPro: true, name: 'Alice');
      expect(upgraded.isPro, isTrue);
      expect(upgraded.name, 'Alice');
      expect(upgraded.isGuest, isTrue);
    });
  });

  group('TestResult Model Tests', () {
    test('TestResult calculates accuracy and score percentages', () {
      final result = TestResult(
        id: 'test-1',
        company: 'Infosys',
        title: 'Infosys Mock Drive',
        date: DateTime.now(),
        totalQuestions: 10,
        correctCount: 8,
        incorrectCount: 2,
        skippedCount: 0,
        totalTimeSeconds: 300,
        answers: [],
      );

      expect(result.totalQuestions, 10);
      expect(result.scorePercentage, 80.0);
      expect(result.accuracyPercentage, 80.0);
    });
  });
}

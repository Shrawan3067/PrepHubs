import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question.dart';
import '../models/company.dart';
import '../models/test_result.dart';
import '../models/user_profile.dart';
import '../models/submission.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isOnboardingComplete = false;
  bool get isOnboardingComplete => _isOnboardingComplete;

  UserProfile _user = UserProfile.guest();
  UserProfile get user => _user;

  List<Question> _allQuestions = [];
  List<Question> get allQuestions => _allQuestions;

  final List<Company> _companies = Company.defaultCompanies();
  List<Company> get companies => _companies;

  List<TestResult> _testHistory = [];
  List<TestResult> get testHistory => _testHistory;

  List<UserSubmission> _submissions = [];
  List<UserSubmission> get submissions => _submissions;

  final bool _isOffline = false;
  bool get isOffline => _isOffline;

  // Constructor
  AppState() {
    init();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _isOnboardingComplete = await StorageService.isOnboardingComplete();
    _user = await StorageService.loadUserProfile();
    _testHistory = await StorageService.loadTestHistory();
    _submissions = await StorageService.loadSubmissions();

    await _loadQuestionsJson();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadQuestionsJson() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/questions.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> questionsJson = jsonMap['questions'];
      _allQuestions = questionsJson.map((q) => Question.fromJson(q)).toList();
    } catch (e) {
      _allQuestions = [];
    }
  }

  // Onboarding
  Future<void> completeOnboarding() async {
    _isOnboardingComplete = true;
    await StorageService.setOnboardingComplete(true);
    notifyListeners();
  }

  // Bookmark Management
  bool isBookmarked(int questionId) {
    return _user.bookmarkedQuestionIds.contains(questionId);
  }

  Future<void> toggleBookmark(int questionId) async {
    List<int> updated = List.from(_user.bookmarkedQuestionIds);
    if (updated.contains(questionId)) {
      updated.remove(questionId);
    } else {
      updated.add(questionId);
    }
    _user = _user.copyWith(bookmarkedQuestionIds: updated);
    await StorageService.saveUserProfile(_user);
    notifyListeners();
  }

  // Favorite Company Management
  bool isFavoriteCompany(String companyName) {
    return _user.favoriteCompanies.contains(companyName);
  }

  Future<void> toggleFavoriteCompany(String companyName) async {
    List<String> updated = List.from(_user.favoriteCompanies);
    if (updated.contains(companyName)) {
      updated.remove(companyName);
    } else {
      updated.add(companyName);
    }
    _user = _user.copyWith(favoriteCompanies: updated);
    await StorageService.saveUserProfile(_user);
    notifyListeners();
  }

  // Auth & Migration
  Future<void> signInWithEmail(String email, String name) async {
    // Preserve bookmarks, streak, and history when upgrading from Guest
    _user = _user.copyWith(
      name: name.isNotEmpty ? name : 'Placement Scholar',
      email: email,
      isGuest: false,
    );
    await StorageService.saveUserProfile(_user);
    notifyListeners();
  }

  Future<void> signOut() async {
    _user = UserProfile.guest();
    await StorageService.saveUserProfile(_user);
    notifyListeners();
  }

  // Pro Upgrade
  Future<void> upgradeToPro() async {
    _user = _user.copyWith(isPro: true);
    await StorageService.saveUserProfile(_user);
    notifyListeners();
  }

  // Admin Toggle
  Future<void> toggleAdminMode(bool isAdmin) async {
    _user = _user.copyWith(isAdmin: isAdmin);
    await StorageService.saveUserProfile(_user);
    notifyListeners();
  }

  // Test Session Completion
  Future<void> addTestResult(TestResult result) async {
    _testHistory.insert(0, result);
    await StorageService.saveTestHistory(_testHistory);

    // Update Streak
    _user = _user.copyWith(
      streakDays: _user.streakDays + 1,
      lastActiveDate: DateTime.now(),
    );
    await StorageService.saveUserProfile(_user);
    notifyListeners();
  }

  // Community Question Submission
  Future<void> submitQuestion(UserSubmission submission) async {
    _submissions.insert(0, submission);
    await StorageService.saveSubmissions(_submissions);
    notifyListeners();
  }

  // Admin Actions
  Future<void> updateSubmissionStatus(String id, String newStatus) async {
    final index = _submissions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _submissions[index].status = newStatus;
      await StorageService.saveSubmissions(_submissions);

      // If approved, add to active question bank
      if (newStatus == 'Approved') {
        final sub = _submissions[index];
        final newQ = Question(
          id: DateTime.now().millisecondsSinceEpoch % 10000,
          company: sub.company,
          topic: sub.topic,
          subTopic: 'Community',
          difficulty: sub.difficulty,
          questionText: sub.questionText,
          optionA: sub.optionA,
          optionB: sub.optionB,
          optionC: sub.optionC,
          optionD: sub.optionD,
          correctAnswer: sub.correctAnswer,
          explanation: sub.explanation,
          estimatedSeconds: 45,
          isPro: false,
        );
        _allQuestions.add(newQ);
      }
      notifyListeners();
    }
  }

  // Reset Progress
  Future<void> resetProgress() async {
    _testHistory.clear();
    await StorageService.saveTestHistory(_testHistory);
    _user = _user.copyWith(
      streakDays: 0,
      bookmarkedQuestionIds: [],
    );
    await StorageService.saveUserProfile(_user);
    notifyListeners();
  }

  // Calculated Stats
  int get readinessScore {
    if (_testHistory.isEmpty) return 42; // Default baseline score
    double sumAccuracy = 0;
    for (var t in _testHistory) {
      sumAccuracy += t.accuracyPercentage;
    }
    double avgAcc = sumAccuracy / _testHistory.length;
    int streakBonus = (_user.streakDays * 2).clamp(0, 20);
    return (avgAcc * 0.8 + streakBonus).round().clamp(10, 99);
  }

  double get overallAccuracy {
    if (_testHistory.isEmpty) return 75.0;
    int correct = 0;
    int total = 0;
    for (var t in _testHistory) {
      correct += t.correctCount;
      total += (t.correctCount + t.incorrectCount);
    }
    return total > 0 ? (correct / total) * 100 : 75.0;
  }

  int get totalQuestionsSolved {
    if (_testHistory.isEmpty) return 12;
    int count = 0;
    for (var t in _testHistory) {
      count += t.correctCount;
    }
    return count;
  }

  List<Question> getBookmarkedQuestions() {
    return _allQuestions
        .where((q) => _user.bookmarkedQuestionIds.contains(q.id))
        .toList();
  }

  List<Question> getQuestionsForCompany(String companyName) {
    return _allQuestions.where((q) => q.company == companyName).toList();
  }

  List<Question> getQuestionsForTopic(String topicName) {
    return _allQuestions.where((q) => q.topic == topicName).toList();
  }
}

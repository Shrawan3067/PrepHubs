import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/test_result.dart';
import '../models/submission.dart';

class StorageService {
  static const String keyUser = 'placement_prep_user_profile';
  static const String keyTestHistory = 'placement_prep_test_history';
  static const String keySubmissions = 'placement_prep_user_submissions';
  static const String keyDarkMode = 'placement_prep_dark_mode';
  static const String keyOnboardingComplete = 'placement_prep_onboarding_done';

  static Future<UserProfile> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(keyUser);
    if (userJson != null) {
      try {
        final Map<String, dynamic> map = json.decode(userJson);
        return UserProfile.fromJson(map);
      } catch (_) {
        return UserProfile.guest();
      }
    }
    return UserProfile.guest();
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUser, json.encode(profile.toJson()));
  }

  static Future<List<TestResult>> loadTestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(keyTestHistory);
    if (historyJson != null) {
      try {
        final List<dynamic> list = json.decode(historyJson);
        return list.map((item) => TestResult.fromJson(item as Map<String, dynamic>)).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  static Future<void> saveTestHistory(List<TestResult> history) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = history.map((h) => h.toJson()).toList();
    await prefs.setString(keyTestHistory, json.encode(jsonList));
  }

  static Future<List<UserSubmission>> loadSubmissions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? subsJson = prefs.getString(keySubmissions);
    if (subsJson != null) {
      try {
        final List<dynamic> list = json.decode(subsJson);
        return list.map((item) => UserSubmission.fromJson(item as Map<String, dynamic>)).toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  static Future<void> saveSubmissions(List<UserSubmission> subs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = subs.map((s) => s.toJson()).toList();
    await prefs.setString(keySubmissions, json.encode(jsonList));
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDarkMode, value);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyOnboardingComplete) ?? false;
  }

  static Future<void> setOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyOnboardingComplete, value);
  }
}

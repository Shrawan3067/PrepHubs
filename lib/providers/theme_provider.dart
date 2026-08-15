import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeSetting();
  }

  Future<void> _loadThemeSetting() async {
    _isDarkMode = await StorageService.isDarkMode();
    notifyListeners();
  }

  void toggleTheme(bool dark) {
    _isDarkMode = dark;
    StorageService.setDarkMode(dark);
    notifyListeners();
  }
}

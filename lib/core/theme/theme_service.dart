import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService with ChangeNotifier {
  static final ThemeService instance = ThemeService._internal();
  ThemeService._internal();

  static const String _themeModeKey = 'theme_mode';

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);
    _themeMode = themeModeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  void initializeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode
          ? SystemUiOverlayStyle.light
              .copyWith(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
    );
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    initializeStatusBar();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, isDarkMode ? 'dark' : 'light');

    notifyListeners();
  }
}

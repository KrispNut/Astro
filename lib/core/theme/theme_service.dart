import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astro/main.dart'; // Re-added import

class ThemeService extends ChangeNotifier {
  static final ThemeService instance = ThemeService._internal();

  ThemeService._internal();

  bool _initialized = false;
  ThemeMode _themeMode = ThemeMode.system; // Default theme

  // VoidCallback? onRestartRequested; // Removed callback

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> init() async {
    if (_initialized) return;
    _loadTheme();
    _initialized = true;
  }

  void _loadTheme() {
    _updateStatusBarColor();
  }

  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
    }
    _updateStatusBarColor();
    notifyListeners();

    // Directly call restartApp after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      restartApp();
    });
  }

  // Re-added static restartApp method
  static void restartApp() {
    runApp(const MyApp()); // Ensures MyApp is treated as const
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    _updateStatusBarColor();
    notifyListeners();
    // If you want setTheme to also restart, you can add the restart logic here too:
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   restartApp();
    // });
  }

  void _updateStatusBarColor() {
    Brightness finalStatusBarIconBrightness;
    Brightness finalStatusBarBrightness;

    if (_themeMode == ThemeMode.light) {
      finalStatusBarIconBrightness = Brightness.dark;
      finalStatusBarBrightness = Brightness.light;
    } else if (_themeMode == ThemeMode.dark) {
      finalStatusBarIconBrightness = Brightness.light;
      finalStatusBarBrightness = Brightness.dark;
    } else {
      final platformBrightness =
          WidgetsBinding.instance.window.platformBrightness;
      if (platformBrightness == Brightness.dark) {
        finalStatusBarIconBrightness = Brightness.light;
        finalStatusBarBrightness = Brightness.dark;
      } else {
        finalStatusBarIconBrightness = Brightness.dark;
        finalStatusBarBrightness = Brightness.light;
      }
    }

    final bool effectivelyDarkMode = isDarkMode;
    final Color systemNavBarColor =
        effectivelyDarkMode ? Color(0xFF121212) : Color(0xFFF5F5F5);
    final Brightness systemNavBarIconBrightness =
        effectivelyDarkMode ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: finalStatusBarIconBrightness,
        statusBarBrightness: finalStatusBarBrightness,
        systemNavigationBarColor: systemNavBarColor,
        systemNavigationBarIconBrightness: systemNavBarIconBrightness,
      ),
    );
  }

  void initializeStatusBar() {
    _updateStatusBarColor();
  }
}

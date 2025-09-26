import 'package:astro/core/theme/theme_service.dart';
import 'package:flutter/material.dart';

class AppColors {
  // Background colors
  static Color bgColor() =>
      ThemeService.instance.isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5);

  // Primary colors (faded orange)
  static Color primaryColor() =>
      ThemeService.instance.isDarkMode
          ? const Color(0xFFFF7D45)
          : const Color(0xFFFF9D6F);

  // Text colors
  static Color textColor() =>
      ThemeService.instance.isDarkMode ? Colors.white : const Color(0xFF333333);

  static Color textColor1() =>
      ThemeService.instance.isDarkMode ? const Color(0xFF333333) : Colors.white;

  static Color secondaryTextColor() =>
      ThemeService.instance.isDarkMode
          ? const Color(0xFFAAAAAA)
          : const Color(0xFF666666);

  // Card colors
  static Color cardColor() =>
      ThemeService.instance.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

  // Button colors
  static Color buttonColor() => primaryColor();

  // Icon colors
  static Color iconColor() =>
      ThemeService.instance.isDarkMode ? Colors.white : const Color(0xFF444444);

  // Border colors
  static Color borderColor() =>
      ThemeService.instance.isDarkMode
          ? const Color(0xFF333333)
          : const Color(0xFFDDDDDD);
}

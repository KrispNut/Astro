import 'package:astro/core/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:astro/main.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return IconButton(
      icon: Icon(themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        themeService.toggleTheme();
      },
    );
  }
}

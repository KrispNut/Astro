import 'package:astro/core/theme/theme_service.dart';
import 'package:astro/generated/assets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeService = Provider.of<ThemeService>(context, listen: false);
      _controller.value = themeService.isDarkMode ? 1.0 : 0.5;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      icon: Lottie.asset(
        Assets.lottieDarkMode,
        controller: _controller,
      ),
      onPressed: () {
        final themeService = Provider.of<ThemeService>(context, listen: false);

        if (themeService.isDarkMode) {
          _controller.value = 0.0;
          _controller.animateTo(0.5, duration: _animationDuration);
        } else {
          _controller.value = 0.5;
          _controller.animateTo(1.0, duration: _animationDuration);
        }

        Future.delayed(const Duration(milliseconds: 50), () {
          themeService.toggleTheme();
        });
      },
    );
  }
}

import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/core/theme/AppColors.dart';
import 'package:astro/core/theme/theme_service.dart';
import 'package:astro/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// Provider import is no longer needed for ThemeService if accessed via instance
// import 'package:provider/provider.dart';

class CustomLoading {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context, {String? lottieAsset}) {
    if (_overlayEntry != null) return;

    // final themeService = Provider.of<ThemeService>(context, listen: false); // Changed to use ThemeService.instance

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Material(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      Theme.of(
                        context,
                      ).cardColor, // Keep context for Theme.of(context)
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      ThemeService
                              .instance
                              .isDarkMode // Use singleton instance
                          ? Assets.assetsLoadingDark
                          : Assets.assetsLoadingLight,
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Please wait...",
                      style: getSemiBoldStyle(
                        color: AppColors.textColor(), // Removed context
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

import 'package:astro/features/home/home_controller.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'dart:math';

class AsteroidPage extends StatelessWidget {
  const AsteroidPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return AnimatedBuilder(
      animation: controller.gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Color(0xFF7D9DAA), Color(0xFF263238)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              transform: GradientRotation(
                  controller.gradientController.value * 2 * pi),
            ),
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(Assets.lottieMoon,
                width: 200, height: 200, repeat: true),
            Column(
              children: [
                Text(
                  'Asteroid Watch',
                  textAlign: TextAlign.center,
                  style: getBoldStyle(fontSize: 32, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Summary of near-Earth objects detected in the past 7 days.',
                  textAlign: TextAlign.center,
                  style: getRegularStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            Obx(() {
              if (controller.isLoading.value &&
                  controller.asteroidData.value == null) {
                return const CircularProgressIndicator(color: Colors.white);
              }
              return Column(
                children: [
                  _buildStat('Total Objects Detected',
                      controller.totalAsteroidCount.value.toString()),
                  const SizedBox(height: 8),
                  _buildStat('Potentially Hazardous',
                      controller.hazardousAsteroidCount.value.toString()),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: getMediumStyle(fontSize: 18, color: Colors.white70)),
        Text(value, style: getSemiBoldStyle(fontSize: 18, color: Colors.white)),
      ],
    );
  }
}

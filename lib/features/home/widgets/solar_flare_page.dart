import 'package:astro/features/home/home_controller.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'dart:math';

class SolarFlarePage extends StatelessWidget {
  const SolarFlarePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return AnimatedBuilder(
      animation: controller.gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Color(0xFFEFCF00), Color(0xFFBF360C)],
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
            Lottie.asset(Assets.lottieSun,
                width: 200, height: 200, repeat: true),
            Column(
              children: [
                Text(
                  'Solar Flares',
                  textAlign: TextAlign.center,
                  style: getBoldStyle(fontSize: 32, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Latest solar flare event from the last 30 days.',
                  textAlign: TextAlign.center,
                  style: getRegularStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            Obx(() {
              if (controller.isLoading.value &&
                  controller.flrData.value == null) {
                return const CircularProgressIndicator(color: Colors.white);
              }
              final flr = controller.flrData.value;
              return Column(
                children: [
                  _buildStat('FLR ID', flr?.flrId ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildStat(
                      'Begin Time', flr?.beginTime?.split('T')[0] ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildStat('Class Type', flr?.classType ?? 'N/A'),
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
        Text(label, style: getMediumStyle(fontSize: 16, color: Colors.white70)),
        Text(value, style: getSemiBoldStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}

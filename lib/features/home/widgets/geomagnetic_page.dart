import 'package:astro/features/home/home_controller.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'dart:math';

class GeomagneticPage extends StatelessWidget {
  const GeomagneticPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return AnimatedBuilder(
      animation: controller.gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Color(0xFF3C9E91), Color(0xFF003F4D)],
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(Assets.lottieSaturn,
                width: 300, height: 300, repeat: true),
            Column(
              children: [
                Text(
                  'Geomagnetic Storms',
                  textAlign: TextAlign.center,
                  style: getBoldStyle(fontSize: 32, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Latest geomagnetic storm data from the last 30 days.',
                  textAlign: TextAlign.center,
                  style: getRegularStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            Obx(() {
              if (controller.isLoading.value &&
                  controller.gstData.value == null) {
                return const CircularProgressIndicator(color: Colors.white);
              }
              final gst = controller.gstData.value;
              return Column(
                children: [
                  _buildStat('GST ID', gst?.gstId ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildStat(
                      'Start Time', gst?.startTime?.split('T')[0] ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildStat(
                      'First Kp Index',
                      gst?.allKpIndex.isNotEmpty == true
                          ? gst!.allKpIndex[0].kpIndex.toString()
                          : 'N/A'),
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
        Text(label, style: getMediumStyle(fontSize: 16, color: Colors.white)),
        Text(value, style: getSemiBoldStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}

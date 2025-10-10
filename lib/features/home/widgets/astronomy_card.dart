import 'package:astro/features/home/home_controller.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/core/theme/AppColors.dart';
import 'package:astro/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class AstronomyCard extends StatelessWidget {
  const AstronomyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final today = DateTime.now();
    final formattedDate = DateFormat('MMMM d, yyyy').format(today);

    return Obx(() {
      // The parent Obx is still useful to show loading state
      return Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: 1.17,
            child: Lottie.asset(Assets.assetsCardBorder, fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Astronomy Update - $formattedDate',
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontSize: 18,
                    color: AppColors.textColorStaticBlack,
                  ),
                ),
                const SizedBox(height: 12),
                // Checking the original data source to show loading text
                controller.asteroidData.value != null
                    ? _buildAsteroidSummary(
                        controller, AppColors.textColorStaticBlack)
                    : Text(
                        'Loading celestial data...',
                        style: getLightStyle(
                          fontSize: 14,
                          color: AppColors.textColorStaticBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAsteroidSummary(HomeController controller, Color textColor) {
    // Reading pre-computed values from the controller
    final total = controller.totalAsteroidCount.value;
    final hazardous = controller.hazardousAsteroidCount.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: getBoldStyle(fontSize: 14, color: textColor),
            children: <TextSpan>[
              TextSpan(text: '$total near-Earth objects detected this week'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (hazardous > 0)
          Text(
            '$hazardous potentially hazardous asteroids',
            style: getBoldStyle(fontSize: 14, color: Colors.orange),
            textAlign: TextAlign.center,
          )
        else
          Text(
            'No potentially hazardous asteroids detected',
            style: getBoldStyle(fontSize: 14, color: Colors.green),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}

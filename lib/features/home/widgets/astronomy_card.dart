import 'package:astro/core/theme/AppColors.dart';
import 'package:astro/features/home/model/get_asteroid_data.dart';
import 'package:astro/features/home/controller.dart';
import 'package:astro/core/fonts/text_styles.dart';
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

    return Obx(() {
      final asteroidData = controller.asteroidData.value;
      final today = DateTime.now();
      final formattedDate = DateFormat('MMMM         \nd, yyyy').format(today);
      return Transform.translate(
        offset: Offset(0, -controller.getParallaxOffset(0.15)),
        child: Stack(
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
                    style: getBoldStyle(
                      fontSize: 18,
                      color: AppColors.textColorStaticBlack,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (asteroidData != null)
                    _buildAsteroidSummary(
                      asteroidData,
                      AppColors.textColorStaticBlack,
                    )
                  else
                    Text(
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
        ),
      );
    });
  }

  Widget _buildAsteroidSummary(AsteroidData data, Color textColor) {
    final total = data.elementCount ?? 0;
    final hazardous = _countHazardousAsteroids(data);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: getBoldStyle(fontSize: 14, color: textColor),
            children: <TextSpan>[
              TextSpan(text: '$total near-Earth objects dete'),
              TextSpan(
                text: 'cted this week',
                style: getBoldStyle(fontSize: 14.5, color: Colors.white),
              ),
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

  int _countHazardousAsteroids(AsteroidData data) {
    int count = 0;
    data.nearEarthObjects.forEach((date, asteroids) {
      for (var asteroid in asteroids) {
        if (asteroid.isPotentiallyHazardousAsteroid == true) {
          count++;
        }
      }
    });
    return count;
  }
}

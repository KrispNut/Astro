import 'package:astro/features/home/model/get_asteroid_data.dart';
import 'package:astro/features/home/controller.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/core/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class AstronomyCard extends StatelessWidget {
  const AstronomyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final textMediumColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return Obx(() {
      final asteroidData = controller.asteroidData.value;
      final today = DateTime.now();
      final formattedDate = DateFormat('MMMM d, yyyy').format(today);

      return Transform.translate(
        offset: Offset(0, -controller.getParallaxOffset(0.15)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor().withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor().withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Astronomy Update - $formattedDate',
                  style: getBoldStyle(fontSize: 18, color: textColor),
                ),
                const SizedBox(height: 12),
                if (asteroidData != null)
                  _buildAsteroidSummary(asteroidData, textMediumColor)
                else
                  Text(
                    'Loading celestial data...',
                    style: getLightStyle(fontSize: 14, color: textMediumColor),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAsteroidSummary(AsteroidData data, Color textColor) {
    final total = data.elementCount ?? 0;
    final hazardous = _countHazardousAsteroids(data);

    return Column(
      children: [
        Text(
          '$total near-Earth objects detected this week',
          style: getMediumStyle(fontSize: 14, color: textColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (hazardous > 0)
          Text(
            '$hazardous potentially hazardous asteroids',
            style: getMediumStyle(fontSize: 14, color: Colors.orange),
            textAlign: TextAlign.center,
          )
        else
          Text(
            'No potentially hazardous asteroids detected',
            style: getMediumStyle(fontSize: 14, color: Colors.green),
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

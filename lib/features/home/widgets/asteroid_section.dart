// Create asteroid_section.dart
import 'package:astro/features/home/controller.dart';
import 'package:astro/core/theme/AppColors.dart';
import 'package:astro/core/widgets/custom_loading.dart';
import 'package:astro/features/home/model/get_asteroid_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro/core/fonts/text_styles.dart';

class AsteroidSection extends StatelessWidget {
  const AsteroidSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final textMediumColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.asteroidData.value == null) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor().withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor().withOpacity(0.2)),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            'No asteroid data available',
            style: getMediumStyle(fontSize: 14, color: textMediumColor),
          ),
        );
      }

      final asteroidData = controller.asteroidData.value!;
      final totalAsteroids = asteroidData.elementCount ?? 0;
      final hazardousAsteroids = _countHazardousAsteroids(asteroidData);

      return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Near-Earth Objects',
                style: getBoldStyle(fontSize: 18, color: textColor),
              ),
              const SizedBox(height: 12),
              _buildStatRow('Total Asteroids', totalAsteroids.toString()),
              _buildStatRow(
                'Potentially Hazardous',
                hazardousAsteroids.toString(),
              ),
              const SizedBox(height: 12),
              Text(
                'Recent Close Approaches',
                style: getSemiBoldStyle(fontSize: 14, color: textColor),
              ),
              const SizedBox(height: 8),
              _buildCloseApproachesList(asteroidData),
            ],
          ),
        ),
      );
    });
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

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: getMediumStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: getSemiBoldStyle(fontSize: 14, color: AppColors.textColor()),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseApproachesList(AsteroidData data) {
    final approaches = _getRecentCloseApproaches(data);

    if (approaches.isEmpty) {
      return Text(
        'No recent close approaches',
        style: getMediumStyle(fontSize: 12, color: Colors.grey),
      );
    }

    return Column(
      children:
          approaches.take(3).map((approach) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                approach['name'] ?? 'Unknown',
                style: getMediumStyle(
                  fontSize: 12,
                  color: AppColors.textColor(),
                ),
              ),
              subtitle: Text(
                'Distance: ${approach['distance']} km\nDate: ${approach['date']}',
                style: getLightStyle(
                  fontSize: 10,
                  color: AppColors.textColor(),
                ),
              ),
              trailing:
                  approach['hazardous']
                      ? Icon(Icons.warning, color: Colors.orange, size: 16)
                      : null,
            );
          }).toList(),
    );
  }

  List<Map<String, dynamic>> _getRecentCloseApproaches(AsteroidData data) {
    final List<Map<String, dynamic>> approaches = [];

    data.nearEarthObjects.forEach((date, asteroids) {
      for (var asteroid in asteroids) {
        for (var approach in asteroid.closeApproachData) {
          approaches.add({
            'name': asteroid.name,
            'date':
                approach.closeApproachDate?.toString().split(' ')[0] ??
                'Unknown',
            'distance': approach.missDistance?.kilometers ?? 'Unknown',
            'hazardous': asteroid.isPotentiallyHazardousAsteroid ?? false,
          });
        }
      }
    });

    // Sort by date (most recent first)
    approaches.sort(
      (a, b) => (b['date'] as String).compareTo(a['date'] as String),
    );

    return approaches;
  }
}

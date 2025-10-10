import 'package:astro/features/home/home_controller.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/core/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      if (controller.isLoading.value && controller.asteroidData.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.asteroidData.value == null) {
        return Container(
            // ... same as before
            );
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor.withOpacity(0.2)),
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
              // Reading pre-computed values directly
              _buildStatRow('Total Asteroids',
                  controller.totalAsteroidCount.value.toString()),
              _buildStatRow('Potentially Hazardous',
                  controller.hazardousAsteroidCount.value.toString()),
              const SizedBox(height: 12),
              Text(
                'Recent Close Approaches',
                style: getSemiBoldStyle(fontSize: 14, color: textColor),
              ),
              const SizedBox(height: 8),
              // Passing the pre-computed list
              _buildCloseApproachesList(controller.recentApproaches),
            ],
          ),
        ),
      );
    });
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
            style: getSemiBoldStyle(fontSize: 14, color: AppColors.textColor),
          ),
        ],
      ),
    );
  }

  // Now accepts the pre-computed list directly
  Widget _buildCloseApproachesList(List<Map<String, dynamic>> approaches) {
    if (approaches.isEmpty) {
      return Text(
        'No recent close approaches',
        style: getMediumStyle(fontSize: 12, color: Colors.grey),
      );
    }

    return Column(
      children: approaches.take(3).map((approach) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            approach['name'] ?? 'Unknown',
            style: getMediumStyle(fontSize: 12, color: AppColors.textColor),
          ),
          subtitle: Text(
            'Distance: ${approach['distance']} km\nDate: ${approach['date']}',
            style: getLightStyle(fontSize: 10, color: AppColors.textColor),
          ),
          trailing: approach['hazardous']
              ? Icon(Icons.warning, color: Colors.orange, size: 16)
              : null,
        );
      }).toList(),
    );
  }
}

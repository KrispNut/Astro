import 'package:astro/features/home/model/get_geomagnetic_data.dart';
import 'package:astro/features/home/model/get_solar_flare_data.dart';
import 'package:astro/features/home/model/get_asteroid_data.dart';
import 'package:astro/core/widgets/custom_loading.dart';
import 'package:astro/features/home/repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxDouble scrollOffset = 0.0.obs;
  final ScrollController scrollController = ScrollController();
  final RxBool isLoading = false.obs;

  final Repository _repository = Repository();
  final Rx<AsteroidData?> asteroidData = Rx<AsteroidData?>(null);
  final Rx<GeomagneticData?> gstData = Rx<GeomagneticData?>(null);
  final Rx<SolarFlareData?> flrData = Rx<SolarFlareData?>(null);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScroll);
    fetchAllData();
  }

  void _handleScroll() {
    scrollOffset.value = scrollController.offset;
  }

  @override
  void onClose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    super.onClose();
  }

  double getParallaxOffset(double factor) {
    return scrollOffset.value * factor;
  }

  Future<void> refreshData() async {
    await fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;

      final now = DateTime.now();
      final startDate = "2025-08-07";
      final endDate = "2025-09-07";

      final fetchedAsteroidData = await _repository.fetchAsteroidData(
        startDate: startDate,
        endDate: endDate,
      );
      asteroidData.value = fetchedAsteroidData;

      final fetchedGstData = await _repository.fetchGSTData(
        startDate: startDate,
        endDate: endDate,
      );
      gstData.value = fetchedGstData;

      final fetchedFlrData = await _repository.fetchFLRData(
        startDate: startDate,
        endDate: endDate,
      );
      flrData.value = fetchedFlrData;
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      asteroidData.value = null;
      gstData.value = null;
      flrData.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}

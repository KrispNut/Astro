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
    await fetchAllData(forceRefresh: true);
  }

  Future<void> fetchAllData({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;

      final now = DateTime.now().toUtc(); // Use UTC
      final formatter = DateFormat('yyyy-MM-dd');
      final endDate = formatter.format(now);

      // startDate for GST and FLR (30 days)
      final gstFlrStartDate = formatter.format(
        now.subtract(const Duration(days: 30)),
      );

      // startDate for Asteroids (7 days)
      final asteroidStartDate = formatter.format(
        now.subtract(const Duration(days: 7)),
      );

      final fetchedAsteroidData = await _repository.fetchAsteroidData(
        startDate: asteroidStartDate, // Use 7-day start date
        endDate: endDate,
        forceRefresh: forceRefresh,
      );
      asteroidData.value = fetchedAsteroidData;

      final fetchedGstData = await _repository.fetchGSTData(
        startDate: gstFlrStartDate, // Use 30-day start date
        endDate: endDate,
        forceRefresh: forceRefresh,
      );
      gstData.value = fetchedGstData;

      final fetchedFlrData = await _repository.fetchFLRData(
        startDate: gstFlrStartDate, // Use 30-day start date
        endDate: endDate,
        forceRefresh: forceRefresh,
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

import 'package:astro/features/home/model/get_geomagnetic_data.dart';
import 'package:astro/features/home/model/get_solar_flare_data.dart';
import 'package:astro/features/home/model/get_asteroid_data.dart';
import 'package:astro/features/home/home_repository.dart';
import 'package:astro/core/network/network_monitor.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final RxBool isLoading = false.obs;
  final Repository _repository = Repository();
  final NetworkMonitor _networkMonitor = NetworkMonitor();
  final Rx<AsteroidData?> asteroidData = Rx<AsteroidData?>(null);
  final Rx<GeomagneticData?> gstData = Rx<GeomagneticData?>(null);
  final Rx<SolarFlareData?> flrData = Rx<SolarFlareData?>(null);
  final RxInt totalAsteroidCount = 0.obs;
  final RxInt hazardousAsteroidCount = 0.obs;
  final RxList<Map<String, dynamic>> recentApproaches =
      <Map<String, dynamic>>[].obs;
  late AnimationController uiAnimationController;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;
  late AnimationController gradientController;
  late AnimationController marsAnimationController;
  late LiquidController liquidController;
  final RxInt currentPage = 0.obs;
  final List<String> pageTitles = [
    'Near-Earth Asteroids',
    'Geomagnetic Storms',
    'Solar Flares',
  ];

  @override
  void onInit() {
    super.onInit();
    _networkMonitor.startMonitoring();
    liquidController = LiquidController();
    uiAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
            CurvedAnimation(
                parent: uiAnimationController, curve: Curves.easeOut));
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: uiAnimationController, curve: Curves.easeIn));

    gradientController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..repeat();

    marsAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);

    fetchAllData().then((_) => uiAnimationController.forward());
  }

  @override
  void onClose() {
    uiAnimationController.dispose();
    gradientController.dispose();
    marsAnimationController.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    await fetchAllData(forceRefresh: true);
  }

  void _processAsteroidData(AsteroidData? data) {
    if (data == null) {
      totalAsteroidCount.value = 0;
      hazardousAsteroidCount.value = 0;
      recentApproaches.clear();
      return;
    }
    totalAsteroidCount.value = data.elementCount ?? 0;
    int hazardousCount = 0;
    final List<Map<String, dynamic>> approaches = [];
    data.nearEarthObjects.forEach((date, asteroids) {
      for (var asteroid in asteroids) {
        if (asteroid.isPotentiallyHazardousAsteroid == true) {
          hazardousCount++;
        }
        for (var approach in asteroid.closeApproachData) {
          approaches.add({
            'name': asteroid.name,
            'date': approach.closeApproachDate?.toString().split(' ')[0] ??
                'Unknown',
            'distance': approach.missDistance?.kilometers ?? 'Unknown',
            'hazardous': asteroid.isPotentiallyHazardousAsteroid ?? false,
          });
        }
      }
    });
    hazardousAsteroidCount.value = hazardousCount;
    approaches
        .sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    recentApproaches.value = approaches;
  }

  Future<void> fetchAllData({bool forceRefresh = false}) async {
    try {
      isLoading.value = true;
      final now = DateTime.now().toUtc();
      final formatter = DateFormat('yyyy-MM-dd');
      final endDate = formatter.format(now);
      final gstFlrStartDate =
          formatter.format(now.subtract(const Duration(days: 30)));
      final asteroidStartDate =
          formatter.format(now.subtract(const Duration(days: 7)));
      final results = await Future.wait([
        _repository.fetchAsteroidData(
            startDate: asteroidStartDate,
            endDate: endDate,
            forceRefresh: forceRefresh),
        _repository.fetchGSTData(
            startDate: gstFlrStartDate,
            endDate: endDate,
            forceRefresh: forceRefresh),
        _repository.fetchFLRData(
            startDate: gstFlrStartDate,
            endDate: endDate,
            forceRefresh: forceRefresh),
      ]);
      final fetchedAsteroidData = results[0] as AsteroidData?;
      asteroidData.value = fetchedAsteroidData;
      _processAsteroidData(fetchedAsteroidData);
      gstData.value = results[1] as GeomagneticData?;
      flrData.value = results[2] as SolarFlareData?;
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      asteroidData.value = null;
      gstData.value = null;
      flrData.value = null;
      _processAsteroidData(null);
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:astro/features/home/widgets/gyroscope_background.dart';
import 'package:astro/features/home/widgets/parallax_animation.dart';
import 'package:astro/features/home/widgets/asteroid_section.dart';
import 'package:astro/features/home/widgets/astronomy_card.dart';
import 'package:astro/core/network/network_monitor.dart';
import 'package:astro/features/home/controller.dart';
import 'package:astro/core/theme/theme_toggle.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro/features/home/model/get_geomagnetic_data.dart';
import 'package:astro/features/home/model/get_solar_flare_data.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
  final NetworkMonitor _networkMonitor = NetworkMonitor();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _networkMonitor.startMonitoring();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _animationController.reset();
    await controller.refreshData();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Astro',
          style: getBoldStyle(fontSize: 22, color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [ThemeToggle()],
      ),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: GyroscopeBackground(
          builder: (context, x, y) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Spacer(flex: 1),

                        Transform.translate(
                          offset: Offset(x * 12, y * 12),
                          child: SizedBox(
                            height: screenHeight * 0.25,
                            child: const Center(child: ParallaxAnimation()),
                          ),
                        ),

                        const Spacer(flex: 1),

                        // AstronomyCard with fade and slide animation
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Transform.translate(
                              offset: Offset(x * 6, y * 6),
                              child: const AstronomyCard(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Asteroid Section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Transform.translate(
                              offset: Offset(x * 4, y * 4),
                              child: const AsteroidSection(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Geomagnetic Data Section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Transform.translate(
                              offset: Offset(x * 4, y * 4),
                              child: Obx(() {
                                if (controller.isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (controller.gstData.value != null) {
                                  final gst = controller.gstData.value!;
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Geomagnetic Storm Data',
                                            style: getBoldStyle(
                                              fontSize: 18,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'GST ID: ${gst.gstId ?? 'N/A'}',
                                            style: getRegularStyle(
                                              fontSize: 14,
                                              color: textColor,
                                            ),
                                          ),
                                          Text(
                                            'Start Time: ${gst.startTime ?? 'N/A'}',
                                            style: getRegularStyle(
                                              fontSize: 14,
                                              color: textColor,
                                            ),
                                          ),
                                          if (gst.allKpIndex.isNotEmpty)
                                            Text(
                                              'First Kp Index: ${gst.allKpIndex[0].kpIndex ?? 'N/A'}',
                                              style: getRegularStyle(
                                                fontSize: 14,
                                                color: textColor,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Text(
                                    'Failed to load geomagnetic storm data.',
                                  );
                                }
                              }),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Solar Flare Data Section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Transform.translate(
                              offset: Offset(x * 4, y * 4),
                              child: Obx(() {
                                if (controller.isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (controller.flrData.value != null) {
                                  final flr = controller.flrData.value!;
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Solar Flare Data',
                                            style: getBoldStyle(
                                              fontSize: 18,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'FLR ID: ${flr.flrId ?? 'N/A'}',
                                            style: getRegularStyle(
                                              fontSize: 14,
                                              color: textColor,
                                            ),
                                          ),
                                          Text(
                                            'Begin Time: ${flr.beginTime ?? 'N/A'}',
                                            style: getRegularStyle(
                                              fontSize: 14,
                                              color: textColor,
                                            ),
                                          ),
                                          Text(
                                            'Class Type: ${flr.classType ?? 'N/A'}',
                                            style: getRegularStyle(
                                              fontSize: 14,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Text(
                                    'Failed to load solar flare data.',
                                  );
                                }
                              }),
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:astro/features/home/widgets/asteroid_page.dart';
import 'package:astro/features/home/widgets/geomagnetic_page.dart';
import 'package:astro/features/home/widgets/solar_flare_page.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:astro/features/home/home_controller.dart';
import 'package:astro/core/theme/theme_toggle.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    final pages = [
      const AsteroidPage(),
      const GeomagneticPage(),
      const SolarFlarePage(),
    ];

    return Scaffold(
      // THE FIX: The 'drawer' property has been removed.
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Obx(
            () => Text(
              controller.pageTitles[controller.currentPage.value],
              key: ValueKey<int>(controller.currentPage.value),
              style: getBoldStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [ThemeToggle()],
      ),
      extendBodyBehindAppBar: true,
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.asteroidData.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return LiquidSwipe(
          pages: pages,
          liquidController: controller.liquidController,
          onPageChangeCallback: (page) {
            controller.currentPage.value = page;
          },
          waveType: WaveType.liquidReveal,
          fullTransitionValue: 600,
          enableLoop: true,
          slideIconWidget: null,
        );
      }),
    );
  }
}

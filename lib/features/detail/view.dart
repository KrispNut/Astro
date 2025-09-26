import 'package:astro/core/widgets/custom_loading.dart';
import 'package:astro/features/home/widgets/gyroscope_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astro/core/fonts/text_styles.dart'; // Added import

class DetailView extends StatelessWidget {
  final String title;

  const DetailView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a fallback color, e.g. from the theme or a constant
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: getBoldStyle(
            // Using getBoldStyle
            fontSize: 20,
            color: textColor, // Using the defined color
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: GyroscopeBackground(
        builder: (context, x, y) {
          return Center(
            child: Transform.translate(
              // Small, subtle movement for text
              offset: Offset(x * 4, y * 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Exploring $title...',
                    style: getBoldStyle(
                      // Using getBoldStyle
                      fontSize: 20,
                      color: textColor, // Using the defined color
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailController());
  }
}

class DetailController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Reverting to original working state for CustomLoading.show
    if (Get.context != null) {
      // Adding null check to prevent potential crash
      CustomLoading.show(Get.context!);
      Future.delayed(const Duration(seconds: 2), () {
        CustomLoading.hide();
      });
    } else {
      print(
        "Error: Get.context is null in DetailController.onInit, cannot show CustomLoading.",
      );
    }
  }
}

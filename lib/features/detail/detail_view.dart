import 'package:astro/core/widgets/custom_loading.dart';
import 'package:astro/core/fonts/text_styles.dart';
import 'package:astro/core/fonts/fonts_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailView extends StatelessWidget {
  final String title;

  const DetailView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          // Using your style function WITHOUT the color parameter
          style: getBoldStyle(fontSize: MyFonts.size20),
        ),
        // AppBar colors are now controlled by the theme in main.dart
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Exploring $title...',
              // The text color will now switch automatically!
              style: getBoldStyle(fontSize: MyFonts.size20),
            ),
          ],
        ),
      ),
    );
  }
}

// ... DetailBinding and DetailController remain the same
class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailController());
  }
}

class DetailController extends GetxController {/* ... */}

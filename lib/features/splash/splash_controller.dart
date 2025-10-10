import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Navigate to home screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Get.offNamed('/home');
    });
  }
}

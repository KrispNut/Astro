import 'package:astro/features/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class ParallaxAnimation extends StatelessWidget {
  const ParallaxAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      return Transform.translate(
        offset: Offset(0, controller.getParallaxOffset(0.5)),
        child: SizedBox(
          height: screenHeight * 0.25,
          child: Lottie.asset('assets/mars.json', fit: BoxFit.contain),
        ),
      );
    });
  }
}

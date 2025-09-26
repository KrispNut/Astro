import 'package:astro/core/widgets/custom_alert_dialog.dart';
import 'package:astro/features/splash/view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Constants {
  // TOKEN
  static const token = "1Fkrl0GOrPTjG4aXRav3yPCnRWhDdIR0sE1G0Z5b";

  static void makeToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<bool> expireSession() async {
    bool shouldLeave = false;

    await Get.dialog(
      CustomConfirmationDialog(
        title: 'Session Expired',
        message: "Session expired, please login again.",
        isCloseable: false,
        onConfirm: () async {
          shouldLeave = true;

          Get.offAll(
            () => SplashView(),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 400),
          );
        },
      ),
      barrierDismissible: false,
    );

    return shouldLeave;
  }
}

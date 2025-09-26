import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'dart:io';
import 'package:get/get.dart'; // Added GetX import
import 'package:astro/core/fonts/text_styles.dart'; // Added TextStyles import
import 'package:astro/core/theme/AppColors.dart';

class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  bool _isDialogVisible = false;
  Timer? _timer;

  void startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      bool isConnected = await _hasInternet();
      if (!isConnected && !_isDialogVisible) {
        _showNoInternetDialog();
      } else if (isConnected && _isDialogVisible) {
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Dismiss the dialog if connection is restored
        }
        _isDialogVisible = false;
      }
    });
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showNoInternetDialog() {
    _isDialogVisible = true;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Builder(
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Lottie.asset('assets/404.json'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Connection Lost',
                      style: getBoldStyle(
                        fontSize: 22,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please check your internet connection to continue using the app.',
                      textAlign: TextAlign.center,
                      style: getRegularStyle(
                        fontSize: 16,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
    );
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }
}

import 'dart:convert';
import 'package:astro/features/home/model/get_asteroid_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String orderStatusKey = "order_status";
  static String menuKey = "branch_menu";
  static String paymentKey = "payment_types";
  static String banksKey = "banks_types";
  static String loginKey = "login_data";
  static String asteroidDataResponseKey = "asteroid_data_response";
  static String gstDataResponseKey = "gst_data_response"; // New key for GST
  static String flrDataResponseKey = "flr_data_response"; // New key for FLR

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Asteroid Data
  Future<void> setAsteroidApiResponse(String responseBody) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(asteroidDataResponseKey, responseBody);
  }

  Future<String?> getAsteroidApiResponse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(asteroidDataResponseKey);
  }

  // Geomagnetic Data
  Future<void> setGstApiResponse(String responseBody) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(gstDataResponseKey, responseBody);
  }

  Future<String?> getGstApiResponse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(gstDataResponseKey);
  }

  // Solar Flare Data
  Future<void> setFlrApiResponse(String responseBody) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(flrDataResponseKey, responseBody);
  }

  Future<String?> getFlrApiResponse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(flrDataResponseKey);
  }

  Future<void> setBearerToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('bearerToken', token);
  }

  Future<String> getBearerToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('bearerToken') ?? '';
  }

  Future<void> removeBearerToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('bearerToken');
  }
}

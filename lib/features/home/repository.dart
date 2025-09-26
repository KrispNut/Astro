import 'dart:convert';
import 'package:astro/core/utils/constants.dart';
import 'package:astro/core/utils/shared_pref.dart';
import 'package:astro/core/services/api_services.dart';
import 'package:astro/core/services/api_endpoints.dart';
import 'package:astro/features/home/model/get_asteroid_data.dart';
import 'package:astro/features/home/model/get_geomagnetic_data.dart';
import 'package:astro/features/home/model/get_solar_flare_data.dart';

class Repository {
  final ApiServices _apiServices = ApiServices();
  final SharedPref _sharedPref = SharedPref();

  Future<AsteroidData> fetchAsteroidData({
    required String startDate,
    required String endDate,
  }) async {
    final String? cachedResponse = await _sharedPref.getAsteroidApiResponse();
    if (cachedResponse != null && cachedResponse.isNotEmpty) {
      print("Returning cached asteroid data");
      final decoded = jsonDecode(cachedResponse);
      return AsteroidData.fromJson(decoded);
    }

    final String url =
        "${ApiEndPoints.CNEOS}?start_date=$startDate&end_date=$endDate&api_key=${Constants.token}";

    final response = await _apiServices.getRequestResponse(url);

    if (ApiServices.handleResponseStatus(response)) {
      await _sharedPref.setAsteroidApiResponse(response.body);
      final decoded = jsonDecode(response.body);
      return AsteroidData.fromJson(decoded);
    } else {
      throw Exception("Failed to fetch asteroid data");
    }
  }

  Future<GeomagneticData> fetchGSTData({
    required String startDate,
    required String endDate,
  }) async {
    final String? cachedResponse = await _sharedPref.getGstApiResponse();
    if (cachedResponse != null && cachedResponse.isNotEmpty) {
      print("Returning cached geomagnetic data");
      final decoded = jsonDecode(cachedResponse);
      if (decoded is List && decoded.isNotEmpty) {
        return GeomagneticData.fromJson(decoded[0]);
      } else if (decoded is Map<String, dynamic>) {
        return GeomagneticData.fromJson(decoded);
      } else {
        throw Exception("Invalid cached geomagnetic data format");
      }
    }

    final String url =
        "${ApiEndPoints.GST}?startDate=$startDate&endDate=$endDate&api_key=${Constants.token}";

    final response = await _apiServices.getRequestResponse(url);

    if (ApiServices.handleResponseStatus(response)) {
      await _sharedPref.setGstApiResponse(response.body);
      final decoded = jsonDecode(response.body);
      if (decoded is List && decoded.isNotEmpty) {
        return GeomagneticData.fromJson(decoded[0]);
      } else if (decoded is Map<String, dynamic>) {
        return GeomagneticData.fromJson(decoded);
      } else {
        throw Exception(
          "Failed to fetch geomagnetic data due to invalid response format",
        );
      }
    } else {
      throw Exception("Failed to fetch geomagnetic data");
    }
  }

  Future<SolarFlareData> fetchFLRData({
    required String startDate,
    required String endDate,
  }) async {
    final String? cachedResponse = await _sharedPref.getFlrApiResponse();
    if (cachedResponse != null && cachedResponse.isNotEmpty) {
      print("Returning cached solar flare data");
      final decoded = jsonDecode(cachedResponse);
      if (decoded is List && decoded.isNotEmpty) {
        return SolarFlareData.fromJson(decoded[0]);
      } else if (decoded is Map<String, dynamic>) {
        return SolarFlareData.fromJson(decoded);
      } else {
        throw Exception("Invalid cached solar flare data format");
      }
    }

    final String url =
        "${ApiEndPoints.FLR}?startDate=$startDate&endDate=$endDate&api_key=${Constants.token}";

    final response = await _apiServices.getRequestResponse(url);

    if (ApiServices.handleResponseStatus(response)) {
      await _sharedPref.setFlrApiResponse(response.body);
      final decoded = jsonDecode(response.body);
      if (decoded is List && decoded.isNotEmpty) {
        return SolarFlareData.fromJson(decoded[0]);
      } else if (decoded is Map<String, dynamic>) {
        return SolarFlareData.fromJson(decoded);
      } else {
        throw Exception(
          "Failed to fetch solar flare data due to invalid response format",
        );
      }
    } else {
      throw Exception("Failed to fetch solar flare data");
    }
  }
}

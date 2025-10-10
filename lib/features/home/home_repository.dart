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

  Future<AsteroidData?> fetchAsteroidData({
    required String startDate,
    required String endDate,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final String? cachedResponse = await _sharedPref.getAsteroidApiResponse();
      if (cachedResponse != null && cachedResponse.isNotEmpty) {
        print("Returning cached asteroid data");
        try {
          final decoded = jsonDecode(cachedResponse);
          return AsteroidData.fromJson(decoded);
        } catch (e) {
          print("Error decoding cached asteroid data: $e");
        }
      }
    }

    final String url =
        "${ApiEndPoints.CNEOS}?start_date=$startDate&end_date=$endDate&api_key=${Constants.token}";

    final response = await _apiServices.getRequestResponse(url);

    if (ApiServices.handleResponseStatus(response)) {
      try {
        await _sharedPref.setAsteroidApiResponse(response.body);
        final decoded = jsonDecode(response.body);
        return AsteroidData.fromJson(decoded);
      } catch (e) {
        print("Error decoding API asteroid data: $e");
        return null;
      }
    } else {
      print("Failed to fetch asteroid data from API: ${response.statusCode}");
      return null;
    }
  }

  Future<GeomagneticData?> fetchGSTData({
    required String startDate,
    required String endDate,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final String? cachedResponse = await _sharedPref.getGstApiResponse();
      if (cachedResponse != null && cachedResponse.isNotEmpty) {
        print("Returning cached geomagnetic data");
        try {
          final decoded = jsonDecode(cachedResponse);
          print("Cached GST data type: ${decoded.runtimeType}");
          if (decoded is List) {
            if (decoded.isNotEmpty) {
              final Map<String, dynamic> gstMap =
                  decoded[0] as Map<String, dynamic>;
              try {
                return GeomagneticData.fromJson(gstMap);
              } catch (e) {
                print(
                  "Error parsing GeomagneticData from cached list item: $e",
                );
                return null;
              }
            } else {
              print("Cached GST data is an empty list.");
              return null;
            }
          } else if (decoded is Map<String, dynamic>) {
            try {
              return GeomagneticData.fromJson(decoded);
            } catch (e) {
              print("Error parsing GeomagneticData from cached map: $e");
              return null;
            }
          } else {
            print("Invalid cached geomagnetic data format: not a List or Map.");
            return null;
          }
        } catch (e) {
          print("Error decoding cached geomagnetic data: $e");
        }
      }
    }

    final String url =
        "${ApiEndPoints.GST}?startDate=$startDate&endDate=$endDate&api_key=${Constants.token}";

    final response = await _apiServices.getRequestResponse(url);

    if (ApiServices.handleResponseStatus(response)) {
      try {
        await _sharedPref.setGstApiResponse(response.body);
        final decoded = jsonDecode(response.body);
        print("API GST data type: ${decoded.runtimeType}");

        if (decoded is List) {
          if (decoded.isNotEmpty) {
            final Map<String, dynamic> gstMap =
                decoded[0] as Map<String, dynamic>;
            print("API GST[0] data type: ${gstMap.runtimeType}");
            try {
              return GeomagneticData.fromJson(gstMap);
            } catch (e) {
              print("Error parsing GeomagneticData from API list item: $e");
              return null;
            }
          } else {
            print("API returned an empty list for GST data.");
            return null;
          }
        } else if (decoded is Map<String, dynamic>) {
          try {
            return GeomagneticData.fromJson(decoded);
          } catch (e) {
            print("Error parsing GeomagneticData from API map: $e");
            return null;
          }
        } else {
          print(
            "Failed to fetch geomagnetic data: API response was not a List or Map.",
          );
          return null;
        }
      } catch (e) {
        print("Error processing API geomagnetic data response: $e");
        return null;
      }
    } else {
      print(
        "Failed to fetch geomagnetic data from API: ${response.statusCode}",
      );
      return null;
    }
  }

  Future<SolarFlareData?> fetchFLRData({
    required String startDate,
    required String endDate,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final String? cachedResponse = await _sharedPref.getFlrApiResponse();
      if (cachedResponse != null && cachedResponse.isNotEmpty) {
        print("Returning cached solar flare data");
        try {
          final decoded = jsonDecode(cachedResponse);
          print("Cached FLR data type: ${decoded.runtimeType}");
          if (decoded is List) {
            if (decoded.isNotEmpty) {
              final Map<String, dynamic> flrMap =
                  decoded[0] as Map<String, dynamic>;
              try {
                return SolarFlareData.fromJson(flrMap);
              } catch (e) {
                print("Error parsing SolarFlareData from cached list item: $e");
                return null;
              }
            } else {
              print("Cached FLR data is an empty list.");
              return null;
            }
          } else if (decoded is Map<String, dynamic>) {
            try {
              return SolarFlareData.fromJson(decoded);
            } catch (e) {
              print("Error parsing SolarFlareData from cached map: $e");
              return null;
            }
          } else {
            print("Invalid cached solar flare data format: not a List or Map.");
            return null;
          }
        } catch (e) {
          print("Error decoding cached solar flare data: $e");
        }
      }
    }

    final String url =
        "${ApiEndPoints.FLR}?startDate=$startDate&endDate=$endDate&api_key=${Constants.token}";

    final response = await _apiServices.getRequestResponse(url);

    if (ApiServices.handleResponseStatus(response)) {
      try {
        await _sharedPref.setFlrApiResponse(response.body);
        final decoded = jsonDecode(response.body);
        print("API FLR data type: ${decoded.runtimeType}");
        if (decoded is List) {
          if (decoded.isNotEmpty) {
            final Map<String, dynamic> flrMap =
                decoded[0] as Map<String, dynamic>;
            print("API FLR[0] data type: ${flrMap.runtimeType}");
            try {
              return SolarFlareData.fromJson(flrMap);
            } catch (e) {
              print("Error parsing SolarFlareData from API list item: $e");
              return null;
            }
          } else {
            print("API returned an empty list for FLR data.");
            return null;
          }
        } else if (decoded is Map<String, dynamic>) {
          try {
            return SolarFlareData.fromJson(decoded);
          } catch (e) {
            print("Error parsing SolarFlareData from API map: $e");
            return null;
          }
        } else {
          print(
            "Failed to fetch solar flare data: API response was not a List or Map.",
          );
          return null;
        }
      } catch (e) {
        print("Error processing API solar flare data response: $e");
        return null;
      }
    } else {
      print(
        "Failed to fetch solar flare data from API: ${response.statusCode}",
      );
      return null;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:astro/core/utils/constants.dart';

class ApiServices {
  Future<http.Response> getRequestResponse(String url) async {
    http.Response? response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${Constants.token}'},
    );

    return response;
  }

  Future<http.Response> getRequestResponseWithParams(
    String url, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${Constants.token}'},
    );
    return response;
  }

  Future<http.Response> postRequestResponse(
    String url, {
    Map<String, dynamic>? body,
    bool? applyAuth = true,
  }) async {
    http.Response? response = await http.post(
      Uri.parse(url),
      headers:
          (applyAuth! == true)
              ? {
                'Authorization': 'Bearer ${Constants.token}',
                'Content-Type': 'application/json',
              }
              : {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  static bool handleResponseStatus(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return true;

      case 400:
        Constants.makeToast(
          "Something went wrong ${_extractErrorMessage(response)}",
        );

      case 401:
        Constants.expireSession();
        break;

      case 403:
        Constants.makeToast("Forbidden: Access is denied.");
        break;

      case 404:
        Constants.makeToast("Not Found: ${_extractErrorMessage(response)}");
        break;

      case 422:
        Constants.makeToast(
          "Validation Error: ${_extractErrorMessage(response)}",
        );
        break;

      case 500:
      case 503:
        Constants.makeToast("Server Error: Please try again later.");
        break;

      default:
        Constants.makeToast("Unexpected error: ${response.statusCode}");
    }
    return false;
  }

  static String _extractErrorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded.containsKey('message')) {
        return decoded['message'];
      }
    } catch (_) {}
    return 'No additional information';
  }
}

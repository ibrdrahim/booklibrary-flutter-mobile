import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

enum HttpMethod { GET, POST, PUT, PATCH, DELETE }

class NetworkHelper {
  static String? _baseUrl;

  static void initialize({
    required String baseUrl,
  }) {
    _baseUrl = baseUrl;
  }

  static Future<String?> _getFirebaseJwtToken() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No logged-in user');
    }
    return await currentUser.getIdToken();
  }

  static Future<dynamic> request(
    String endPoint, {
    HttpMethod method = HttpMethod.GET,
    Map<String, dynamic>? data,
    bool accessToken = false,
  }) async {
    if (_baseUrl == null || _baseUrl == '') {
      throw Exception('base url not initialized');
    }

    String url = _baseUrl! + endPoint;
    Map<String, String> headers = {};

    print('url $url');

    if (accessToken) {
      var _credentials = await _getFirebaseJwtToken();
      headers["Authorization"] = "Bearer $_credentials";
      print('_credentials $_credentials');
    }

    try {
      http.Response response;

      switch (method) {
        case HttpMethod.GET:
          // Add data parameters to the URL query string.
          if (data != null) {
            url += '?' + Uri(queryParameters: data).query;
          }
          response = await http.get(Uri.parse(url), headers: headers);
          break;
        case HttpMethod.POST:
          headers["Content-Type"] = "application/json";
          response = await http.post(Uri.parse(url),
              headers: headers, body: jsonEncode(data));
          break;
        case HttpMethod.PATCH:
          headers["Content-Type"] = "application/json";
          response = await http.patch(Uri.parse(url),
              headers: headers, body: jsonEncode(data));
          break;
        case HttpMethod.PUT:
          headers["Content-Type"] = "application/json";
          response = await http.put(Uri.parse(url),
              headers: headers, body: jsonEncode(data));
          break;
        case HttpMethod.DELETE:
          response = await http.delete(Uri.parse(url), headers: headers);
          break;
      }
      print('response.statusCode ${response.statusCode}');
      if (response.statusCode < 400) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server $e');
    }
  }
}

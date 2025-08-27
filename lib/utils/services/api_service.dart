import 'dart:convert';
import 'package:flexpay/exports.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/error_handler.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  // Base URLs
  static String prodEndpointAuth = dotenv.env["PROD_ENDPOINT_AUTH"]!;
  static String prodEndpointBookings = dotenv.env['PROD_ENDPOINT_BOOKINGS']!;
  static String prodEndpointChama = dotenv.env['PROD_ENDPOINT_CHAMA']!;

  // Generic GET request
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters, bool requiresAuth = true}) async {
    try {
      final headers = await _buildHeaders(requiresAuth);
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      print("GET Request to $url succeeded with response: \${response.data}");
      return response;
    } on DioException catch (e) {
      print("GET Request to $url failed with error: \${e.message}");
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String url,
      {dynamic data, bool requiresAuth = true}) async {
    try {
      final headers = await _buildHeaders(requiresAuth);
      print("Sending POST to $url with data: \${jsonEncode(data)}");
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print("Received response: \${response.data}");
      return response;
    } on DioException catch (e) {
      print("Error details: \${e.response?.data}");
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(String url,
      {Map<String, dynamic>? data, bool requiresAuth = true}) async {
    try {
      final headers = await _buildHeaders(requiresAuth);
      final response = await _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print("PUT Request to $url succeeded with response: \${response.data}");
      return response;
    } on DioException catch (e) {
      print("PUT Request to $url failed with error: \${e.message}");
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(String url,
      {Map<String, dynamic>? data, bool requiresAuth = true}) async {
    try {
      final headers = await _buildHeaders(requiresAuth);
      final response = await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers),
      );
      print(
          "DELETE Request to $url succeeded with response: \${response.data}");
      return response;
    } on DioException catch (e) {
      print("DELETE Request to $url failed with error: \${e.message}");
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Build headers with optional token
  Future<Map<String, String>> _buildHeaders(bool requiresAuth) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await SharedPreferencesHelper.getToken();
      print('[ApiService] using token: $token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }
}

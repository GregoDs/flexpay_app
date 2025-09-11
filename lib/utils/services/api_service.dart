import 'dart:convert';
import 'package:flexpay/exports.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';

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
      {Map<String, dynamic>? queryParameters,
      bool requiresAuth = true,
      String? token}) async {
    try {
      final headers = await _buildHeaders(requiresAuth, token: token);
      AppLogger.apiRequest(
        method: 'GET',
        uri: Uri.parse(url),
        headers: headers,
        query: queryParameters,
      );
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'GET',
        uri: Uri.parse(url),
        data: response.data,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.apiError(
        type: 'DioException',
        method: 'GET',
        uri: Uri.parse(url),
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String url,
      {dynamic data, bool requiresAuth = true, String? token}) async {
    try {
      final headers = await _buildHeaders(requiresAuth, token: token);
      AppLogger.apiRequest(
        method: 'POST',
        uri: Uri.parse(url),
        headers: headers,
        body: data,
      );
      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'POST',
        uri: Uri.parse(url),
        data: response.data,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.apiError(
        type: 'DioException',
        method: 'POST',
        uri: Uri.parse(url),
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(String url,
      {Map<String, dynamic>? data,
      bool requiresAuth = true,
      String? token}) async {
    try {
      final headers = await _buildHeaders(requiresAuth, token: token);
      AppLogger.apiRequest(
        method: 'PUT',
        uri: Uri.parse(url),
        headers: headers,
        body: data,
      );
      final response = await _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
      );
      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'PUT',
        uri: Uri.parse(url),
        data: response.data,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.apiError(
        type: 'DioException',
        method: 'PUT',
        uri: Uri.parse(url),
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      throw ErrorHandler.formatDioError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(String url,
      {Map<String, dynamic>? data,
      bool requiresAuth = true,
      String? token}) async {
    try {
      final headers = await _buildHeaders(requiresAuth, token: token);
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

  // Build headers
  Future<Map<String, String>> _buildHeaders(bool requiresAuth,
      {String? token}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      String? finalToken =
          token ?? (await SharedPreferencesHelper.getUserModel())?.token;

      if (finalToken == null || finalToken.isEmpty) {
        AppLogger.log("❌ No token found in SharedPreferences!");
      } else {
        headers['Authorization'] = 'Bearer $finalToken';
      }
    }

    return headers;
  }
}

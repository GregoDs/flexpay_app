import 'package:dio/dio.dart';

class ErrorHandler {
  static Exception formatDioError(DioException error) {
    if (error.response?.data is Map<String, dynamic>) {
      final message = extractErrorMessage(error.response!.data!);
      return Exception(message);
    }

    final fallback = handleError(error);
    return Exception(fallback);
  }

  static String extractErrorMessage(Map<String, dynamic> responseData) {
    try {
      if (responseData['errors'] is List &&
          (responseData['errors'] as List).isNotEmpty) {
        return (responseData['errors'] as List).first.toString();
      }
      if (responseData['data'] is List &&
          (responseData['data'] as List).isNotEmpty) {
        return (responseData['data'] as List).first.toString();
      }
      if (responseData['message'] != null) {
        return responseData['message'].toString();
      }
      return 'An error occurred';
    } catch (_) {
      return 'An error occurred';
    }
  }

  static String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet connection.";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout. Please check your internet connection.";
      case DioExceptionType.sendTimeout:
        return "Send timeout. Please check your internet connection.";
      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      default:
        break;
    }

    switch (error.response?.statusCode) {
      case 400:
        return "Bad request. Please check your input.";
      case 401:
        return "Unauthorized. Please log in again.";
      case 403:
        return "Forbidden. You don't have permission.";
      case 404:
        return "Resource not found.";
      case 422:
        return "Validation error. Please check your input.";
      case 500:
        return "Internal server error. Please try again later.";
      case 503:
        return "Service unavailable. Please try again later.";
    }

    return "An unexpected error occurred. Please try again.";
  }

  static String handleGenericError(dynamic error) {
    return error.toString().replaceFirst('Error: ', '');
  }
}

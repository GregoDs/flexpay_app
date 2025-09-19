import 'package:flexpay/exports.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';

class BookingsRepository {
  final ApiService _apiService = ApiService();

  /// Fetch all bookings for a given user
  Future<List<Booking>> fetchAllBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url = "${ApiService.prodEndpointBookings}/customer/$userId";

      final response = await _apiService.post(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
     if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }

  //Fetch active bookings
  Future<List<Booking>> fetchActiveBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url = "${ApiService.prodEndpointBookings}/active/customer/$userId";

      final response = await _apiService.get(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }

  /// FETCH OVERDUE BOOKINGS ///
  Future<List<Booking>> fetchOverdueBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url = "${ApiService.prodEndpointBookings}/overdue/customer/$userId";

      final response = await _apiService.get(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }

  /// FETCH Unserviced BOOKINGS ///
  Future<List<Booking>> fetchUnservicedBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;
      final phoneNumber = userModel?.user.phoneNumber;
      

      AppLogger.log("📦 PhoneNumber: ${phoneNumber}}");

      if (userId == null && phoneNumber == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url =
          "${ApiService.prodEndpointBookings}/unserviced_bookings?search_filter=254746029036";
      final response = await _apiService.post(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }

  //Fetch Completed bookings
  Future<List<Booking>> fetchCompletedBookings() async {
    try {
      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final token = userModel?.token;

      final url = "${ApiService.prodEndpointBookings}/complete/customer/$userId";

      final response = await _apiService.get(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
      final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

      // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }

      // Extract the list of Booking objects directly
      final bookingsJson = allBookingsResponse.data!.pBooking!;

      AppLogger.log("📦 BOOKINGS COUNT: ${bookingsJson.length}");
      return bookingsJson;
    } catch (e) {
      // Use ErrorHandler to format the message properly
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllBookings: $message");
      throw Exception(message);
    }
  }
}

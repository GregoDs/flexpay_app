import 'package:flexpay/exports.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';

class BookingsRepository {
  final ApiService _apiService = ApiService();

  /// Fetch all bookings for a given user
  Future<List<Booking>> fetchAllBookings(String userId) async {
    try {
      final url = "${ApiService.prodEndpointBookings}/customer/$userId";

      // Get user token (authorization handled inside ApiService)
      final userModel = await SharedPreferencesHelper.getUserModel();
      final token = userModel?.token;

      final response = await _apiService.post(
        url,
        requiresAuth: true,
        token: token,
      );

      // The API wraps data inside a "data" field
       final allBookingsResponse = AllBookingsResponse.fromJson(response.data);

       // If wrapper/data/pBooking is missing, return empty list
      if (allBookingsResponse.data?.pBooking?.data == null) {
        AppLogger.log("❌ No bookings found in response.");
        return [];
      }
       

      //Extract the list of Booking objects
      final bookingsJson = allBookingsResponse.data!.pBooking!.data!;

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
import 'dart:convert';
import 'package:flexpay/features/flexchama/models/chama_profile_model/chama_profile_model.dart';
import 'package:flexpay/features/flexchama/models/chama_savings_model/chama_savings_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';

class ChamaRepo {
  final ApiService _apiService = ApiService();

  /// Fetch the chama user profile for the logged-in user.
  Future<ChamaProfile?> fetchChamaUserProfile() async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final phoneNumber = userModel?.user.phoneNumber;
      // final phoneNumber = "254706622071";

      if (phoneNumber == null || phoneNumber.isEmpty) {
        throw Exception("User phone number not found in storage.");
      }

      AppLogger.log("📞 Fetching Chama profile for phone: $phoneNumber");

      final url = "${ApiService.prodEndpointChama}/get-user/$phoneNumber";
      final response = await _apiService.get(url);

      // ✅ 3. Parse into response model
      final chamaProfileResponse = ChamaProfileResponse.fromJson(response.data);

      // ✅ 4. Check for errors
      if (chamaProfileResponse.errors != null &&
          chamaProfileResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${chamaProfileResponse.errors}");
        throw Exception(
          chamaProfileResponse.firstError ??
              "Unknown error fetching Chama profile",
        );
      }

      // ✅ 5. Check if profile exists
      final chamaProfile = chamaProfileResponse.profile;

      if (chamaProfile == null) {
        AppLogger.log("❌ No valid Chama profile found.");
        return null;
      }

      // ✅ Pretty-print profile JSON for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(chamaProfile.toJson());
      AppLogger.log("📦 Parsed Chama Profile:\n$prettyJson");

      return chamaProfile;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchChamaUserProfile: $message");
      throw Exception(message);
    }
  }

/// Fetch the Chama savings for the logged-in user.
Future<ChamaSavingsResponse?> fetchUserChamaSavings() async {
  try {
    final userModel = await SharedPreferencesHelper.getUserModel();
    // final phoneNumber = userModel?.user.phoneNumber;
    final phoneNumber = "254707968841";

    if (phoneNumber == null || phoneNumber.isEmpty) {
      throw Exception("User phone number not found in storage.");
    }

    AppLogger.log("📞 Fetching User Chama savings for phone: $phoneNumber");

    final url = "${ApiService.prodEndpointChama}/user-savings/$phoneNumber";
    final response = await _apiService.get(url);

    // ✅ Parse into response model
    final chamaSavingsResponse = ChamaSavingsResponse.fromJson(response.data);

    // ✅ Check for backend errors
    if (chamaSavingsResponse.errors != null &&
        chamaSavingsResponse.errors!.isNotEmpty) {
      AppLogger.log("⚠️ Backend errors: ${chamaSavingsResponse.errors}");
      throw Exception(
        chamaSavingsResponse.errors!.first.toString(),
      );
    }

    // ✅ Extract ChamaDetails for easier usage
    final chamaDetails = chamaSavingsResponse.data?.chamaDetails;

    if (chamaDetails == null) {
      AppLogger.log("❌ No valid Chama savings found.");
      return null;
    }

    // ✅ Pretty-print ChamaDetails JSON for debugging
    final prettyJson = const JsonEncoder.withIndent('  ').convert(chamaDetails.toJson());
    AppLogger.log("📦 Parsed Chama Savings:\n$prettyJson");

    return chamaSavingsResponse; // return full response for reusability
  } catch (e) {
    final message = ErrorHandler.handleGenericError(e);
    AppLogger.log("❌ Error in fetchUserChamaSavings: $message");
    throw Exception(message);
  }
}
}

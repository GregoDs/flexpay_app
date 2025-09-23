import 'dart:convert';
import 'package:flexpay/features/flexchama/models/chama_profile_model/chama_profile_model.dart';
import 'package:flexpay/features/flexchama/models/chama_reg_model/chama_reg_model.dart';
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
      // final phoneNumber = "254706622073";

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

  /// FETCH CHAMA SAVINGS ///
  Future<ChamaSavingsResponse> fetchUserChamaSavings() async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final phoneNumber = userModel?.user.phoneNumber;
      // final phoneNumber = "0706622077";

      if (phoneNumber != null) {
        AppLogger.log("User phone number not found.");
      }
      AppLogger.log("📞 Fetching User Chama savings for phone: $phoneNumber");

      final url = "${ApiService.prodEndpointChama}/user-savings/$phoneNumber";
      final response = await _apiService.get(url);

      // ✅ Parse into response model
      final chamaSavingsResponse = ChamaSavingsResponse.fromJson(response.data);

      // 400: No member product → safe default
      final isEmptyResponse =
          chamaSavingsResponse.statusCode == 400 ||
          chamaSavingsResponse.data?.chamaDetails == null;

      if (isEmptyResponse) {
        AppLogger.log("ℹ️ No valid savings found. Returning empty defaults.");
        return ChamaSavingsResponse.empty(
          errorMessage: chamaSavingsResponse.errors?.first,
          statusCode: chamaSavingsResponse.statusCode,
        );
      }

      // If success is false but not 400 → show snackbar
      if (chamaSavingsResponse.success == false) {
        AppLogger.log(
          "⚠️ Non-400 error: ${chamaSavingsResponse.errors?.first}",
        );
        // propagate the error in the response so BlocListener can show snackbar
        return ChamaSavingsResponse.empty(
          errorMessage: chamaSavingsResponse.errors?.first ?? "Unknown error",
          statusCode: chamaSavingsResponse.statusCode,
        );
      }

      // ✅ Extract ChamaDetails for easier usage
      final chamaDetails = chamaSavingsResponse.data?.chamaDetails;
      if (chamaDetails == null) {
        AppLogger.log("❌ No valid Chama savings found.");
      }
      // ✅ Pretty-print ChamaDetails JSON for debugging
      final prettyJson = chamaSavingsResponse.data?.chamaDetails != null
          ? const JsonEncoder.withIndent(
              '  ',
            ).convert(chamaSavingsResponse.data!.chamaDetails.toJson())
          : null;
      if (prettyJson != null) {
        AppLogger.log("📦 Parsed Chama Savings:\n$prettyJson");
      }

      //if its a normal case return full response
      return chamaSavingsResponse;

    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchUserChamaSavings: $message");
      return ChamaSavingsResponse.empty(errorMessage: message);
    }
  }

  /// Registers a new Chama user
  Future<ChamaRegistrationResponse> registerChamaUser({
    required String firstName,
    required String lastName,
    required String idNumber,
    required String phoneNumber,
    String? dob,
    required String gender, // "Male" or "Female"
  }) async {
    try {
      AppLogger.log("📤 Registering Chama user: $firstName $lastName");

      final url = "${ApiService.prodEndpointChama}/join";

      // Prepare request body
      final body = {
        "first_name": firstName,
        "last_name": lastName,
        "id_number": idNumber,
        // "phone_number": phoneNumber,
        "phone_number": "0706622077",
        "dob": dob ?? "",
        "gender": gender.toLowerCase() == "male" ? 1 : 2,
      };

      final response = await _apiService.post(url, data: body);

      // Parse response
      final registrationResponse = ChamaRegistrationResponse.fromJson(
        response.data,
      );

      // Check for errors
      if (registrationResponse.errors.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${registrationResponse.errors}");
        throw Exception(registrationResponse.errors.first.toString());
      }

      // Pretty-print for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(registrationResponse.toJson());
      AppLogger.log("📦 Registration Response:\n$prettyJson");

      return registrationResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in registerChamaUser: $message");
      throw Exception(message);
    }
  }
}

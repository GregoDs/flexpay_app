import 'dart:convert'; 
import 'dart:developer' as AppLogger; 
import 'package:flexpay/features/home/models/home_transactions_model/transactions_model.dart';
import 'package:flexpay/features/home/models/home_wallet_model/wallet_model.dart';
import 'package:flexpay/features/home/models/referral_model/referral_model.dart';
import 'package:flexpay/features/payments/models/voucher_model/voucher_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';

class HomeRepo {
  final ApiService _apiService;

  HomeRepo(this._apiService);

  /// --- GET USER'S WALLET --- ///
  Future<WalletResponse> getUserWallet() async {
    try {
      AppLogger.log("📥 Fetching user’s own wallet details...");

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in shared preferences");
      }

      final url = "${ApiService.prodEndpointWallet}/wallet/$userId";

      final response = await _apiService.get(url);

      // Parse backend response into WalletResponse model
      final walletResponse = WalletResponse.fromJson(response.data);

      if (walletResponse.errors != null && walletResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${walletResponse.errors}");
        throw Exception(walletResponse.errors!.first.toString());
      }

      // Pretty print JSON for debugging
      final prettyJson = const JsonEncoder.withIndent('  ')
          .convert(walletResponse.toJson());
      AppLogger.log("📦 User Wallet Response:\n$prettyJson");

      return walletResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in getUserWallet: $message\n$stack");
      throw (message);
    }
  }

  /// --- GET LATEST TRANSACTIONS --- ///
  Future<LatestTransactionsResponse> getLatestTransactions() async {
    try {
      AppLogger.log("📥 Fetching user’s latest transactions...");

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in shared preferences");
      }

      final url =
          "${ApiService.prodEndpointBookingsTransactions}/transactions/latest/$userId";

      final response = await _apiService.get(url);

      // Parse backend response into LatestTransactionsResponse model
      final latestTransactionsResponse =
          LatestTransactionsResponse.fromJson(response.data);

      if (latestTransactionsResponse.errors.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${latestTransactionsResponse.errors}");
        throw Exception(latestTransactionsResponse.errors.first.toString());
      }

      // Pretty print JSON for debugging
      final prettyJson = const JsonEncoder.withIndent('  ')
          .convert(latestTransactionsResponse.toJson());
      AppLogger.log("📦 User Latest Transactions Response:\n$prettyJson");

      return latestTransactionsResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in getLatestTransactions: $message\n$stack");
      throw (message);
    }
  }


  /// --- MAKE REFERRAL --- ///
  Future<ReferralResponse> makeReferral(String phoneNumber) async {
    try {
      AppLogger.log("📤 Making referral for phone number: $phoneNumber");

      final url = "${ApiService.prodEndpointChama}/refer";

      final body = {
        "phone_number": phoneNumber,
      };

      final response = await _apiService.post(url, data: body);

      // Parse backend response into ReferralResponse
      final referralResponse = ReferralResponse.fromJson(response.data);

      // Handle backend errors if they exist
      if (referralResponse.errors != null && referralResponse.errors!.isNotEmpty) {
        AppLogger.log("⚠️ Backend errors: ${referralResponse.errors}");
        throw Exception(referralResponse.errors!.first.toString());
      }

      // Pretty print JSON for debugging
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(referralResponse.toJson());
      AppLogger.log("📦 Referral Response:\n$prettyJson");

      return referralResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in makeReferral: $message\n$stack");
      throw (message);
    }
  }
}
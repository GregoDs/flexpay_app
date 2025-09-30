import 'dart:convert'; // for JsonEncoder
import 'dart:developer' as AppLogger; // better than importing math :)
import 'package:flexpay/features/home/models/home_transactions_model/transactions_model.dart';
import 'package:flexpay/features/home/models/home_wallet_model/wallet_model.dart';
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
      throw Exception(message);
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
      throw Exception(message);
    }
  }
}
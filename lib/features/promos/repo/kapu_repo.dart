import 'dart:developer' as AppLogger;

import 'package:flexpay/features/promos/models/kapu_balance_model/kapu_wallet_models.dart';
import 'package:flexpay/features/promos/models/kapu_booking_model/kapu_booking_model.dart';
import 'package:flexpay/features/promos/models/kapu_debit_model/kapu_debit_model.dart';
import 'package:flexpay/features/promos/models/kapu_transfer_model/kapu_transfer_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flexpay/utils/services/error_handler.dart';

class KapuRepo {
  final ApiService _apiService;

  KapuRepo(this._apiService);

  /// --- REQUEST Merchant Wallet Balances --- ///
  Future<KapuWalletBalances> requestKapuWalletBalances({
    required String merchantId,
  }) async {
    try {
      AppLogger.log("📤 Fetching Kapu Wallet balance for merchant: $merchantId ...");

      final url = "${ApiService.prodEndpointKapuWallet}/balance";

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in storage.");
      }

      // Build request body
      final payload = {
        "user_id": userId,
        "merchant_id": merchantId,
      };

      AppLogger.log("📦 Kapu Wallet Payload: $payload");

      // Send POST request
      final response = await _apiService.post(url, data: payload);

      // Parse the response into your model
      final kapuWalletResponse = KapuWalletBalances.fromJson(response.data);

      AppLogger.log("✅ Wallet Response: ${kapuWalletResponse.toJson()}");

      return kapuWalletResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in requestKapuWalletBalances: $message\n$stack");
      throw (message);
    }
  }

  /// --- TRANSFER FUNDS BETWEEN WALLETS --- ///
  Future<KapuTransferModel> transferFunds({
    required String fromMerchantId,
    required String toMerchantId,
    required double amount,
  }) async {
    try {
      AppLogger.log("📤 Initiating fund transfer...");

      final url = "${ApiService.prodEndpointKapuWallet}/transfer";

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in storage.");
      }

      // Construct transfer payload
      final payload = {
        "user_id": userId,
        "from_merchant_id": fromMerchantId,
        "to_merchant_id": toMerchantId,
        "amount": amount,
      };

      AppLogger.log("📦 Transfer Payload: $payload");

      final response = await _apiService.post(url, data: payload);

      // Parse into KapuTransferModel
      final transferResponse = KapuTransferModel.fromJson(response.data);

      AppLogger.log("✅ Transfer Response: ${transferResponse.toJson()}");

      return transferResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in transferFunds: $message\n$stack");
      throw (message);
    }
  }

  /// --- DEBIT WALLET --- ///
  Future<DebitResponseModel> debitWallet({
    required String merchantId,
    required double amount,
  }) async {
    try {
      AppLogger.log("💸 Debiting wallet for merchant: $merchantId ...");

      final url = "${ApiService.prodEndpointKapuWallet}/debit";

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in storage.");
      }

      // Construct debit payload
      final payload = {
        "user_id": userId,
        "merchant_id": merchantId,
        "amount": amount,
      };

      AppLogger.log("📦 Debit Payload: $payload");

      final response = await _apiService.post(url, data: payload);

      // Parse into DebitResponseModel
      final debitResponse = DebitResponseModel.fromJson(response.data);

      AppLogger.log("✅ Debit Response: ${debitResponse.toJson()}");

      return debitResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in debitWallet: $message\n$stack");
      throw (message);
    }
  }

  /// --- CREATE KAPU MERCHANT BOOKING --- ///
  Future<KapuBookingResponse> createKapuBooking({
    required String merchantId,
  }) async {
    try {
      AppLogger.log("🧾 Creating Kapu Merchant Booking with merchantId: $merchantId ...");

      final url = "${ApiService.prodEndpointBookingsKapu}/create-merchant-booking";

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in storage.");
      }

      // Construct booking payload
      final payload = {
        "user_id": userId,
        "merchant_id": merchantId,
        "booking_source": "app"
      };

      AppLogger.log("📦 Booking Payload: $payload");

      // Send POST request
      final response = await _apiService.post(url, data: payload);

      // Parse into KapuBookingResponse model
      final bookingResponse = KapuBookingResponse.fromJson(response.data);

      AppLogger.log("✅ Booking Response: ${bookingResponse.toJson()}");

      return bookingResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in createKapuBooking: $message\n$stack");
      throw (message);
    }
  }
}
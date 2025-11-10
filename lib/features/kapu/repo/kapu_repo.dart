import 'dart:developer' as AppLogger;

import 'package:flexpay/features/kapu/models/kapu_balance_model/all_wallets_model.dart';
import 'package:flexpay/features/kapu/models/kapu_balance_model/kapu_wallet_models.dart';
import 'package:flexpay/features/kapu/models/kapu_booking_model/kapu_booking_model.dart';
import 'package:flexpay/features/kapu/models/kapu_debit_model/kapu_debit_model.dart';
import 'package:flexpay/features/kapu/models/kapu_shops/kapu_shops_model.dart';
import 'package:flexpay/features/kapu/models/kapu_topup_model/kapu_topup_model.dart';
import 'package:flexpay/features/kapu/models/kapu_transfer_model/kapu_transfer_model.dart';
import 'package:flexpay/features/kapu/models/kapu_voucher_model/kapu_voucher_model.dart';
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
      AppLogger.log(
        "📤 Fetching Kapu Wallet balance for merchant: $merchantId ...",
      );

      final url = "${ApiService.prodEndpointKapuWallet}/balance";

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in storage.");
      }

      // Build request body
      final payload = {"user_id": userId, "merchant_id": merchantId};

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


    /// --- FETCH ALL USER WALLETS (KAPU) --- Fetches all the wallet balances at once and not one by one like the above repo method ///
  Future<AllWalletsKapuModel> fetchAllKapuWalletsInstantly() async {
    try {
      AppLogger.log("💼 Fetching all user Kapu wallets...");

      final url = "${ApiService.prodEndpointKapuWallet}/user-wallets";

      // Retrieve stored user info
      final userModel = await SharedPreferencesHelper.getUserModel();
      // final userId = userModel?.user.id;
      final userId = '22';

      if (userId == null) {
        throw Exception("User ID not found in storage.");
      }

      // Construct payload
      final payload = {"user_id": userId};

      AppLogger.log("📦 Wallets Payload: $payload");

      // Make the POST request
      final response = await _apiService.post(url, data: payload);

      AppLogger.log("📩 Raw Wallets Response: ${response.data}");

      // Parse into AllWalletsKapuModel
      final walletsResponse = AllWalletsKapuModel.fromJson(response.data);

      // Optional validation
      if (walletsResponse.data.isEmpty) {
        AppLogger.log("⚠️ No wallets found for this user.");
      }

      AppLogger.log("✅ Parsed Wallets Response: ${walletsResponse.toJson()}");

      return walletsResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchAllKapuWallets: $message\n$stack");
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
      AppLogger.log(
        "🧾 Creating Kapu Merchant Booking with merchantId: $merchantId ...",
      );

      final url =
          "${ApiService.prodEndpointBookingsKapu}/create-merchant-booking";

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in storage.");
      }

      // Construct booking payload
      final payload = {
        "user_id": userId,
        "merchant_id": merchantId,
        "booking_source": "app",
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

  /// --- CREATE KAPU VOUCHER --- ///
Future<CreateVoucherResponse> createKapuVoucher({
  required String merchantId,
  required String outletId,
  required double amount,
}) async {
  try {
    AppLogger.log(
      "🎟️ Creating new Kapu voucher for merchant: $merchantId and outlet: $outletId ...",
    );

    final url = "${ApiService.prodEndpointBookingsKapu}/create-merchant-voucher";

    // Retrieve user ID from local storage
    final userModel = await SharedPreferencesHelper.getUserModel();
    final userId = userModel?.user.id;

    if (userId == null) {
      throw Exception("User ID not found in storage.");
    }

    // Construct payload with new outlet_id
    final payload = {
      "user_id": userId,
      "merchant_id": merchantId,
      "outlet_id": outletId,
      "amount": amount,
    };

    AppLogger.log("📦 Voucher Payload: $payload");

    final response = await _apiService.post(url, data: payload);

    AppLogger.log("🧩 Raw Response: ${response.data}");

    final voucherResponse = CreateVoucherResponse.fromJson(response.data);

    AppLogger.log("✅ Voucher Response Parsed: ${voucherResponse.toJson()}");

    return voucherResponse;
  } catch (e, stack) {
    final message = ErrorHandler.handleGenericError(e);
    AppLogger.log("❌ Error in createVoucher: $message\n$stack");
    throw (message);
  }
}

  //PAY FOR Kapu VIA stk push
  Future<KapuTopUpResponse> topUpKapuStk(
    double amount,
    String phoneNumber,
    BookingData booking,
  ) async {
    try {
      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      final bookingReference = booking.bookingReference;

      if (bookingReference == null || bookingReference.isEmpty) {
        throw Exception("Booking reference cannot be empty");
      }

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final url = "${ApiService.prodEndpointPayments}/stk_request";

      final body = {
        "user_id": userId,
        "reference": bookingReference,
        "amount": amount,
        "phone": phoneNumber,
        "description": "Kapu Wallet Top up payment",
      };

      // ✅ Make the POST request with the body
      final response = await _apiService.post(
        url,
        requiresAuth: true,
        data: body,
      );

      // ✅ Parse response into model
      final kapuMpesaPaymentResponse = KapuTopUpResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      AppLogger.log(
        "📦 Mpesa payment response: ${kapuMpesaPaymentResponse.toJson()}",
      );

      // ✅ Return parsed response
      return kapuMpesaPaymentResponse;
    } catch (e) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in making mpesa payment: $message");
      throw Exception(message);
    }
  }

  /// --- FETCH KAPU SHOPS --- ///
  Future<OutletResponse> fetchKapuShops({required String merchantId}) async {
    try {
      AppLogger.log("🏬 Fetching Kapu Shops for merchantId: $merchantId ...");

      final url = "${ApiService.prodEndpointKapuWalletShops}/outlet-list?search_filter=";

      final userModel = await SharedPreferencesHelper.getUserModel();
      final userId = userModel?.user.id;

      if (userId == null) {
        throw Exception("User ID not found in storage.");
      }

      // Construct payload
      final payload = {"user_id": userId, "merchant_id": merchantId };

      AppLogger.log("📦 Fetch Shops Payload: $payload");

      // Send POST request
      final response = await _apiService.post(url, data: payload);

      // Log the raw response data
      AppLogger.log("📩 Raw Response Data: ${response.data}");

      // Validate response structure
      if (response.data == null || response.data.isEmpty) {
        throw Exception("API response data is null or empty.");
      }

      // Parse into OutletResponse model with error handling
      OutletResponse outletResponse;
      try {
        outletResponse = OutletResponse.fromJson(response.data);
      } catch (e) {
        AppLogger.log("❌ Error parsing OutletResponse: $e");
        throw Exception("Failed to parse OutletResponse.");
      }

      // Validate parsed data
      if (outletResponse.data == null) {
        throw Exception("Parsed OutletResponse data is null.");
      }

      AppLogger.log("✅ Parsed OutletResponse: ${outletResponse.toJson()}");

      return outletResponse;
    } catch (e, stack) {
      final message = ErrorHandler.handleGenericError(e);
      AppLogger.log("❌ Error in fetchKapuShops: $message\n$stack");
      throw (message);
    }
  }
}

import 'dart:async';
import 'dart:developer' as AppLogger;
import 'package:bloc/bloc.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/kapu/models/kapu_balance_model/kapu_wallet_models.dart';
import 'package:flexpay/features/kapu/models/kapu_booking_model/kapu_booking_model.dart';
import 'package:flexpay/features/kapu/models/kapu_shops/kapu_shops_model.dart';
import 'package:flexpay/features/kapu/models/kapu_topup_model/kapu_topup_model.dart';
import 'package:flexpay/features/kapu/repo/kapu_repo.dart';
import 'package:async/async.dart';

class KapuCubit extends Cubit<KapuState> {
  final KapuRepo _kapuRepo;
  final List<CancelableOperation> _ongoingOperations = [];

  OutletResponse? outletResponse;

  KapuCubit(this._kapuRepo) : super(KapuWalletInitial());

  @override
  Future<void> close() {
    // Cancel all ongoing operations before closing the Cubit
    for (final operation in _ongoingOperations) {
      operation.cancel();
    }
    return super.close();
  }

  /// ---------------- FETCH WALLET BALANCE ---------------- ///
  Future<void> fetchKapuWalletBalance(String merchantId) async {
    emit(KapuWalletLoading());
    try {
      AppLogger.log("🔍 Fetching balance for merchant: $merchantId");

      final response = await _kapuRepo.requestKapuWalletBalances(
        merchantId: merchantId,
      );

      AppLogger.log("✅ Kapu wallet fetched successfully for $merchantId");

      emit(KapuWalletFetched(response, merchantId));
    } catch (e, stack) {
      AppLogger.log("❌ Kapu wallet fetch failed: $e\n$stack");
      emit(KapuWalletFailure(e.toString()));
    }
  }

  /// ---------------- FETCH MULTIPLE WALLET BALANCES ---------------- ///
  Future<List<KapuWalletBalances>> fetchMultipleKapuWalletBalances(
    List<String> merchantIds,
  ) async {
    emit(KapuWalletLoading());
    try {
      AppLogger.log("🧠 Fetching balances for all merchants: $merchantIds");

      final futures = merchantIds.map(
        (id) {
          final operation = CancelableOperation.fromFuture(
            _kapuRepo.requestKapuWalletBalances(merchantId: id),
          );
          _ongoingOperations.add(operation);
          return operation.value;
        },
      );

      final responses = await Future.wait<KapuWalletBalances>(futures);

      AppLogger.log("✅ All merchant wallets fetched successfully");

      emit(KapuWalletListFetched(responses));
      return responses;
    } catch (e, stack) {
      AppLogger.log("❌ Error fetching multiple wallets: $e\n$stack");
      emit(KapuWalletFailure(e.toString()));
      rethrow;
    }
  }

  /// ---------------- TRANSFER WALLET FUNDS ---------------- ///
  Future<void> transferFunds({
    required String fromMerchantId,
    required String toMerchantId,
    required double amount,
  }) async {
    emit(KapuTransferLoading());
    try {
      AppLogger.log(
        "💸 Starting transfer from $fromMerchantId → $toMerchantId | Amount: $amount",
      );

      final response = await _kapuRepo.transferFunds(
        fromMerchantId: fromMerchantId,
        toMerchantId: toMerchantId,
        amount: amount,
      );

      if (response.success) {
        AppLogger.log("✅ Transfer completed successfully.");
        emit(KapuTransferSuccess(response));
      } else {
        AppLogger.log("⚠️ Transfer failed.");
        emit(KapuTransferFailure("Transfer failed"));
      }
    } catch (e, stack) {
      AppLogger.log("❌ Transfer API call failed: $e\n$stack");
      emit(KapuTransferFailure(e.toString()));
    }
  }

  /// ---------------- DEBIT WALLET ---------------- ///
  Future<void> debitWallet({
    required String merchantId,
    required double amount,
  }) async {
    emit(KapuDebitLoading());
    try {
      AppLogger.log(
        "💳 Debiting wallet for merchant: $merchantId | Amount: $amount",
      );

      final response = await _kapuRepo.debitWallet(
        merchantId: merchantId,
        amount: amount,
      );

      if (response.success) {
        AppLogger.log("✅ Wallet debit successful");
        emit(KapuDebitSuccess(response));
      } else {
        AppLogger.log("⚠️ Wallet debit failed");
        emit(KapuDebitFailure("Wallet debit failed"));
      }
    } catch (e, stack) {
      AppLogger.log("❌ Debit API call failed: $e\n$stack");
      emit(KapuDebitFailure(e.toString()));
    }
  }

  /// ---------------- CREATE KAPU BOOKING ---------------- ///
  Future<BookingData?> createKapuBooking({required String merchantId}) async {
    emit(KapuBookingLoading());
    try {
      AppLogger.log("🧾 Creating Kapu booking for merchant: $merchantId");

      final KapuBookingResponse response = await _kapuRepo.createKapuBooking(
        merchantId: merchantId,
      );

      if (response.success && response.data != null) {
        final booking = response.data!;

        AppLogger.log(
          "✅ Booking successfully created: ${booking.bookingReference} | ID: ${booking.id}",
        );

        emit(KapuBookingSuccess(response));
        return booking;
      } else {
        final errors =
            response.errors?.map((e) => e.toString()).join(", ") ??
            "Booking creation failed";
        AppLogger.log(
          "⚠️ Booking creation failed: $errors | Status: ${response.statusCode}",
        );
        emit(KapuBookingFailure(errors));
        return null;
      }
    } catch (e, stack) {
      AppLogger.log("❌ Booking API call failed: $e\n$stack");
      emit(KapuBookingFailure(e.toString()));
      return null;
    }
  }

  /// ---------------- CREATE KAPU VOUCHER ---------------- ///
  Future<void> createKapuVoucher({
    required String merchantId,
    required String outletId, // ✅ Added outletId parameter
    required double amount,
  }) async {
    emit(KapuVoucherLoading());
    try {
      AppLogger.log(
        "🎟️ Creating Kapu voucher for merchant: $merchantId | Outlet: $outletId | Amount: $amount",
      );

      final response = await _kapuRepo.createKapuVoucher(
        merchantId: merchantId,
        outletId: outletId, // ✅ Pass outletId to the repository method
        amount: amount,
      );

      final innerSuccess = response.data?.success ?? false;
      final hasInnerErrors = (response.data?.errors?.isNotEmpty ?? false);
      final allErrors = response.collectAllErrors();

      final isFlatVoucherSuccess =
          response.success &&
          !hasInnerErrors &&
          response.data?.data == null &&
          response.data != null &&
          response.statusCode == 200;

      if ((response.success && innerSuccess && !hasInnerErrors) ||
          isFlatVoucherSuccess) {
        final ref = response.data?.data?.bookingReference ?? "N/A";

        AppLogger.log("✅ Voucher created successfully — Ref: $ref");
        emit(KapuVoucherSuccess(response));
      } else {
        final errorMessage = allErrors.isNotEmpty
            ? allErrors.join(", ")
            : "Voucher creation failed (code: ${response.data?.statusCode ?? response.statusCode})";

        AppLogger.log("⚠️ Voucher creation failed: $errorMessage");
        emit(KapuVoucherFailure(errorMessage));
      }
    } catch (e, stack) {
      AppLogger.log("❌ Voucher API call failed: $e\n$stack");
      emit(KapuVoucherFailure(e.toString()));
    }
  }

  /// ---------------- TOP-UP KAPU WALLET ---------------- ///
  Future<void> topUpKapuWallet({
    required double amount,
    required String phoneNumber,
    required BookingData booking,
  }) async {
    emit(KapuTopUpLoading());
    try {
      AppLogger.log(
        "💳 Initiating Kapu wallet top-up | Amount: $amount | Phone: $phoneNumber | BookingRef: ${booking.bookingReference}",
      );

      final KapuTopUpResponse response = await _kapuRepo.topUpKapuStk(
        amount,
        phoneNumber,
        booking,
      );

      final isApiSuccess =
          response.success == true ||
          response.data?.checkoutRequestID != null ||
          response.checkoutRequestID != null;

      if (isApiSuccess) {
        final checkoutId =
            response.data?.checkoutRequestID ?? response.checkoutRequestID;
        AppLogger.log(
          "✅ Kapu top-up successful | CheckoutRequestID: $checkoutId",
        );
        emit(KapuTopUpSuccess(response));
      } else {
        final errors = response.errors?.values.expand((e) => e).toList() ?? [];
        final message = errors.isNotEmpty
            ? errors.join(", ")
            : "Kapu top-up failed (unknown reason)";
        AppLogger.log("⚠️ Kapu top-up failed: $message");
        emit(KapuTopUpFailure(message));
      }
    } catch (e, stack) {
      AppLogger.log("❌ Kapu top-up API call failed: $e\n$stack");
      emit(KapuTopUpFailure(e.toString()));
    }
  }

  /// ---------------- FETCH KAPU SHOPS ---------------- ///
  Future<void> fetchKapuShops(String merchantId) async {
    emit(KapuShopsLoading());
    try {
      AppLogger.log("🔍 Fetching shops for merchant: $merchantId");

      final response = await _kapuRepo.fetchKapuShops(merchantId: merchantId);

      // ✅ store the result for use in TypeAheadField
      outletResponse = response;

      AppLogger.log("✅ Kapu shops fetched successfully for $merchantId");

      emit(KapuShopsFetched(response));
    } catch (e, stack) {
      AppLogger.log("❌ Kapu shops fetch failed: $e\n$stack");
      emit(KapuShopsFailure(e.toString()));
    }
  }

  /// ---------------- FETCH ALL WALLETS INSTANTLY It brings all the wallets at an instant instead of one by one like the above methods ---------------- ///
  Future<void> fetchAllKapuWalletsInstantly() async {
    emit(KapuAllWalletsInstantlyLoading());
    try {
      AppLogger.log("🔍 Fetching all Kapu wallets instantly...");

      final response = await _kapuRepo.fetchAllKapuWalletsInstantly();

      AppLogger.log("✅ All Kapu wallets fetched instantly.");

      emit(KapuAllWalletsInstantlyFetched(response));
    } catch (e, stack) {
      AppLogger.log("❌ Fetching all Kapu wallets instantly failed: $e\n$stack");
      emit(KapuAllWalletsInstantlyFailure(e.toString()));
    }
  }
}

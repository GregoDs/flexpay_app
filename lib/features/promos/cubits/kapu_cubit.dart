import 'dart:developer' as AppLogger;
import 'package:bloc/bloc.dart';
import 'package:flexpay/features/promos/cubits/kapu_state.dart';
import 'package:flexpay/features/promos/repo/kapu_repo.dart';

class KapuCubit extends Cubit<KapuState> {
  final KapuRepo _kapuRepo;

  KapuCubit(this._kapuRepo) : super(KapuWalletInitial());

  /// ---------------- FETCH WALLET BALANCE ---------------- ///
  Future<void> fetchKapuWalletBalance(String merchantId) async {
    emit(KapuWalletLoading());
    try {
      AppLogger.log("🔍 Fetching balance for merchant: $merchantId");

      final response =
          await _kapuRepo.requestKapuWalletBalances(merchantId: merchantId);

      AppLogger.log("✅ Kapu wallet fetched successfully for $merchantId");

      emit(KapuWalletFetched(response, merchantId));
    } catch (e, stack) {
      AppLogger.log("❌ Kapu wallet fetch failed: $e\n$stack");
      emit(KapuWalletFailure(e.toString()));
    }
  }

  /// ---------------- FETCH MULTIPLE WALLET BALANCES ---------------- ///
  Future<void> fetchMultipleKapuWalletBalances(List<String> merchantIds) async {
    emit(KapuWalletLoading());
    try {
      AppLogger.log("🧠 Fetching balances for all merchants: $merchantIds");

      final futures = merchantIds.map(
        (id) => _kapuRepo.requestKapuWalletBalances(merchantId: id),
      );

      final responses = await Future.wait(futures);

      AppLogger.log("✅ All merchant wallets fetched successfully");

      emit(KapuWalletListFetched(responses));
    } catch (e, stack) {
      AppLogger.log("❌ Error fetching multiple wallets: $e\n$stack");
      emit(KapuWalletFailure(e.toString()));
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
      AppLogger.log("💸 Starting transfer from $fromMerchantId → $toMerchantId | Amount: $amount");

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
      AppLogger.log("💳 Debiting wallet for merchant: $merchantId | Amount: $amount");

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
  Future<void> createKapuBooking({
    required String merchantId,
  }) async {
    emit(KapuBookingLoading());
    try {
      AppLogger.log("🧾 Creating Kapu booking for merchant: $merchantId");

      final response = await _kapuRepo.createKapuBooking(
        merchantId: merchantId,
      );

      if (response.success) {
        AppLogger.log("✅ Booking successfully created: ${response.data?.bookingReference}");
        emit(KapuBookingSuccess(response));
      } else {
        AppLogger.log("⚠️ Booking creation failed with status ${response.statusCode}");
        emit(KapuBookingFailure("Booking creation failed"));
      }
    } catch (e, stack) {
      AppLogger.log("❌ Booking API call failed: $e\n$stack");
      emit(KapuBookingFailure(e.toString())); 
    }
  }

  /// ---------------- CREATE KAPU VOUCHER ---------------- ///
Future<void> createKapuVoucher({
  required String merchantId,
  required double amount,
}) async {
  emit(KapuVoucherLoading());
  try {
    AppLogger.log("🎟️ Creating Kapu voucher for merchant: $merchantId | Amount: $amount");

    final response = await _kapuRepo.createKapuVoucher(
      merchantId: merchantId,
      amount: amount,
    );

    final innerSuccess = response.data?.success ?? false;
    final hasInnerErrors = (response.data?.errors?.isNotEmpty ?? false);
    final allErrors = response.collectAllErrors();

    // ✅ Detect flat success (when data contains actual voucher fields directly)
    final isFlatVoucherSuccess =
        response.success &&
        !hasInnerErrors &&
        response.data?.data == null && // means no nested structure
        response.data != null &&
        response.statusCode == 200;

    // ✅ Normal nested success OR flat success
    if ((response.success && innerSuccess && !hasInnerErrors) || isFlatVoucherSuccess) {
      final ref = response.data?.data?.bookingReference ??
          (response.data?.data == null
              ? (response.data?.data?.bookingReference ?? "N/A")
              : "N/A");

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

}
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

      emit(KapuWalletFetched(response));
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
        AppLogger.log("✅ Transfer completed successfully: ${response.message}");
        emit(KapuTransferSuccess(response));
      } else {
        AppLogger.log("⚠️ Transfer failed: ${response.message}");
        emit(KapuTransferFailure(response.message));
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
        AppLogger.log("✅ Wallet debit successful: ${response.message}");
        emit(KapuDebitSuccess(response));
      } else {
        AppLogger.log("⚠️ Wallet debit failed: ${response.message}");
        emit(KapuDebitFailure(response.message));
      }
    } catch (e, stack) {
      AppLogger.log("❌ Debit API call failed: $e\n$stack");
      emit(KapuDebitFailure(e.toString()));
    }
  }
}
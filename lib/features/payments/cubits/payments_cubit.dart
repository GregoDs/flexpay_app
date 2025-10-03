import 'package:flexpay/features/payments/cubits/payments_state.dart';
import 'package:flexpay/features/payments/repo/payments_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  final PaymentsRepo _paymentsRepo;

  PaymentsCubit(this._paymentsRepo) : super(PaymentsInitial());

  /// --- REQUEST WALLET REFUND --- ///
  Future<void> requestWalletRefund(double withAmount) async {
    emit(WalletRefundLoading());

    try {
      final refundResponse =
          await _paymentsRepo.requestWalletRefund(withAmount: withAmount);

      emit(WalletRefundFetched(refundResponse));
    } catch (e) {
      emit(WalletRefundFailure(e.toString()));
    }
  }

  /// --- TOP UP WALLET VIA MPESA --- ///
  Future<void> topUpWalletViaMpesa({
    required double amount,
    required String phoneNumber,
  }) async {
    emit(WalletTopUpLoading());

    try {
      final response = await _paymentsRepo.topUpWalletViaMpesa(
        amount,
        phoneNumber,
      );

      emit(WalletTopUpSuccess(response));
    } catch (e) {
      emit(WalletTopUpFailure(e.toString()));
    }
  }

  /// --- GENERATE VOUCHER --- ///
  Future<void> generateVoucher({
    required int merchantId,
    required String voucherAmount,
  }) async {
    emit(VoucherLoading());

    try {
      final response = await _paymentsRepo.generateVoucher(
        merchantId: merchantId,
        voucherAmount: voucherAmount,
      );

      emit(VoucherSuccess(response));
    } catch (e) {
      emit(VoucherFailure(e.toString()));
    }
  }
}
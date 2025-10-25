import 'package:equatable/equatable.dart';
import 'package:flexpay/features/promos/models/kapu_balance_model/kapu_wallet_models.dart';
import 'package:flexpay/features/promos/models/kapu_transfer_model/kapu_transfer_model.dart';
import 'package:flexpay/features/promos/models/kapu_debit_model/kapu_debit_model.dart';

abstract class KapuState extends Equatable {
  const KapuState();

  @override
  List<Object?> get props => [];
}

/// ---------------- WALLET STATES ---------------- ///
class KapuStateInitial extends KapuState {}

class KapuWalletInitial extends KapuState {}

class KapuWalletLoading extends KapuState {}

class KapuWalletFetched extends KapuState {
  final KapuWalletBalances kapuWalletResponse;

  const KapuWalletFetched(this.kapuWalletResponse);

  @override
  List<Object?> get props => [kapuWalletResponse];
}

class KapuWalletListFetched extends KapuState {
  final List<KapuWalletBalances> wallets;

  const KapuWalletListFetched(this.wallets);

  @override
  List<Object?> get props => [wallets];
}

class KapuWalletFailure extends KapuState {
  final String message;

  const KapuWalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- TRANSFER STATES ---------------- ///
class KapuTransferLoading extends KapuState {}

class KapuTransferSuccess extends KapuState {
  final KapuTransferModel response;

  const KapuTransferSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuTransferFailure extends KapuState {
  final String message;

  const KapuTransferFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- DEBIT STATES ---------------- ///
class KapuDebitLoading extends KapuState {}

class KapuDebitSuccess extends KapuState {
  final DebitResponseModel response;

  const KapuDebitSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class KapuDebitFailure extends KapuState {
  final String message;

  const KapuDebitFailure(this.message);

  @override
  List<Object?> get props => [message];
}
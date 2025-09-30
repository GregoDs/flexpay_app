import 'package:equatable/equatable.dart';
import 'package:flexpay/features/home/models/home_wallet_model/wallet_model.dart';
import 'package:flexpay/features/home/models/home_transactions_model/transactions_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// ---------------- Wallet States ----------------
class HomeWalletInitial extends HomeState {}

class HomeWalletLoading extends HomeState {}

class HomeWalletFetched extends HomeState {
  final WalletResponse walletResponse;

  const HomeWalletFetched(this.walletResponse);

  @override
  List<Object?> get props => [walletResponse];
}

class HomeWalletFailure extends HomeState {
  final String message;

  const HomeWalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// ---------------- Transactions States ----------------
class HomeTransactionsInitial extends HomeState {}

class HomeTransactionsLoading extends HomeState {}

class HomeTransactionsFetched extends HomeState {
  final LatestTransactionsResponse transactionsResponse;

  const HomeTransactionsFetched(this.transactionsResponse);

  @override
  List<Object?> get props => [transactionsResponse];
}

class HomeTransactionsFailure extends HomeState {
  final String message;

  const HomeTransactionsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
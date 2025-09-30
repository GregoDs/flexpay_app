import 'package:flexpay/features/home/cubits/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpay/features/home/repo/home_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeWalletInitial());

  /// Fetch user wallet from backend
  Future<void> fetchUserWallet() async {
    emit(HomeWalletLoading());
    try {
      final walletResponse = await _homeRepo.getUserWallet();
      emit(HomeWalletFetched(walletResponse));
    } catch (e) {
      emit(HomeWalletFailure(e.toString()));
    }
  }

  /// Fetch user’s latest transactions
  Future<void> fetchLatestTransactions() async {
    emit(HomeTransactionsLoading());
    try {
      final transactionsResponse = await _homeRepo.getLatestTransactions();
      emit(HomeTransactionsFetched(transactionsResponse));
    } catch (e) {
      emit(HomeTransactionsFailure(e.toString()));
    }
  }
}
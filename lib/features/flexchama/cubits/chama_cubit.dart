import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpay/features/flexchama/repo/chama_repo.dart';
import 'chama_state.dart';

class ChamaCubit extends Cubit<ChamaState> {
  final ChamaRepo _repo;

  ChamaCubit(this._repo) : super(ChamaInitial());

  /// ---------------- Fetch Profile ----------------
  Future<void> fetchChamaUserProfile() async {
    emit(ChamaProfileLoading());
    try {
      final profile = await _repo.fetchChamaUserProfile();

      if (profile == null) {
        emit(const ChamaNotMember(
          message: "You are not a member of FlexChama. Please register.",
        ));
      } else {
        emit(ChamaProfileFetched(profile));
        // Automatically fetch savings after profile
        fetchChamaUserSavings();
      }
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains("member not found")) {
        emit(const ChamaNotMember(
          message: "You are not a member of FlexChama. Please register.",
        ));
      } else {
        emit(ChamaError(e.toString()));
      }
    }
  }

  /// ---------------- Fetch Chama User Savings details ----------------
  Future<void> fetchChamaUserSavings() async {
    emit(ChamaSavingsLoading());
    try {
      final savingsResponse = await _repo.fetchUserChamaSavings();

      if (savingsResponse == null) {
        emit(const ChamaError("No savings found for this user."));
      } else {
        emit(ChamaSavingsFetched(savingsResponse));
      }
    } catch (e) {
      emit(ChamaError(e.toString()));
    }
  }
}
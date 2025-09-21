import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpay/features/flexchama/repo/chama_repo.dart';
import 'chama_state.dart';

class ChamaCubit extends Cubit<ChamaState> {
  final ChamaRepo _repo;

  ChamaCubit(this._repo) : super(ChamaInitial());

  Future<void> fetchChamaUserProfile() async {
    emit(ChamaLoading());

    try {
  final profile = await _repo.fetchChamaUserProfile();

  if (profile == null) {
    emit(const ChamaNotMember(
      message: "You are not a member of FlexChama. Please register.",
    ));
  } else {
    emit(ChamaProfileFetched(profile));
  }
} catch (e) {
  final errorMsg = e.toString().toLowerCase();

  if (errorMsg.contains("member not found")) {
    emit(const ChamaNotMember(
      message: "You are not a member of FlexChama. Please register.",
    ));
  } else {
    emit(ChamaError(e.toString())); // keep raw error
  }
}
  }
}


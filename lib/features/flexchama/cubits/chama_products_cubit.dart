// chama_products_cubit.dart
import 'package:flexpay/features/flexchama/repo/chama_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpay/features/flexchama/models/chamatype_model.dart';
import 'chama_products_state.dart';

class ChamaProductsCubit extends Cubit<ChamaProductsState> {
  final ChamaRepo _chamaRepository;

  ChamaProductsCubit(this._chamaRepository)
      : super(const ChamaProductsInitial());

  Future<void> loadChamaProducts(String type) async {
    emit(const ChamaProductsLoading());

    try {
      final response = await _chamaRepository.fetchChamaProducts(type);

      emit(ChamaProductsSuccess(response.data));
    } catch (e) {
      emit(ChamaProductsError('Something went wrong: ${e.toString()}'));
    }
  }
}



import 'package:flexpay/features/flexchama/models/chamatype_model.dart';
import 'package:flexpay/utils/services/api_service.dart';

class ChamaRepo {
  final ApiService _apiService;
  ChamaRepo(this._apiService);

  Future<ChamaProductsResponse> fetchChamaProducts(String type) async {
  final response = await _apiService.post(
    '${ApiService.prodEndpointChama}/products',
    data: {'type': type},
    requiresAuth: true,
  );

  return ChamaProductsResponse.fromJson(
    response.data as Map<String, dynamic>,
  );
}

}

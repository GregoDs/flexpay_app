import 'package:flutter/foundation.dart';
import 'package:flexpay/features/flexchama/models/chamatype_model.dart';

@immutable
sealed class ChamaProductsState {
  const ChamaProductsState();
}

final class ChamaProductsInitial extends ChamaProductsState {
  const ChamaProductsInitial();
}

final class ChamaProductsLoading extends ChamaProductsState {
  const ChamaProductsLoading();
}

final class ChamaProductsSuccess extends ChamaProductsState {
  final List<ChamaProduct> products;

  const ChamaProductsSuccess(this.products);
}

final class ChamaProductsError extends ChamaProductsState {
  final String message;

  const ChamaProductsError(this.message);
}
import 'package:equatable/equatable.dart';
import 'package:flexpay/features/merchants/models/merchants_model.dart';


abstract class MerchantsState extends Equatable {
  const MerchantsState();

  @override
  List<Object?> get props => [];
}

class MerchantsInitial extends MerchantsState {}

class MerchantsLoading extends MerchantsState {}

class MerchantsFetched extends MerchantsState {
  final List<Merchant> Merchants;

  const MerchantsFetched({
    required this.Merchants,
  });

  @override
  List<Object?> get props => [Merchants];
}

class MerchantsError extends MerchantsState {
  final String message;

  const MerchantsError(this.message);

  @override
  List<Object?> get props => [message];
}
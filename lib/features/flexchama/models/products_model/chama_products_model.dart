import 'package:json_annotation/json_annotation.dart';

part 'chama_products_model.g.dart';

/// Represents a single Chama Product
@JsonSerializable()
class ChamaProduct {
  final int id;
  final String name;

  @JsonKey(name: 'expiration_time')
  final String expirationTime;

  @JsonKey(name: 'monthly_price')
  final int monthlyPrice;

  @JsonKey(name: 'target_amount')
  final int targetAmount;

  ChamaProduct({
    required this.id,
    required this.name,
    required this.expirationTime,
    required this.monthlyPrice,
    required this.targetAmount,
  });

  factory ChamaProduct.fromJson(Map<String, dynamic> json) =>
      _$ChamaProductFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaProductToJson(this);
}

/// Represents the entire backend response
@JsonSerializable()
class ChamaProductsResponse {
  final List<ChamaProduct> data;
  final List<dynamic> errors;
  final bool success;

  @JsonKey(name: 'status_code')
  final int statusCode;

  ChamaProductsResponse({
    required this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory ChamaProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ChamaProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChamaProductsResponseToJson(this);
}
class ChamaProduct {
  final int id;
  final String name;
  final String expirationTime;
  final int monthlyPrice;
  final int targetAmount;

//Initialize the variables
  ChamaProduct({
    required this.id,
    required this.name,
    required this.expirationTime,
    required this.monthlyPrice,
    required this.targetAmount,
  });

  factory ChamaProduct.fromJson(Map<String, dynamic> json) {
    return ChamaProduct(
      id: json['id'] ?? 0, //if json exists and is not null
      name: json['name'] ?? '',
      expirationTime: json['expiration_time'] ?? '',
      monthlyPrice: json['monthly_price'] is int
          ? json['monthly_price']
          : int.tryParse(json['monthly_price'].toString()) ?? 0,
      targetAmount: json['target_amount'] is int
          ? json['target_amount']
          : int.tryParse(json['target_amount'].toString()) ?? 0,
    );
  }
}

class ChamaProductsResponse {
  final List<ChamaProduct> data;
  final List<String> errors;
  final bool success;
  final int statusCode;

  ChamaProductsResponse({
    required this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory ChamaProductsResponse.fromJson(Map<String, dynamic> json) {
    return ChamaProductsResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((x) => ChamaProduct.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      errors: List<String>.from(json['errors'] ?? []),
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
    );
  }
}

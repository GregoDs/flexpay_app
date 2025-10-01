import 'package:json_annotation/json_annotation.dart';

part 'bk_payment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BkWalletPaymentResponse {
  final BkWalletPaymentResponse? data; // recursion: can hold nested response
  final List<String>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  BkWalletPaymentResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory BkWalletPaymentResponse.fromJson(Map<String, dynamic> json) {
    // Special handling for data field
    final dynamic rawData = json['data'];
    BkWalletPaymentResponse? nested;

    if (rawData is Map<String, dynamic>) {
      nested = BkWalletPaymentResponse.fromJson(rawData);
    }

    return BkWalletPaymentResponse(
      data: nested,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      success: json['success'] as bool,
      statusCode: json['status_code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'errors': errors,
      'success': success,
      'status_code': statusCode,
    };
  }
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bk_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BkWalletPaymentResponse _$BkWalletPaymentResponseFromJson(
  Map<String, dynamic> json,
) => BkWalletPaymentResponse(
  data: json['data'] == null
      ? null
      : BkWalletPaymentResponse.fromJson(json['data'] as Map<String, dynamic>),
  errors: (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
);

Map<String, dynamic> _$BkWalletPaymentResponseToJson(
  BkWalletPaymentResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

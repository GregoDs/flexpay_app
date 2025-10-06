import 'package:json_annotation/json_annotation.dart';

part 'pay_loan_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PayLoanResponse {
  final dynamic data;
  final List<dynamic>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  PayLoanResponse({
    required this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory PayLoanResponse.fromJson(Map<String, dynamic> json) =>
      _$PayLoanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayLoanResponseToJson(this);
}

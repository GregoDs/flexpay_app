import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletResponse {
  final WalletData? data;
  final List<dynamic>? errors;
  final bool success;
  @JsonKey(name: 'status_code')
  final int statusCode;

  WalletResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WalletData {
  @JsonKey(name: 'wallet_account')
  final WalletAccount? walletAccount;

  WalletData({this.walletAccount});

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WalletAccount {
  final int? id;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'account_number')
  final int? accountNumber;
  @JsonKey(name: 'account_status')
  final String? accountStatus;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'wallet_balance')
  final WalletBalance? walletBalance;
  @JsonKey(name: 'wallet_credit')
  final List<WalletCredit>? walletCredit;
  @JsonKey(name: 'wallet_debit')
  final List<WalletDebit>? walletDebit;
  @JsonKey(name: 'wallet_refund_balance')
  final int? walletRefundBalance;

  WalletAccount({
    this.id,
    this.userId,
    this.accountNumber,
    this.accountStatus,
    this.createdAt,
    this.updatedAt,
    this.walletBalance,
    this.walletCredit,
    this.walletDebit,
    this.walletRefundBalance,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> json) =>
      _$WalletAccountFromJson(json);

  Map<String, dynamic> toJson() => _$WalletAccountToJson(this);
}

@JsonSerializable()
class WalletBalance {
  final int? id;
  @JsonKey(name: 'wallet_id')
  final int? walletId;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'account_number')
  final int? accountNumber;
  @JsonKey(name: 'total_credit')
  final int? totalCredit;
  @JsonKey(name: 'total_debit')
  final int? totalDebit;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  /// ✅ Computed property: safe balance calculation
  int get balance => (totalCredit ?? 0) - (totalDebit ?? 0);

  WalletBalance({
    this.id,
    this.walletId,
    this.userId,
    this.accountNumber,
    this.totalCredit,
    this.totalDebit,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$WalletBalanceToJson(this);
}

@JsonSerializable()
class WalletCredit {
  final int? id;
  @JsonKey(name: 'wallet_id')
  final int? walletId;
  @JsonKey(name: 'money_in_id')
  final int? moneyInId;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'account_number')
  final int? accountNumber;
  @JsonKey(name: 'account_type')
  final String? accountType;
  final int? amount;
  final String? source;
  @JsonKey(name: 'credit_type')
  final String? creditType;
  @JsonKey(name: 'source_reference')
  final String? sourceReference;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  WalletCredit({
    this.id,
    this.walletId,
    this.moneyInId,
    this.userId,
    this.accountNumber,
    this.accountType,
    this.amount,
    this.source,
    this.creditType,
    this.sourceReference,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletCredit.fromJson(Map<String, dynamic> json) =>
      _$WalletCreditFromJson(json);

  Map<String, dynamic> toJson() => _$WalletCreditToJson(this);
}

@JsonSerializable()
class WalletDebit {
  final int? id;
  @JsonKey(name: 'wallet_id')
  final int? walletId;
  @JsonKey(name: 'destination_id')
  final int? destinationId;
  @JsonKey(name: 'money_out_id')
  final int? moneyOutId;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'account_number')
  final int? accountNumber;
  @JsonKey(name: 'account_type')
  final String? accountType;
  final int? amount;
  @JsonKey(name: 'withdrawal_fee')
  final int? withdrawalFee;
  final String? destination;
  @JsonKey(name: 'destination_reference')
  final String? destinationReference;
  @JsonKey(name: 'debit_status')
  final String? debitStatus;
  @JsonKey(name: 'debit_required_approval')
  final int? debitRequiredApproval;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  WalletDebit({
    this.id,
    this.walletId,
    this.destinationId,
    this.moneyOutId,
    this.userId,
    this.accountNumber,
    this.accountType,
    this.amount,
    this.withdrawalFee,
    this.destination,
    this.destinationReference,
    this.debitStatus,
    this.debitRequiredApproval,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletDebit.fromJson(Map<String, dynamic> json) =>
      _$WalletDebitFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDebitToJson(this);
}
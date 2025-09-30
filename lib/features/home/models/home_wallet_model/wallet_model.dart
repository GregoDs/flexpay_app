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
  final WalletAccount walletAccount;

  WalletData({required this.walletAccount});

  factory WalletData.fromJson(Map<String, dynamic> json) =>
      _$WalletDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WalletAccount {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'account_number')
  final int accountNumber;
  @JsonKey(name: 'account_status')
  final String accountStatus;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'wallet_balance')
  final WalletBalance walletBalance;
  @JsonKey(name: 'wallet_credit')
  final List<WalletCredit> walletCredit;
  @JsonKey(name: 'wallet_debit')
  final List<WalletDebit> walletDebit;
  @JsonKey(name: 'wallet_refund_balance')
  final int walletRefundBalance;

  WalletAccount({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.accountStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.walletBalance,
    required this.walletCredit,
    required this.walletDebit,
    required this.walletRefundBalance,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> json) =>
      _$WalletAccountFromJson(json);

  Map<String, dynamic> toJson() => _$WalletAccountToJson(this);
}

@JsonSerializable()
class WalletBalance {
  final int id;
  @JsonKey(name: 'wallet_id')
  final int walletId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'account_number')
  final int accountNumber;
  @JsonKey(name: 'total_credit')
  final int totalCredit;
  @JsonKey(name: 'total_debit')
  final int totalDebit;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// ✅ Computed property: returns current balance
  int get balance => totalCredit - totalDebit;

  WalletBalance({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.accountNumber,
    required this.totalCredit,
    required this.totalDebit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceFromJson(json);

  Map<String, dynamic> toJson() => _$WalletBalanceToJson(this);
}

@JsonSerializable()
class WalletCredit {
  final int id;
  @JsonKey(name: 'wallet_id')
  final int walletId;
  @JsonKey(name: 'money_in_id')
  final int moneyInId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'account_number')
  final int accountNumber;
  @JsonKey(name: 'account_type')
  final String accountType;
  final int amount;
  final String source;
  @JsonKey(name: 'credit_type')
  final String creditType;
  @JsonKey(name: 'source_reference')
  final String? sourceReference;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  WalletCredit({
    required this.id,
    required this.walletId,
    required this.moneyInId,
    required this.userId,
    required this.accountNumber,
    required this.accountType,
    required this.amount,
    required this.source,
    required this.creditType,
    this.sourceReference,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletCredit.fromJson(Map<String, dynamic> json) =>
      _$WalletCreditFromJson(json);

  Map<String, dynamic> toJson() => _$WalletCreditToJson(this);
}

@JsonSerializable()
class WalletDebit {
  final int id;
  @JsonKey(name: 'wallet_id')
  final int walletId;
  @JsonKey(name: 'destination_id')
  final int destinationId;
  @JsonKey(name: 'money_out_id')
  final int moneyOutId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'account_number')
  final int accountNumber;
  @JsonKey(name: 'account_type')
  final String accountType;
  final int amount;
  @JsonKey(name: 'withdrawal_fee')
  final int withdrawalFee;
  final String destination;
  @JsonKey(name: 'destination_reference')
  final String destinationReference;
  @JsonKey(name: 'debit_status')
  final String debitStatus;
  @JsonKey(name: 'debit_required_approval')
  final int debitRequiredApproval;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  WalletDebit({
    required this.id,
    required this.walletId,
    required this.destinationId,
    required this.moneyOutId,
    required this.userId,
    required this.accountNumber,
    required this.accountType,
    required this.amount,
    required this.withdrawalFee,
    required this.destination,
    required this.destinationReference,
    required this.debitStatus,
    required this.debitRequiredApproval,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletDebit.fromJson(Map<String, dynamic> json) =>
      _$WalletDebitFromJson(json);

  Map<String, dynamic> toJson() => _$WalletDebitToJson(this);
}
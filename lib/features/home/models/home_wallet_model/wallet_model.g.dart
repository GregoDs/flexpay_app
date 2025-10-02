// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletResponse _$WalletResponseFromJson(Map<String, dynamic> json) =>
    WalletResponse(
      data: json['data'] == null
          ? null
          : WalletData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$WalletResponseToJson(WalletResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

WalletData _$WalletDataFromJson(Map<String, dynamic> json) => WalletData(
  walletAccount: json['wallet_account'] == null
      ? null
      : WalletAccount.fromJson(json['wallet_account'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WalletDataToJson(WalletData instance) =>
    <String, dynamic>{'wallet_account': instance.walletAccount?.toJson()};

WalletAccount _$WalletAccountFromJson(Map<String, dynamic> json) =>
    WalletAccount(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      accountNumber: (json['account_number'] as num?)?.toInt(),
      accountStatus: json['account_status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      walletBalance: json['wallet_balance'] == null
          ? null
          : WalletBalance.fromJson(
              json['wallet_balance'] as Map<String, dynamic>,
            ),
      walletCredit: (json['wallet_credit'] as List<dynamic>?)
          ?.map((e) => WalletCredit.fromJson(e as Map<String, dynamic>))
          .toList(),
      walletDebit: (json['wallet_debit'] as List<dynamic>?)
          ?.map((e) => WalletDebit.fromJson(e as Map<String, dynamic>))
          .toList(),
      walletRefundBalance: (json['wallet_refund_balance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WalletAccountToJson(WalletAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'account_number': instance.accountNumber,
      'account_status': instance.accountStatus,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'wallet_balance': instance.walletBalance?.toJson(),
      'wallet_credit': instance.walletCredit?.map((e) => e.toJson()).toList(),
      'wallet_debit': instance.walletDebit?.map((e) => e.toJson()).toList(),
      'wallet_refund_balance': instance.walletRefundBalance,
    };

WalletBalance _$WalletBalanceFromJson(Map<String, dynamic> json) =>
    WalletBalance(
      id: (json['id'] as num?)?.toInt(),
      walletId: (json['wallet_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      accountNumber: (json['account_number'] as num?)?.toInt(),
      totalCredit: (json['total_credit'] as num?)?.toInt(),
      totalDebit: (json['total_debit'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$WalletBalanceToJson(WalletBalance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wallet_id': instance.walletId,
      'user_id': instance.userId,
      'account_number': instance.accountNumber,
      'total_credit': instance.totalCredit,
      'total_debit': instance.totalDebit,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

WalletCredit _$WalletCreditFromJson(Map<String, dynamic> json) => WalletCredit(
  id: (json['id'] as num?)?.toInt(),
  walletId: (json['wallet_id'] as num?)?.toInt(),
  moneyInId: (json['money_in_id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  accountNumber: (json['account_number'] as num?)?.toInt(),
  accountType: json['account_type'] as String?,
  amount: (json['amount'] as num?)?.toInt(),
  source: json['source'] as String?,
  creditType: json['credit_type'] as String?,
  sourceReference: json['source_reference'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$WalletCreditToJson(WalletCredit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wallet_id': instance.walletId,
      'money_in_id': instance.moneyInId,
      'user_id': instance.userId,
      'account_number': instance.accountNumber,
      'account_type': instance.accountType,
      'amount': instance.amount,
      'source': instance.source,
      'credit_type': instance.creditType,
      'source_reference': instance.sourceReference,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

WalletDebit _$WalletDebitFromJson(Map<String, dynamic> json) => WalletDebit(
  id: (json['id'] as num?)?.toInt(),
  walletId: (json['wallet_id'] as num?)?.toInt(),
  destinationId: (json['destination_id'] as num?)?.toInt(),
  moneyOutId: (json['money_out_id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  accountNumber: (json['account_number'] as num?)?.toInt(),
  accountType: json['account_type'] as String?,
  amount: (json['amount'] as num?)?.toInt(),
  withdrawalFee: (json['withdrawal_fee'] as num?)?.toInt(),
  destination: json['destination'] as String?,
  destinationReference: json['destination_reference'] as String?,
  debitStatus: json['debit_status'] as String?,
  debitRequiredApproval: (json['debit_required_approval'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$WalletDebitToJson(WalletDebit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wallet_id': instance.walletId,
      'destination_id': instance.destinationId,
      'money_out_id': instance.moneyOutId,
      'user_id': instance.userId,
      'account_number': instance.accountNumber,
      'account_type': instance.accountType,
      'amount': instance.amount,
      'withdrawal_fee': instance.withdrawalFee,
      'destination': instance.destination,
      'destination_reference': instance.destinationReference,
      'debit_status': instance.debitStatus,
      'debit_required_approval': instance.debitRequiredApproval,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

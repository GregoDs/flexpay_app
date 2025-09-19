import 'dart:convert';

/// -------------------
/// TOP LEVEL RESPONSE
/// -------------------
class AllBookingsResponse {
  final BookingData? data;
  final List<dynamic>? errors;
  final bool? success;
  final int? statusCode;

  AllBookingsResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory AllBookingsResponse.fromJson(Map<String, dynamic> json) {
    return AllBookingsResponse(
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
      errors: json['errors'] ?? [],
      success: json['success'],
      statusCode: json['status_code'],
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

/// -------------------
/// WRAPPER → data.pBooking
/// -------------------
class BookingData {
  final List<Booking>? pBooking;

  BookingData({this.pBooking});

  factory BookingData.fromJson(Map<String, dynamic> json) {
    final pBookingJson = json['pBooking'];
    List<dynamic> bookingsList = [];
    if (pBookingJson is List) {
      bookingsList = pBookingJson;
    } else if (pBookingJson is Map && pBookingJson['data'] is List) {
      bookingsList = pBookingJson['data'];
    }
    return BookingData(
      pBooking: bookingsList.map((e) => Booking.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pBooking': {
        'data': pBooking?.map((e) => e.toJson()).toList(),
      },
    };
  }
}

/// -------------------
/// BOOKING MODEL (exact backend order)
/// -------------------
class Booking {
  final int? id;
  final int? countryId;
  final int? productId;
  final String? bookingSource;
  final int? userId;
  final int? merchantId;
  final int? promoterId;
  final int? outletId;
  final String? bookingReference;
  final String? referralCoupon;
  final num? bookingPrice;
  final num? validationPrice;
  final num? bookingOfferPrice;
  final num? initialDeposit;
  final String? hasFixedDeadline;
  final String? bookingStatus;
  final int? isPromotional;
  final num? promotionalAmount;
  final String? endDate;
  final String? deadlineDate;
  final int? bookingOnCredit;
  final String? accountName;
  final String? accountNo;
  final String? reference;
  final String? phoneNumber;
  final String? checkoutStatus;
  final String? frequency;
  final String? frequencyContribution;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? productName;
  final String? productCode;
  final String? outletName;
  final String? merchantName;
  final num? total;
  final User? user;
  final List<dynamic>? bookingInterest;
  final num? interestAmount;
  final String? maturityDate;
  final num? targetSaving;
  final String? chamaDescription;
  final String? image;
  final num? progress;
  final List<Payment>? payments;
  final Receipt? receipt;

  Booking({
    this.id,
    this.countryId,
    this.productId,
    this.bookingSource,
    this.userId,
    this.merchantId,
    this.promoterId,
    this.outletId,
    this.bookingReference,
    this.referralCoupon,
    this.bookingPrice,
    this.validationPrice,
    this.bookingOfferPrice,
    this.initialDeposit,
    this.hasFixedDeadline,
    this.bookingStatus,
    this.isPromotional,
    this.promotionalAmount,
    this.endDate,
    this.deadlineDate,
    this.bookingOnCredit,
    this.accountName,
    this.accountNo,
    this.reference,
    this.phoneNumber,
    this.checkoutStatus,
    this.frequency,
    this.frequencyContribution,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.productName,
    this.productCode,
    this.outletName,
    this.merchantName,
    this.total,
    this.user,
    this.bookingInterest,
    this.interestAmount,
    this.maturityDate,
    this.targetSaving,
    this.chamaDescription,
    this.image,
    this.progress,
    this.payments,
    this.receipt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      countryId: json['country_id'],
      productId: json['product_id'],
      bookingSource: json['booking_source'],
      userId: json['user_id'],
      merchantId: json['merchant_id'],
      promoterId: json['promoter_id'],
      outletId: json['outlet_id'],
      bookingReference: json['booking_reference'],
      referralCoupon: json['referral_coupon'],
      bookingPrice: json['booking_price'],
      validationPrice: json['validation_price'],
      bookingOfferPrice: json['booking_offer_price'],
      initialDeposit: json['initial_deposit'],
      hasFixedDeadline: json['has_fixed_deadline'],
      bookingStatus: json['booking_status'],
      isPromotional: json['is_promotional'],
      promotionalAmount: json['promotional_amount'],
      endDate: json['end_date'],
      deadlineDate: json['deadline_date'],
      bookingOnCredit: json['booking_on_credit'],
      accountName: json['account_name'],
      accountNo: json['account_no'],
      reference: json['reference'],
      phoneNumber: json['phone_number'],
      checkoutStatus: json['checkout_status'],
      frequency: json['frequency'],
      frequencyContribution: json['frequency_contribution'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      productName: json['product_name'],
      productCode: json['product_code'],
      outletName: json['outlet_name'],
      merchantName: json['merchant_name'],
      total: json['total'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      bookingInterest: json['booking_interest'] ?? [],
      interestAmount: json['interest_amount'],
      maturityDate: json['maturity_date'],
      targetSaving: json['target_saving'],
      chamaDescription: json['chama_description'],
      image: json['image'],
      progress: json['progress'],
          payments: (json['payment'] as List<dynamic>?)
        ?.map((e) => Payment.fromJson(e))
        .toList(),
      receipt: json['receipt'] != null ? Receipt.fromJson(json['receipt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_id': countryId,
      'product_id': productId,
      'booking_source': bookingSource,
      'user_id': userId,
      'merchant_id': merchantId,
      'promoter_id': promoterId,
      'outlet_id': outletId,
      'booking_reference': bookingReference,
      'referral_coupon': referralCoupon,
      'booking_price': bookingPrice,
      'validation_price': validationPrice,
      'booking_offer_price': bookingOfferPrice,
      'initial_deposit': initialDeposit,
      'has_fixed_deadline': hasFixedDeadline,
      'booking_status': bookingStatus,
      'is_promotional': isPromotional,
      'promotional_amount': promotionalAmount,
      'end_date': endDate,
      'deadline_date': deadlineDate,
      'booking_on_credit': bookingOnCredit,
      'account_name': accountName,
      'account_no': accountNo,
      'reference': reference,
      'phone_number': phoneNumber,
      'checkout_status': checkoutStatus,
      'frequency': frequency,
      'frequency_contribution': frequencyContribution,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'product_name': productName,
      'product_code': productCode,
      'outlet_name': outletName,
      'merchant_name': merchantName,
      'total': total,
      'user': user?.toJson(),
      'booking_interest': bookingInterest,
      'interest_amount': interestAmount,
      'maturity_date': maturityDate,
      'target_saving': targetSaving,
      'chama_description': chamaDescription,
      'image': image,
      'progress': progress,
      'payment': payments?.map((e) => e.toJson()).toList(),
      'receipt': receipt?.toJson(),
    };
  }
}

/// -------------------
/// USER
/// -------------------
class User {
  final int? id;
  final int? userId;
  final int? referralId;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber1;
  final String? idNumber;
  final String? passportNumber;
  final String? dob;
  final String? country;

  User({
    this.id,
    this.userId,
    this.referralId,
    this.firstName,
    this.lastName,
    this.phoneNumber1,
    this.idNumber,
    this.passportNumber,
    this.dob,
    this.country,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userId: json['user_id'],
      referralId: json['referral_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber1: json['phone_number_1'],
      idNumber: json['id_number'],
      passportNumber: json['passport_number'],
      dob: json['dob'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'referral_id': referralId,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number_1': phoneNumber1,
      'id_number': idNumber,
      'passport_number': passportNumber,
      'dob': dob,
      'country': country,
    };
  }
}

/// -------------------
/// PAYMENT
/// -------------------
class Payment {
  final int? id;
  final int? paymentId;
  final int? bookingId;
  final int? walletId;
  final num? paymentAmount;
  final String? destination;
  final String? destinationAccountNo;
  final String? destinationPhoneNo;
  final String? destinationTransactionReference;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Payment({
    this.id,
    this.paymentId,
    this.bookingId,
    this.walletId,
    this.paymentAmount,
    this.destination,
    this.destinationAccountNo,
    this.destinationPhoneNo,
    this.destinationTransactionReference,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      paymentId: json['payment_id'],
      bookingId: json['booking_id'],
      walletId: json['wallet_id'],
      paymentAmount: json['payment_amount'],
      destination: json['destination'],
      destinationAccountNo: json['destination_account_no'],
      destinationPhoneNo: json['destination_phone_no'],
      destinationTransactionReference: json['destination_transaction_reference'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_id': paymentId,
      'booking_id': bookingId,
      'wallet_id': walletId,
      'payment_amount': paymentAmount,
      'destination': destination,
      'destination_account_no': destinationAccountNo,
      'destination_phone_no': destinationPhoneNo,
      'destination_transaction_reference': destinationTransactionReference,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

/// -------------------
/// RECEIPT
/// -------------------
class Receipt {
  final int? id;
  final int? userId;
  final int? merchantId;
  final int? bookingId;
  final String? paymentRef;
  final String? receiptNo;
  final num? expectedAmount;
  final num? paidAmount;
  final String? receiptStatus;
  final int? closedBy;
  final int? revokedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? validatedAt;

  Receipt({
    this.id,
    this.userId,
    this.merchantId,
    this.bookingId,
    this.paymentRef,
    this.receiptNo,
    this.expectedAmount,
    this.paidAmount,
    this.receiptStatus,
    this.closedBy,
    this.revokedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.validatedAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      userId: json['user_id'],
      merchantId: json['merchant_id'],
      bookingId: json['booking_id'],
      paymentRef: json['payment_ref'],
      receiptNo: json['receipt_no'],
      expectedAmount: json['expected_amount'],
      paidAmount: json['paid_amount'],
      receiptStatus: json['receipt_status'],
      closedBy: json['closed_by'],
      revokedBy: json['revoked_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      validatedAt: json['validated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'merchant_id': merchantId,
      'booking_id': bookingId,
      'payment_ref': paymentRef,
      'receipt_no': receiptNo,
      'expected_amount': expectedAmount,
      'paid_amount': paidAmount,
      'receipt_status': receiptStatus,
      'closed_by': closedBy,
      'revoked_by': revokedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'validated_at': validatedAt,
    };
  }
}
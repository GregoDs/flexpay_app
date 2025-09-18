import 'dart:convert';

/// -------------------
/// TOP LEVEL RESPONSE
/// -------------------
class AllBookingsResponse {
  final BookingDataWrapper? data;
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
      data: json['data'] != null ? BookingDataWrapper.fromJson(json['data']) : null,
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
class BookingDataWrapper {
  final PBooking? pBooking;

  BookingDataWrapper({this.pBooking});

  factory BookingDataWrapper.fromJson(Map<String, dynamic> json) {
    return BookingDataWrapper(
      pBooking: json['pBooking'] != null ? PBooking.fromJson(json['pBooking']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pBooking': pBooking?.toJson(),
    };
  }
}

/// -------------------
/// PAGINATION OBJECT
/// -------------------
class PBooking {
  final int? currentPage;
  final List<Booking>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PageLink>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  PBooking({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory PBooking.fromJson(Map<String, dynamic> json) {
    return PBooking(
      currentPage: json['current_page'],
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Booking.fromJson(e))
              .toList() ??
          [],
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List<dynamic>?)
              ?.map((e) => PageLink.fromJson(e))
              .toList() ??
          [],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data?.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links?.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

/// -------------------
/// BOOKING MODEL
/// -------------------
class Booking {
  final String? productName;
  final String? productCode;
  final String? productCategoryName;
  final String? productTypeName;
  final String? bookingReference;
  final String? bookingSource;
  final String? deadlineDate;
  final String? bookingStatus;
  final num? bookingPrice;
  final String? createdAt;
  final int? bookingId;
  final int? categoryId;
  final int? outletId;
  final int? merchantId;
  final String? firstName;
  final String? outletName;
  final String? merchantName;
  final num? total;
  final num? balance;
  final List<Payment>? payments;
  final User? user;
  final List<dynamic>? bookingInterest; // TODO: map if structure is known
  final num? interestAmount;
  final String? maturityDate;
  final num? targetSaving;
  final String? chamaDescription;
  final String? image;
  final num? progress;
  final List<dynamic>? payment; // Legacy field?

  Booking({
    this.productName,
    this.productCode,
    this.productCategoryName,
    this.productTypeName,
    this.bookingReference,
    this.bookingSource,
    this.deadlineDate,
    this.bookingStatus,
    this.bookingPrice,
    this.createdAt,
    this.bookingId,
    this.categoryId,
    this.outletId,
    this.merchantId,
    this.firstName,
    this.outletName,
    this.merchantName,
    this.total,
    this.balance,
    this.payments,
    this.user,
    this.bookingInterest,
    this.interestAmount,
    this.maturityDate,
    this.targetSaving,
    this.chamaDescription,
    this.image,
    this.progress,
    this.payment,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      productName: json['product_name'],
      productCode: json['product_code'],
      productCategoryName: json['product_category_name'],
      productTypeName: json['product_type_name'],
      bookingReference: json['booking_reference'],
      bookingSource: json['booking_source'],
      deadlineDate: json['deadline_date'],
      bookingStatus: json['booking_status'],
      bookingPrice: json['booking_price'],
      createdAt: json['created_at'],
      bookingId: json['booking_id'],
      categoryId: json['category_id'],
      outletId: json['outlet_id'],
      merchantId: json['merchant_id'],
      firstName: json['first_name'],
      outletName: json['outlet_name'],
      merchantName: json['merchant_name'],
      total: json['total'],
      balance: json['balance'],
      payments: (json['payments'] as List<dynamic>?)
              ?.map((e) => Payment.fromJson(e))
              .toList() ??
          [],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      bookingInterest: json['booking_interest'] ?? [],
      interestAmount: json['interest_amount'],
      maturityDate: json['maturity_date'],
      targetSaving: json['target_saving'],
      chamaDescription: json['chama_description'],
      image: json['image'],
      progress: json['progress'],
      payment: json['payment'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'product_code': productCode,
      'product_category_name': productCategoryName,
      'product_type_name': productTypeName,
      'booking_reference': bookingReference,
      'booking_source': bookingSource,
      'deadline_date': deadlineDate,
      'booking_status': bookingStatus,
      'booking_price': bookingPrice,
      'created_at': createdAt,
      'booking_id': bookingId,
      'category_id': categoryId,
      'outlet_id': outletId,
      'merchant_id': merchantId,
      'first_name': firstName,
      'outlet_name': outletName,
      'merchant_name': merchantName,
      'total': total,
      'balance': balance,
      'payments': payments?.map((e) => e.toJson()).toList(),
      'user': user?.toJson(),
      'booking_interest': bookingInterest,
      'interest_amount': interestAmount,
      'maturity_date': maturityDate,
      'target_saving': targetSaving,
      'chama_description': chamaDescription,
      'image': image,
      'progress': progress,
      'payment': payment,
    };
  }
}

/// -------------------
/// PAYMENT MODEL
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
/// USER MODEL
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
/// PAGINATION LINKS
/// -------------------
class PageLink {
  final String? url;
  final String? label;
  final bool? active;

  PageLink({this.url, this.label, this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
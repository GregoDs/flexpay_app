// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kapu_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KapuBookingResponse _$KapuBookingResponseFromJson(Map<String, dynamic> json) =>
    KapuBookingResponse(
      data: json['data'] == null
          ? null
          : BookingData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$KapuBookingResponseToJson(
  KapuBookingResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'errors': instance.errors,
  'success': instance.success,
  'status_code': instance.statusCode,
};

BookingData _$BookingDataFromJson(Map<String, dynamic> json) => BookingData(
  id: (json['id'] as num?)?.toInt(),
  productId: (json['product_id'] as num?)?.toInt(),
  userId: json['user_id'] as String?,
  merchantId: json['merchant_id'] as String?,
  promoterId: (json['promoter_id'] as num?)?.toInt(),
  bookingOnCredit: (json['booking_on_credit'] as num?)?.toInt(),
  outletId: (json['outlet_id'] as num?)?.toInt(),
  bookingPrice: (json['booking_price'] as num?)?.toDouble(),
  bookingOfferPrice: (json['booking_offer_price'] as num?)?.toDouble(),
  initialDeposit: (json['initial_deposit'] as num?)?.toDouble(),
  isPermanent: json['is_permanent'] as bool?,
  referralCoupon: json['referral_coupon'] as String?,
  bookingSource: json['booking_source'] as String?,
  deadlineDate: json['deadline_date'] as String?,
  bookingReference: json['booking_reference'] as String?,
  frequency: json['frequency'] as String?,
  frequencyContribution: json['frequency_contribution'],
  updatedAt: json['updated_at'] as String?,
  createdAt: json['created_at'] as String?,
  user: json['user'] == null
      ? null
      : UserData.fromJson(json['user'] as Map<String, dynamic>),
  bookingInterest: json['booking_interest'] as List<dynamic>?,
  interestAmount: (json['interest_amount'] as num?)?.toDouble(),
  maturityDate: json['maturity_date'] as String?,
  targetSaving: (json['target_saving'] as num?)?.toDouble(),
  chamaDescription: json['chama_description'] as String?,
  image: json['image'] as String?,
  progress: (json['progress'] as num?)?.toDouble(),
  payment: json['payment'] as List<dynamic>?,
);

Map<String, dynamic> _$BookingDataToJson(BookingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'user_id': instance.userId,
      'merchant_id': instance.merchantId,
      'promoter_id': instance.promoterId,
      'booking_on_credit': instance.bookingOnCredit,
      'outlet_id': instance.outletId,
      'booking_price': instance.bookingPrice,
      'booking_offer_price': instance.bookingOfferPrice,
      'initial_deposit': instance.initialDeposit,
      'is_permanent': instance.isPermanent,
      'referral_coupon': instance.referralCoupon,
      'booking_source': instance.bookingSource,
      'deadline_date': instance.deadlineDate,
      'booking_reference': instance.bookingReference,
      'frequency': instance.frequency,
      'frequency_contribution': instance.frequencyContribution,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'user': instance.user?.toJson(),
      'booking_interest': instance.bookingInterest,
      'interest_amount': instance.interestAmount,
      'maturity_date': instance.maturityDate,
      'target_saving': instance.targetSaving,
      'chama_description': instance.chamaDescription,
      'image': instance.image,
      'progress': instance.progress,
      'payment': instance.payment,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  referralId: (json['referral_id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  phoneNumber1: json['phone_number_1'] as String?,
  idNumber: json['id_number'] as String?,
  passportNumber: json['passport_number'] as String?,
  dob: json['dob'] as String?,
  country: json['country'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'referral_id': instance.referralId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone_number_1': instance.phoneNumber1,
  'id_number': instance.idNumber,
  'passport_number': instance.passportNumber,
  'dob': instance.dob,
  'country': instance.country,
};

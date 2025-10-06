// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalsResponse _$GoalsResponseFromJson(Map<String, dynamic> json) =>
    GoalsResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => GoalData.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GoalsResponseToJson(GoalsResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

GoalData _$GoalDataFromJson(Map<String, dynamic> json) => GoalData(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  longDescription: json['long_description'] as String?,
  shortDescription: json['short_description'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$GoalDataToJson(GoalData instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'long_description': instance.longDescription,
  'short_description': instance.shortDescription,
  'image': instance.image,
};

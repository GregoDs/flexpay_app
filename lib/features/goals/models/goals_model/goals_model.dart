import 'package:json_annotation/json_annotation.dart';

part 'goals_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GoalsResponse {
  final List<GoalData>? data;
  final List<String>? errors;
  final bool? success;
  @JsonKey(name: 'status_code')
  final int? statusCode;

  GoalsResponse({
    this.data,
    this.errors,
    this.success,
    this.statusCode,
  });

  factory GoalsResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GoalsResponseToJson(this);
}

@JsonSerializable()
class GoalData {
  final int? id;
  final String? name;

  @JsonKey(name: 'long_description')
  final String? longDescription;

  @JsonKey(name: 'short_description')
  final String? shortDescription;

  final String? image;

  GoalData({
    this.id,
    this.name,
    this.longDescription,
    this.shortDescription,
    this.image,
  });

  factory GoalData.fromJson(Map<String, dynamic> json) =>
      _$GoalDataFromJson(json);

  Map<String, dynamic> toJson() => _$GoalDataToJson(this);
}
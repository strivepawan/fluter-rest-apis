// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dob_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DOBModel _$DOBModelFromJson(Map<String, dynamic> json) => DOBModel(
  date: DateTime.parse(json['date'] as String),
  age: (json['age'] as num).toInt(),
);

Map<String, dynamic> _$DOBModelToJson(DOBModel instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'age': instance.age,
};

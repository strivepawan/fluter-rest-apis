// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  gender: json['gender'] as String,
  name: NameModel.fromJson(json['name'] as Map<String, dynamic>),
  location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
  email: json['email'] as String,
  picture: PictureModel.fromJson(json['picture'] as Map<String, dynamic>),
  dob: DOBModel.fromJson(json['dob'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'gender': instance.gender,
  'name': instance.name,
  'location': instance.location,
  'email': instance.email,
  'picture': instance.picture,
  'dob': instance.dob,
};

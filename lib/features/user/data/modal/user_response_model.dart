import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  final List<UserModel> results;

  UserResponseModel({required this.results});

  factory UserResponseModel.fromJson(Map<String, dynamic> json) => _$UserResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}
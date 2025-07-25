import 'package:json_annotation/json_annotation.dart';

part 'dob_model.g.dart';

@JsonSerializable()
class DOBModel {
  final DateTime date;
  final int age;

  DOBModel({required this.date, required this.age});

  factory DOBModel.fromJson(Map<String, dynamic> json) => _$DOBModelFromJson(json);
  Map<String, dynamic> toJson() => _$DOBModelToJson(this);
}
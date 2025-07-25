import 'package:json_annotation/json_annotation.dart';

part 'street_model.g.dart';

@JsonSerializable()
class StreetModel {
  final int number;
  final String name;

  StreetModel({required this.number, required this.name});

  factory StreetModel.fromJson(Map<String, dynamic> json) => _$StreetModelFromJson(json);
  Map<String, dynamic> toJson() => _$StreetModelToJson(this);
}
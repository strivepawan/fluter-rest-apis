import 'package:json_annotation/json_annotation.dart';

import 'street_model.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  final StreetModel street;
  final String city;
  final String state;
  final String country;
  final dynamic postcode; // Can be int or String from API

  LocationModel({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
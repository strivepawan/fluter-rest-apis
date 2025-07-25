import 'package:json_annotation/json_annotation.dart';

part 'picture_model.g.dart';

@JsonSerializable()
class PictureModel {
  final String large;
  final String medium;
  final String thumbnail;

  PictureModel({required this.large, required this.medium, required this.thumbnail});

  factory PictureModel.fromJson(Map<String, dynamic> json) => _$PictureModelFromJson(json);
  Map<String, dynamic> toJson() => _$PictureModelToJson(this);
}
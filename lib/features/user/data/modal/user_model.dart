import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user.dart';
import 'dob_model.dart';
import 'location_model.dart';
import 'name_model.dart';
import 'picture_model.dart';


part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String gender;
  final NameModel name;
  final LocationModel location;
  final String email;
  final PictureModel picture;
  final DOBModel dob;

  UserModel({
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.picture,
    required this.dob,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Mapper from Model to Entity
  UserEntity toEntity() {
    return UserEntity(
      gender: gender,
      title: name.title,
      firstName: name.first,
      lastName: name.last,
      email: email,
      largePicture: picture.large,
      mediumPicture: picture.medium,
      thumbnailPicture: picture.thumbnail,
      country: location.country,
      city: location.city,
      streetName: location.street.name,
      streetNumber: location.street.number,
      age: dob.age,
    );
  }
}
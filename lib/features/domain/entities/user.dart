// Part of lib/features/user/domain/entities/user.dart
class UserEntity {
  final String gender;
  final String title;
  final String firstName;
  final String lastName;
  final String email;
  final String largePicture;
  final String mediumPicture;
  final String thumbnailPicture;
  final String country;
  final String city;
  final String streetName;
  final int streetNumber;
  final int age;

  UserEntity({
    required this.gender,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.largePicture,
    required this.mediumPicture,
    required this.thumbnailPicture,
    required this.country,
    required this.city,
    required this.streetName,
    required this.streetNumber,
    required this.age,
  });

  // For easier debugging
  @override
  String toString() {
    return 'UserEntity(name: $title $firstName $lastName, email: $email, country: $country, age: $age)';
  }
}
import 'enums/gender.dart';

/// The learner's details the profile forms collect (Create Profile, Create
/// Account). Personal data: shown as entered, never translated.
class ProfileDetails {
  const ProfileDetails({required this.fullName, required this.email, required this.gender, required this.age});

  final String fullName;
  final String email;
  final Gender gender;

  /// In years.
  final int age;
}

import '../../../commons/models/enums/gender.dart';
import '../../../commons/models/profile_details.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AUTH REPOSITORY
//
// Account data behind Login and Create Profile, from the Figma content (the
// main user, Jenny Frost): the email Login offers, and the details a Google
// or Apple sign-in hands to Create Profile for the learner to confirm.
// ─────────────────────────────────────────────────────────────────────────────
class AuthRepository {
  const AuthRepository();

  /// The email of the account last used on this device, which Login fills
  /// in (Figma Login shows it in the email field).
  String getLastEmail() => 'jennyfrost@gmail.com';

  /// The details a social sign-in returns, as Figma "After Social Login"
  /// shows them (it has age 8; the Logics variable says 6).
  ProfileDetails getSocialProfile() =>
      const ProfileDetails(fullName: 'Jenny Frost', email: 'jennyfrost@gmail.com', gender: Gender.female, age: 8);
}

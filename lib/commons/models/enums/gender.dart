import '../../../core/localization/lang_keys.dart';

/// A learner's gender, as the profile forms offer it.
enum Gender {
  female(LangKeys.genderFemale),
  male(LangKeys.genderMale),
  other(LangKeys.genderOther);

  const Gender(this.labelKey);

  /// LangKeys key of the label shown for it.
  final String labelKey;
}

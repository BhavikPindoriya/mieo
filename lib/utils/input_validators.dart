import 'package:get/get.dart';

import '../core/localization/lang_keys.dart';

// ─────────────────────────────────────────────────────────────────────────────
// INPUT VALIDATORS
//
// Shared FormField validators — every text field passes one of these (or a
// new static method added here) as its `validator`, never inline logic.
// Each returns null when valid, or a localized error string (LangKeys
// validation* entries) when not. Format checks run only after `required`
// passes, so an empty field always reports "required" first.
// ─────────────────────────────────────────────────────────────────────────────
class InputValidators {
  InputValidators._();

  static const int passwordMinLength = 8;

  /// The ages the profile forms accept.
  static const int minAge = 1;
  static const int maxAge = 120;

  /// Digits in [maxAge]: age fields accept no more.
  static const int ageMaxDigits = 3;

  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? LangKeys.validationRequired.tr : null;

  /// For pick-one fields (dropdowns): something must be picked.
  static String? selection<T>(T? value) => value == null ? LangKeys.validationRequired.tr : null;

  static String? email(String? value) =>
      required(value) ?? (_emailPattern.hasMatch(value!.trim()) ? null : LangKeys.validationEmailInvalid.tr);

  static String? password(String? value) =>
      required(value) ??
      (value!.length < passwordMinLength
          ? LangKeys.validationPasswordMinLength.trParams({'count': '$passwordMinLength'})
          : null);

  /// Usage: `validator: (value) => InputValidators.confirmPassword(value, _passwordController.text)`.
  static String? confirmPassword(String? value, String password) =>
      required(value) ?? (value != password ? LangKeys.validationPasswordMismatch.tr : null);

  /// A whole number of years from [minAge] to [maxAge].
  static String? age(String? value) {
    final missing = required(value);
    if (missing != null) {
      return missing;
    }
    final years = int.tryParse(value!.trim());
    return years != null && years >= minAge && years <= maxAge
        ? null
        : LangKeys.validationAgeRange.trParams({'min': '$minAge', 'max': '$maxAge'});
  }
}

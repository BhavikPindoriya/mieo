import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/constants/assets_constants.dart';
import '../../core/constants/theme_constants.dart';
import '../../core/localization/lang_keys.dart';
import '../../utils/input_validators.dart';
import '../models/enums/gender.dart';
import '../models/profile_details.dart';
import 'fields/app_dropdown_field.dart';
import 'fields/app_text_field.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE FORM FIELDS
//
// The learner's details as form fields — Figma "Input Fields" of Create
// Profile (366:15352) and Create Account (2016:11880), 16 apart:
//
//   1. Full name (user icon).
//   2. Email (mail icon).
//   3. "Gender" (a dropdown: Female, Male, Other) and "Age" (digits only,
//      centred) side by side, 16 apart, each with its label inline. They
//      share the row in Figma's proportions, 223 : 106.
//
// The values live in a ProfileFormController the screen owns; it reads them
// back (ProfileFormController.details) once the enclosing Form validates.
// Every field has its InputValidators check.
// ─────────────────────────────────────────────────────────────────────────────

/// Holds the profile form's values: text controllers for the typed fields and
/// the chosen gender. Dispose it with the screen.
class ProfileFormController {
  ProfileFormController([ProfileDetails? initial])
    : fullName = TextEditingController(text: initial?.fullName),
      email = TextEditingController(text: initial?.email),
      age = TextEditingController(text: initial?.age.toString()),
      gender = ValueNotifier(initial?.gender);

  final TextEditingController fullName;
  final TextEditingController email;
  final TextEditingController age;
  final ValueNotifier<Gender?> gender;

  /// The details as entered. Read it only after the form validated, when
  /// every field holds a valid value.
  ProfileDetails get details => ProfileDetails(
    fullName: fullName.text.trim(),
    email: email.text.trim(),
    gender: gender.value!,
    age: int.parse(age.text.trim()),
  );

  void dispose() {
    fullName.dispose();
    email.dispose();
    age.dispose();
    gender.dispose();
  }
}

/// Figma widths of the Gender and Age groups (223 and 106 of the 345 row),
/// as flex factors.
const int _genderFlex = 223;
const int _ageFlex = 106;

class ProfileFormFields extends StatelessWidget {
  const ProfileFormFields({super.key, required this.controller});

  final ProfileFormController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ThemeConstants.spacing16,
      children: [
        AppTextField(
          controller: controller.fullName,
          icon: AssetsConstants.icUser,
          hintText: LangKeys.fieldFullName.tr,
          validator: InputValidators.required,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
        ),
        AppTextField(
          controller: controller.email,
          icon: AssetsConstants.icMail,
          hintText: LangKeys.fieldEmail.tr,
          validator: InputValidators.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: ThemeConstants.spacing16,
          children: [
            Expanded(
              flex: _genderFlex,
              child: _GenderField(gender: controller.gender),
            ),
            Expanded(
              flex: _ageFlex,
              child: AppTextField(
                controller: controller.age,
                label: LangKeys.fieldAge.tr,
                validator: InputValidators.age,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(InputValidators.ageMaxDigits),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The Gender dropdown, rebuilt when the choice changes.
class _GenderField extends StatelessWidget {
  const _GenderField({required this.gender});

  final ValueNotifier<Gender?> gender;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Gender?>(
      valueListenable: gender,
      builder: (context, value, _) => AppDropdownField<Gender>(
        label: LangKeys.fieldGender.tr,
        hintText: LangKeys.fieldGenderHint.tr,
        value: value,
        options: [for (final option in Gender.values) AppDropdownOption(option, option.labelKey.tr)],
        onChanged: _choose,
        validator: InputValidators.selection,
      ),
    );
  }

  void _choose(Gender value) => gender.value = value;
}

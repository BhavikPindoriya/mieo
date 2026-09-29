import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/app_button.dart';
import '../../../commons/widgets/app_top_bar.dart';
import '../../../commons/widgets/page_heading.dart';
import '../../../commons/widgets/profile_form_fields.dart';
import '../../../commons/widgets/sky_form_scaffold.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/routes/routes.dart';
import '../repositories/auth_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CREATE PROFILE SCREEN
//
// Figma "After Social Login": Light 366:15263, Dark 2159:38492 (the same
// frame with the Colors variables in Dark mode). After a Google or Apple
// sign-in on Login, the learner confirms the details it returned. On the
// form-screen sky (SkyFormScaffold), under a transparent top bar with the
// back button (AppTopBar), centred on the screen, 28 apart like Figma's
// "Container":
//
//   1. Heading — "Create Profile" and its description (PageHeading).
//   2. Fields  — full name, email, then Gender and Age side by side
//                (ProfileFormFields), filled in with the sign-in's details.
//   3. Submit  — 24 inside Figma's "Bottom Action" frame: checks every field,
//                then goes home.
//
// Local state: the form key and the fields' values (ProfileFormController).
// ─────────────────────────────────────────────────────────────────────────────
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  static const AuthRepository _repository = AuthRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileFormController _profile = ProfileFormController(_repository.getSocialProfile());

  @override
  void dispose() {
    _profile.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      TextInput.finishAutofillContext();
      unawaited(Get.offAllNamed<void>(Routes.home));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SkyFormScaffold(
      topBar: const AppTopBar(),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: ThemeConstants.spacing28,
            children: [
              // ── Heading ──
              PageHeading(title: LangKeys.createProfileTitle.tr, description: LangKeys.createProfileDescription.tr),

              // ── Fields ──
              ProfileFormFields(controller: _profile),

              // ── Submit (Figma "Bottom Action") ──
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: ThemeConstants.spacing24),
                child: AppButton(label: LangKeys.createProfileSubmit.tr, onPressed: _submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

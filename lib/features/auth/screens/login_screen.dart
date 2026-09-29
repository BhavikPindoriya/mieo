import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/app_button.dart';
import '../../../commons/widgets/app_icon.dart';
import '../../../commons/widgets/app_social_button.dart';
import '../../../commons/widgets/app_text_link.dart';
import '../../../commons/widgets/fields/app_text_field.dart';
import '../../../commons/widgets/labeled_divider.dart';
import '../../../commons/widgets/page_heading.dart';
import '../../../commons/widgets/sky_form_scaffold.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/routes/routes.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../../../utils/input_validators.dart';
import '../repositories/auth_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LOGIN SCREEN
//
// Figma "Login": Light 364:14961, Dark 2159:38555 (the same frame with the
// Colors variables in Dark mode, so every colour here is a theme token or
// brand artwork). Returning learners sign in here, from "Resume Journey" on
// Onboarding. On the form-screen sky (SkyFormScaffold), centred on the
// screen, with Figma's 28 between sections:
//
//   1. Heading     — "Welcome Back" and its description (PageHeading).
//   2. Credentials — email (filled in with the last account's email) and
//                    password, 16 apart, then "Forgot Password .?" 16 under
//                    them at the end edge.
//   3. Login Now   — 24 inside Figma's "Bottom Action" frame. It checks both
//                    fields and signs in; the password's Done key does too.
//   4. Social      — "Or Continue With" 18 above the Google and Apple
//                    buttons, 16 apart, 24 inside Figma's "Social Login"
//                    frame. Either one signs in and opens Create Profile.
//
// The sections share one Column, so the link's tap target can reach into the
// gaps above and below it.
//
// Local state: the form key and the email and password controllers.
// ─────────────────────────────────────────────────────────────────────────────

/// Figma "Social Login": gap between the divider and the buttons.
const double _socialGap = 18;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const AuthRepository _repository = AuthRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController(text: _repository.getLastEmail());
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Lets the platform offer to save the credentials.
      TextInput.finishAutofillContext();
      unawaited(Get.offAllNamed<void>(Routes.home));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SkyFormScaffold(
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: _LoginForm(email: _email, password: _password, onLogin: _login),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.email, required this.password, required this.onLogin});

  final TextEditingController email;
  final TextEditingController password;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Heading ──
        PageHeading(title: LangKeys.loginTitle.tr, description: LangKeys.loginDescription.tr),
        const SizedBox(height: ThemeConstants.spacing28),

        // ── Credentials (Figma "Input Fields") ──
        AppTextField(
          controller: email,
          icon: AssetsConstants.icMail,
          hintText: LangKeys.fieldEmail.tr,
          validator: InputValidators.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
        ),
        const SizedBox(height: ThemeConstants.spacing16),
        AppTextField(
          controller: password,
          icon: AssetsConstants.icLock,
          hintText: LangKeys.fieldPassword.tr,
          validator: InputValidators.required,
          obscurable: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onSubmitted: (_) => onLogin(),
        ),
        const SizedBox(height: ThemeConstants.spacing16),
        AppTextLink(
          label: LangKeys.loginForgotPassword.tr,
          alignment: AlignmentDirectional.centerEnd,
          onPressed: () => unawaited(Get.toNamed<void>(Routes.forgotPassword)),
        ),
        const SizedBox(height: ThemeConstants.spacing28),

        // ── Login Now (Figma "Bottom Action") ──
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: ThemeConstants.spacing24),
          child: AppButton(label: LangKeys.loginSubmit.tr, onPressed: onLogin),
        ),
        const SizedBox(height: ThemeConstants.spacing28),

        // ── Social ──
        const _SocialLogin(),
      ],
    );
  }
}

/// Figma "Social Login": the divider, then Google and Apple side by side.
class _SocialLogin extends StatelessWidget {
  const _SocialLogin();

  void _continueWithProvider() => unawaited(Get.toNamed<void>(Routes.createProfile));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: ThemeConstants.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _socialGap,
        children: [
          LabeledDivider(label: LangKeys.loginContinueWith.tr),
          Row(
            spacing: ThemeConstants.spacing16,
            children: [
              Expanded(
                child: AppSocialButton(
                  icon: const AppIcon(AssetsConstants.icGoogle),
                  label: LangKeys.loginGoogle.tr,
                  onPressed: _continueWithProvider,
                ),
              ),
              Expanded(
                child: AppSocialButton(
                  icon: AppIcon(AssetsConstants.icApple, color: context.colors.icon.neutral),
                  label: LangKeys.loginApple.tr,
                  onPressed: _continueWithProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

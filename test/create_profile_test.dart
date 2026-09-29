import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/commons/models/enums/gender.dart';
import 'package:mieo_ui8/commons/widgets/app_button.dart';
import 'package:mieo_ui8/commons/widgets/app_icon_button.dart';
import 'package:mieo_ui8/commons/widgets/app_top_bar.dart';
import 'package:mieo_ui8/commons/widgets/fields/app_dropdown_field.dart';
import 'package:mieo_ui8/commons/widgets/fields/app_text_field.dart';
import 'package:mieo_ui8/commons/widgets/page_heading.dart';
import 'package:mieo_ui8/commons/widgets/placeholder_screen.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/core/routes/routes.dart';
import 'package:mieo_ui8/features/auth/repositories/auth_repository.dart';
import 'package:mieo_ui8/features/auth/screens/create_profile_screen.dart';
import 'package:mieo_ui8/features/auth/screens/login_screen.dart';
import 'package:mieo_ui8/utils/input_validators.dart';

import 'helpers/test_app.dart';

// The Create Profile screen (Figma 366:15263 / dark 2159:38492): the details
// a social sign-in returned, the Figma layout on the 375 × 812 reference, the
// gender menu, validation, the back button, and a layout check across the
// Device Preview matrix in both themes and text directions.
void main() {
  setUpAll(loadAppResources);

  final profile = const AuthRepository().getSocialProfile();

  testWidgets('fills in the details from the social sign-in', (tester) async {
    await pumpScreen(tester, const CreateProfileScreen());
    expect(find.text(LangKeys.createProfileTitle.tr), findsOneWidget);
    expect(find.text(LangKeys.createProfileDescription.tr), findsOneWidget);
    expect(find.text(profile.fullName), findsOneWidget);
    expect(find.text(profile.email), findsOneWidget);
    expect(find.text(profile.gender.labelKey.tr), findsOneWidget);
    expect(find.text('${profile.age}'), findsOneWidget);
    expect(find.text(LangKeys.fieldGender.tr), findsOneWidget);
    expect(find.text(LangKeys.fieldAge.tr), findsOneWidget);
    expect(find.text(LangKeys.createProfileSubmit.tr), findsOneWidget);
  });

  testWidgets('lays out with the Figma widths and gaps under the top bar, centred on the screen', (tester) async {
    await pumpScreen(tester, const CreateProfileScreen());
    expect(tester.getRect(find.byType(AppTopBar)), const Rect.fromLTWH(0, 50, 375, AppTopBar.height));
    expect(tester.getTopLeft(find.byType(AppBackButton)), const Offset(16, 66));

    final heading = tester.getRect(find.byType(PageHeading));
    final name = tester.getRect(find.byType(AppTextField).at(0));
    final email = tester.getRect(find.byType(AppTextField).at(1));
    final gender = tester.getRect(find.byType(AppDropdownField<Gender>));
    final age = tester.getRect(find.byType(AppTextField).at(2));
    final button = tester.getRect(find.byType(AppButton));

    for (final rect in [heading, name, email, button]) {
      expect(rect.left, 16);
      expect(rect.width, 343);
    }
    // Gender and Age share the row in Figma's 223 : 106, 16 apart.
    expect(gender.left, 16);
    expect(age.right, closeTo(359, 1e-6));
    expect(age.left - gender.right, closeTo(16, 1e-6));
    expect(gender.width / age.width, closeTo(223 / 106, 1e-6));

    expect(name.top - heading.bottom, closeTo(28, 1e-6));
    expect(email.top - name.bottom, closeTo(16, 1e-6));
    expect(gender.top - email.bottom, closeTo(16, 1e-6));
    expect(gender.top, age.top);
    expect(button.top - gender.bottom, closeTo(28 + 24, 1e-6));

    // Centred on the screen: the status bar and top bar (130) above, the same
    // inset below, like Figma's Container at 113 from both edges.
    final contentBottom = button.bottom + ThemeConstants.spacing24;
    expect(heading.top - 130, closeTo(812 - 130 - contentBottom, 1e-6));
  });

  testWidgets('picks a gender from the menu', (tester) async {
    await pumpScreen(tester, const CreateProfileScreen());
    await tester.tap(find.text(Gender.female.labelKey.tr));
    await tester.pumpAndSettle();
    await tester.tap(find.text(Gender.male.labelKey.tr));
    await tester.pumpAndSettle();
    expect(find.text(Gender.male.labelKey.tr), findsOneWidget);
    expect(find.text(Gender.female.labelKey.tr), findsNothing);
  });

  testWidgets('checks every field before submitting, then goes home', (tester) async {
    await pumpScreen(tester, const CreateProfileScreen());
    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(2), '0');
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(find.text(LangKeys.validationRequired.tr), findsOneWidget);
    final ageMessage = LangKeys.validationAgeRange.trParams({
      'min': '${InputValidators.minAge}',
      'max': '${InputValidators.maxAge}',
    });
    expect(find.text(ageMessage), findsOneWidget);
    expect(find.byType(CreateProfileScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Jenny Frost');
    await tester.enterText(find.byType(TextField).at(2), '8');
    await tester.pumpAndSettle();
    expect(find.text(ageMessage), findsNothing);
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.home);
    expect(find.byType(PlaceholderScreen), findsOneWidget);
  });

  testWidgets('the age field takes digits only', (tester) async {
    await pumpScreen(tester, const CreateProfileScreen());
    await tester.enterText(find.byType(TextField).at(2), '1a2345');
    await tester.pump();
    expect(find.text('123'), findsOneWidget);
  });

  testWidgets('the back button returns to Login', (tester) async {
    await pumpScreen(tester, const LoginScreen());
    await tester.tap(find.text(LangKeys.loginGoogle.tr));
    await tester.pumpAndSettle();
    expect(find.byType(CreateProfileScreen), findsOneWidget);

    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();
    expect(find.byType(CreateProfileScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  for (final size in deviceMatrix) {
    final name = '${size.width.round()} × ${size.height.round()}';
    testWidgets('lays out on $name, light, LTR', (tester) async {
      await pumpScreen(tester, const CreateProfileScreen(), size: size);
      expect(tester.takeException(), isNull);
    });
    testWidgets('lays out on $name, dark, RTL', (tester) async {
      await pumpScreen(
        tester,
        const CreateProfileScreen(),
        size: size,
        themeMode: ThemeMode.dark,
        locale: LocalizationConstants.urdu,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('lays out at text scale 1.3 on the iPhone SE, and with the keyboard up', (tester) async {
    await pumpScreen(
      tester,
      const CreateProfileScreen(),
      size: const Size(375, 667),
      topInset: 20,
      bottomInset: 0,
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
    await pumpScreen(
      tester,
      const CreateProfileScreen(),
      size: const Size(375, 667),
      topInset: 20,
      bottomInset: 0,
      keyboard: 260,
    );
    expect(tester.takeException(), isNull);
  });
}

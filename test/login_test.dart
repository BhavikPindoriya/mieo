import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/commons/widgets/app_button.dart';
import 'package:mieo_ui8/commons/widgets/app_social_button.dart';
import 'package:mieo_ui8/commons/widgets/app_text_link.dart';
import 'package:mieo_ui8/commons/widgets/fields/app_text_field.dart';
import 'package:mieo_ui8/commons/widgets/labeled_divider.dart';
import 'package:mieo_ui8/commons/widgets/page_heading.dart';
import 'package:mieo_ui8/commons/widgets/placeholder_screen.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/core/routes/routes.dart';
import 'package:mieo_ui8/features/auth/repositories/auth_repository.dart';
import 'package:mieo_ui8/features/auth/screens/create_profile_screen.dart';
import 'package:mieo_ui8/features/auth/screens/login_screen.dart';

import 'helpers/test_app.dart';

// The Login screen (Figma 364:14961 / dark 2159:38555): its content and
// Figma spacing on the 375 × 812 reference, validation, where each action
// leads, and a layout check across the Device Preview matrix in both themes
// and text directions, with large text and with the keyboard up.
void main() {
  setUpAll(loadAppResources);

  Finder field(int index) => find.byType(AppTextField).at(index);

  testWidgets('shows the heading, the credentials with the last email filled in, and every action', (tester) async {
    await pumpScreen(tester, const LoginScreen());
    expect(find.text(LangKeys.loginTitle.tr), findsOneWidget);
    expect(find.text(LangKeys.loginDescription.tr), findsOneWidget);
    expect(find.text(const AuthRepository().getLastEmail()), findsOneWidget);
    expect(find.text(LangKeys.fieldPassword.tr), findsOneWidget);
    expect(find.text(LangKeys.loginForgotPassword.tr), findsOneWidget);
    expect(find.text(LangKeys.loginSubmit.tr), findsOneWidget);
    expect(find.text(LangKeys.loginContinueWith.tr), findsOneWidget);
    expect(find.text(LangKeys.loginGoogle.tr), findsOneWidget);
    expect(find.text(LangKeys.loginApple.tr), findsOneWidget);
  });

  testWidgets('lays out with the Figma widths and gaps, centred on the reference screen', (tester) async {
    await pumpScreen(tester, const LoginScreen());
    final heading = tester.getRect(find.byType(PageHeading));
    final email = tester.getRect(field(0));
    final password = tester.getRect(field(1));
    final link = tester.getRect(find.text(LangKeys.loginForgotPassword.tr));
    final button = tester.getRect(find.byType(AppButton));
    final divider = tester.getRect(find.byType(LabeledDivider));
    final google = tester.getRect(find.byType(AppSocialButton).at(0));
    final apple = tester.getRect(find.byType(AppSocialButton).at(1));

    // Full-width pieces sit in the 16 gutters; the social buttons share the row.
    for (final rect in [heading, email, password, button, divider]) {
      expect(rect.left, 16);
      expect(rect.width, 343);
    }
    expect(email.height, ThemeConstants.fieldHeight);
    expect(google, Rect.fromLTWH(16, google.top, 163.5, ThemeConstants.fieldHeight));
    expect(apple, Rect.fromLTWH(195.5, google.top, 163.5, ThemeConstants.fieldHeight));
    expect(link.right, closeTo(359, 1e-6));

    // Figma gaps: 28 between sections, 16 inside the credentials, the
    // button and social frames' 24 paddings, 18 above the social buttons.
    expect(email.top - heading.bottom, closeTo(28, 1e-6));
    expect(password.top - email.bottom, closeTo(16, 1e-6));
    expect(link.top - password.bottom, closeTo(16, 1e-6));
    expect(button.top - link.bottom, closeTo(28 + 24, 1e-6));
    expect(divider.top - button.bottom, closeTo(24 + 28 + 24, 1e-6));
    expect(google.top - divider.bottom, closeTo(18, 1e-6));

    // Centred on the screen: as far below the status bar (50) as the social
    // frame's end (24 under the buttons) is above the same inset at the
    // bottom (812 − 50), like Figma's Container at 113 from both edges.
    final contentBottom = google.bottom + ThemeConstants.spacing24;
    expect(heading.top - 50, closeTo(812 - 50 - contentBottom, 1e-6));
  });

  testWidgets('asks for both fields before signing in', (tester) async {
    await pumpScreen(tester, const LoginScreen());
    await tester.enterText(find.byType(TextField).first, '');
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(find.text(LangKeys.validationRequired.tr), findsNWidgets(2));
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'jenny');
    await tester.pumpAndSettle();
    expect(find.text(LangKeys.validationEmailInvalid.tr), findsOneWidget);
  });

  testWidgets('Login Now signs in and goes home', (tester) async {
    await pumpScreen(tester, const LoginScreen());
    await tester.enterText(find.byType(TextField).last, 'mieo1234');
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.home);
    expect(find.byType(PlaceholderScreen), findsOneWidget);
  });

  testWidgets("the password's Done key signs in too", (tester) async {
    await pumpScreen(tester, const LoginScreen());
    await tester.enterText(find.byType(TextField).last, 'mieo1234');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.home);
  });

  testWidgets('Forgot Password opens password recovery', (tester) async {
    await pumpScreen(tester, const LoginScreen());
    expect(find.byType(AppTextLink), findsOneWidget);
    await tester.tap(find.text(LangKeys.loginForgotPassword.tr));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.forgotPassword);
  });

  for (final provider in [LangKeys.loginGoogle, LangKeys.loginApple]) {
    testWidgets('$provider opens Create Profile', (tester) async {
      await pumpScreen(tester, const LoginScreen());
      await tester.tap(find.text(provider.tr));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.createProfile);
      expect(find.byType(CreateProfileScreen), findsOneWidget);
    });
  }

  testWidgets('a tap outside the fields puts the keyboard away', (tester) async {
    await pumpScreen(tester, const LoginScreen());
    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tap(find.text(LangKeys.loginTitle.tr));
    await tester.pumpAndSettle();
    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('mirrors in RTL: the link moves to the other edge', (tester) async {
    await pumpScreen(tester, const LoginScreen(), locale: LocalizationConstants.urdu);
    expect(Directionality.of(tester.element(find.byType(LoginScreen))), TextDirection.rtl);
    expect(tester.getRect(find.text(LangKeys.loginForgotPassword.tr)).left, 16);
  });

  for (final size in deviceMatrix) {
    final name = '${size.width.round()} × ${size.height.round()}';
    testWidgets('lays out on $name, light, LTR', (tester) async {
      await pumpScreen(tester, const LoginScreen(), size: size);
      expect(tester.takeException(), isNull);
    });
    testWidgets('lays out on $name, dark, RTL', (tester) async {
      await pumpScreen(
        tester,
        const LoginScreen(),
        size: size,
        themeMode: ThemeMode.dark,
        locale: LocalizationConstants.urdu,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('lays out at text scale 1.3 on the iPhone SE, and scrolls with the keyboard up', (tester) async {
    await pumpScreen(
      tester,
      const LoginScreen(),
      size: const Size(375, 667),
      topInset: 20,
      bottomInset: 0,
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
    await pumpScreen(
      tester,
      const LoginScreen(),
      size: const Size(375, 667),
      topInset: 20,
      bottomInset: 0,
      keyboard: 260,
    );
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

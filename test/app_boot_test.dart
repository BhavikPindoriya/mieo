import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mieo_ui8/core/constants/animation_constants.dart';
import 'package:mieo_ui8/core/constants/hive_constants.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';
import 'package:mieo_ui8/core/localization/app_translations.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/features/onboarding/screens/onboarding_screen.dart';
import 'package:mieo_ui8/features/splash/screens/splash_screen.dart';
import 'package:mieo_ui8/main.dart';

// Smoke test for the bootstrap chain: settings box → translations → cubits →
// GetMaterialApp → splash → onboarding, in both text directions.
//
// main() isn't run here, so the Rive runtime isn't initialised: the splash
// shows its static scene for AnimationConstants.splashStaticHold, then leaves.
void main() {
  late Box<dynamic> settingsBox;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init(Directory.systemTemp.createTempSync('mieo_test_').path);
    settingsBox = await Hive.openBox<dynamic>(HiveConstants.settingsBox);
    await AppTranslations.load();
  });

  tearDownAll(Hive.close);

  // Lets the splash's exit timer fire and the cross-fade to onboarding
  // finish, so no timer is left pending when a test ends.
  Future<void> leaveSplash(WidgetTester tester) async {
    await tester.pump(AnimationConstants.splashStaticHold);
    await tester.pumpAndSettle();
  }

  testWidgets('boots into the splash, then moves on to onboarding', (tester) async {
    await tester.pumpWidget(MieoApp(settingsBox: settingsBox));
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text(LangKeys.splashTagline), findsNothing, reason: 'raw key shown — translations not loaded');
    expect(find.text(LangKeys.splashTagline.tr), findsOneWidget);
    expect(find.text(LangKeys.splashCredit.tr), findsOneWidget);

    await leaveSplash(tester);

    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('switching to an RTL locale flips Directionality', (tester) async {
    await tester.pumpWidget(MieoApp(settingsBox: settingsBox));
    await tester.pump();

    // Get.updateLocale() completes only after the next frame, and frames only
    // advance when the test pumps — so it's fired unawaited and pumped.
    unawaited(Get.updateLocale(LocalizationConstants.urdu));
    await tester.pumpAndSettle();

    final context = tester.element(find.text(LangKeys.splashTagline.tr));
    expect(Directionality.of(context), TextDirection.rtl);

    unawaited(Get.updateLocale(LocalizationConstants.english));
    await leaveSplash(tester);
  });
}

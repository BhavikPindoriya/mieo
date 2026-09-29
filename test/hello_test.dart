import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/commons/widgets/app_button.dart';
import 'package:mieo_ui8/commons/widgets/app_icon_button.dart';
import 'package:mieo_ui8/commons/widgets/app_top_bar.dart';
import 'package:mieo_ui8/commons/widgets/highlighted_text.dart';
import 'package:mieo_ui8/commons/widgets/meadow/meadow_stage.dart';
import 'package:mieo_ui8/commons/widgets/speech_bubble.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/core/routes/routes.dart';
import 'package:mieo_ui8/features/onboarding/screens/hello_screen.dart';
import 'package:mieo_ui8/features/onboarding/screens/onboarding_screen.dart';
import 'package:mieo_ui8/features/onboarding/screens/questions_intro_screen.dart';
import 'package:mieo_ui8/features/onboarding/widgets/hello_mascot.dart';
import 'package:mieo_ui8/features/onboarding/widgets/hello_mascot_painter.dart';

import 'helpers/talk_page.dart';
import 'helpers/test_app.dart';

// The "Hi! I’m Mieo" screen (Figma 62:3649 / dark 2159:37580): how the shared
// meadow stage is fitted to different panels, where the pieces land on the 375 × 812
// reference, the back button and the next step, a layout check across the
// Device Preview matrix in both themes and text directions, and the talk-page
// checks: Mieo's bubble pops in and types his words, and stays clear of the
// top bar at larger text.
void main() {
  group('MeadowStage', () {
    // Status bar 50 + top bar 80 on the reference; the "Hi! I’m Mieo" bubble
    // tops the must-see band.
    const topInset = referenceTopInset + AppTopBar.height;
    const bubbleTop = 382.0;

    MeadowStage fit(Size slot, {double inset = topInset, double maxScale = MeadowStage.designScale}) =>
        MeadowStage.fit(slot, mustSeeTop: bubbleTop, topInset: inset, maxScale: maxScale);

    test('is the identity on the reference, bottom-anchored like the Figma frame', () {
      final stage = fit(const Size(375, 716));
      expect(stage.scale, 1);
      expect(stage.frameRect, const Rect.fromLTWH(0, 0, 375, 716));
    });

    test('keeps the design size on a taller phone, centred, with more sky above', () {
      final stage = fit(const Size(430, 836));
      expect(stage.scale, 1);
      expect(stage.frameRect, const Rect.fromLTWH((430 - 375) / 2, 836 - 716, 375, 716));
    });

    test('keeps the design size on the iPhone SE, the bubble still clear of the top bar', () {
      // 667 − actions 96; status bar 20.
      const inset = 20 + AppTopBar.height;
      final stage = fit(const Size(375, 571), inset: inset);
      expect(stage.scale, 1);
      expect(stage.frameRect.top + bubbleTop, greaterThan(inset + MeadowStage.clearance));
    });

    test('shrinks to keep the bubble clear of the top bar, never below minScale', () {
      final stage = fit(const Size(375, 450));
      expect(stage.scale, inExclusiveRange(MeadowStage.minScale, 1));
      expect(stage.frameRect.top + bubbleTop * stage.scale, closeTo(topInset + MeadowStage.clearance, 1e-9));
      expect(stage.frameRect.bottom, 450);

      final atMinimum = fit(Size(375, MeadowStage.minSlotHeight(mustSeeTop: bubbleTop, topInset: topInset)));
      expect(atMinimum.scale, closeTo(MeadowStage.minScale, 1e-9));
      expect(fit(const Size(375, 200)).scale, MeadowStage.minScale);
    });

    test('grows on tablets up to the width of the content column', () {
      final stage = fit(const Size(768, 928), maxScale: MeadowStage.tabletMaxScale);
      expect(stage.scale, closeTo(MeadowStage.tabletMaxScale, 1e-9));
      expect(stage.frameRect.width, closeTo(ThemeConstants.maxContentWidth, 1e-9));
      expect(stage.frameRect.bottom, 928);
    });
  });

  group('HelloScreen', () {
    setUpAll(loadAppResources);

    testWidgets('shows Mieo’s greeting without its markers and the answer', (tester) async {
      await pumpScreen(tester, const HelloScreen());
      expect(find.text(LangKeys.helloGreeting.tr.replaceAll(HighlightedText.marker, '')), findsOneWidget);
      expect(find.text(LangKeys.helloSayHi.tr), findsOneWidget);
    });

    testWidgets('shows Mieo’s static pose on his Figma box where the Rive runtime isn’t running', (tester) async {
      await pumpScreen(tester, const HelloScreen());
      final pose = find.descendant(
        of: find.byType(HelloMascot),
        matching: find.byWidgetPredicate((widget) => widget is CustomPaint && widget.painter is HelloMascotPainter),
      );
      expect(pose, findsOneWidget);
      expect(tester.getRect(pose), const Offset(27, 451) & HelloMascotPainter.artworkSize);
    });

    testWidgets('places the top bar, bubble, Mieo and button at their Figma positions', (tester) async {
      await pumpScreen(tester, const HelloScreen());
      expect(tester.getRect(find.byType(AppTopBar)), const Rect.fromLTWH(0, 50, 375, AppTopBar.height));
      // Figma's text layer is 20 high (the older Nunito build's metrics); the
      // current font's line is 22, so the bubble is 46 high, not 44. It sits
      // on the Figma box's bottom edge, so its tail stays on its Figma pixel.
      expect(tester.getRect(find.byType(SpeechBubble)), const Rect.fromLTWH(120, 380, 129, 46));
      // Mieo's Rive artboard starts 20 above his Figma group, for the wave.
      expect(tester.getRect(find.byType(HelloMascot)), const Offset(27, 431) & HelloMascot.artboardSize);
      expect(tester.getRect(find.byType(AppButton)), const Rect.fromLTWH(16, 740, 343, 48));
    });

    testWidgets('mirrors the back button in RTL but keeps the scene', (tester) async {
      await pumpScreen(tester, const HelloScreen(), locale: LocalizationConstants.urdu);
      expect(tester.getTopRight(find.byType(AppBackButton)), const Offset(375 - 16, 66));
      expect(tester.getRect(find.byType(SpeechBubble)).center.dx, 120 + 129 / 2);
    });

    testWidgets('Say “Hi” opens the setup questions; back returns to onboarding', (tester) async {
      await pumpScreen(tester, const OnboardingScreen());
      await tester.tap(find.text(LangKeys.onboardingFreshStart.tr));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.accountSetup);
      expect(find.byType(HelloScreen), findsOneWidget);

      await tester.tap(find.text(LangKeys.helloSayHi.tr));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.setupQuestions);
      expect(find.byType(QuestionsIntroScreen), findsOneWidget);

      Get.back<void>();
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AppBackButton));
      await tester.pumpAndSettle();
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    // The Device Preview matrix (CLAUDE.md §8), light and dark, LTR and RTL:
    // nothing may overflow, and short screens scroll instead.
    for (final size in deviceMatrix) {
      final name = '${size.width.round()} × ${size.height.round()}';
      testWidgets('lays out on $name, light, LTR', (tester) async {
        await pumpScreen(tester, const HelloScreen(), size: size);
        expect(tester.takeException(), isNull);
      });
      testWidgets('lays out on $name, dark, RTL', (tester) async {
        await pumpScreen(
          tester,
          const HelloScreen(),
          size: size,
          themeMode: ThemeMode.dark,
          locale: LocalizationConstants.urdu,
        );
        expect(tester.takeException(), isNull);
      });
    }

    talkPageBubbleTests(const HelloScreen());
  });
}

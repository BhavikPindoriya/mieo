import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/commons/widgets/app_button.dart';
import 'package:mieo_ui8/commons/widgets/app_icon_button.dart';
import 'package:mieo_ui8/commons/widgets/app_top_bar.dart';
import 'package:mieo_ui8/commons/widgets/highlighted_text.dart';
import 'package:mieo_ui8/commons/widgets/speech_bubble.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/core/routes/routes.dart';
import 'package:mieo_ui8/features/onboarding/screens/hello_screen.dart';
import 'package:mieo_ui8/features/onboarding/screens/native_language_screen.dart';
import 'package:mieo_ui8/features/onboarding/screens/questions_intro_screen.dart';
import 'package:mieo_ui8/features/onboarding/widgets/please_mascot.dart';
import 'package:mieo_ui8/features/onboarding/widgets/please_mascot_painter.dart';

import 'helpers/talk_page.dart';
import 'helpers/test_app.dart';

// The "I just want to Ask you some Questions" screen (Figma 62:8081 / dark
// 2159:37689): where the pieces land on the 375 × 812 reference, the wrapping
// bubble, the back button and the next step, a layout check across the
// Device Preview matrix in both themes and text directions, and the talk-page
// checks: Mieo's bubble pops in and types his words, and stays clear of the
// top bar at larger text.
void main() {
  setUpAll(loadAppResources);

  Finder stillPose() => find.descendant(
    of: find.byType(PleaseMascot),
    matching: find.byWidgetPredicate((widget) => widget is CustomPaint && widget.painter is PleaseMascotPainter),
  );

  testWidgets('shows Mieo’s question without its markers and the answer', (tester) async {
    await pumpScreen(tester, const QuestionsIntroScreen());
    expect(find.text(LangKeys.questionsIntroMessage.tr.replaceAll(HighlightedText.marker, '')), findsOneWidget);
    expect(find.text(LangKeys.questionsIntroContinue.tr), findsOneWidget);
  });

  testWidgets('shows Mieo’s still pose on his Figma box where the Rive runtime isn’t running', (tester) async {
    await pumpScreen(tester, const QuestionsIntroScreen());
    expect(stillPose(), findsOneWidget);
    expect(tester.getRect(stillPose()), const Offset(73, 450) & PleaseMascotPainter.artworkSize);
  });

  testWidgets('places the top bar, bubble, Mieo and button at their Figma positions', (tester) async {
    await pumpScreen(tester, const QuestionsIntroScreen());
    expect(tester.getRect(find.byType(AppTopBar)), const Rect.fromLTWH(0, 50, 375, AppTopBar.height));
    // Two lines of 22 (Figma's stale text layer says 20), so the bubble is 68
    // high, not 64; it sits on the Figma box's bottom edge, 283 wide.
    expect(tester.getRect(find.byType(SpeechBubble)), const Rect.fromLTWH(43, 362, 283, 68));
    // The Rive artboard holds the Figma group at (12, 44).
    expect(tester.getRect(find.byType(PleaseMascot)), const Offset(73 - 12, 450 - 44) & PleaseMascot.artboardSize);
    expect(tester.getRect(find.byType(AppButton)), const Rect.fromLTWH(16, 740, 343, 48));
  });

  testWidgets('mirrors the back button in RTL but keeps the scene', (tester) async {
    await pumpScreen(tester, const QuestionsIntroScreen(), locale: LocalizationConstants.urdu);
    expect(tester.getTopRight(find.byType(AppBackButton)), const Offset(375 - 16, 66));
    expect(tester.getRect(find.byType(SpeechBubble)).center.dx, 43 + 283 / 2);
    expect(tester.getRect(stillPose()).topLeft, const Offset(73, 450));
  });

  testWidgets('Continue opens the first question; back returns to Hello', (tester) async {
    await pumpScreen(tester, const HelloScreen());
    await tester.tap(find.text(LangKeys.helloSayHi.tr));
    await tester.pumpAndSettle();
    expect(find.byType(QuestionsIntroScreen), findsOneWidget);

    await tester.tap(find.text(LangKeys.questionsIntroContinue.tr));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.setupNativeLanguage);
    expect(find.byType(NativeLanguageScreen), findsOneWidget);

    Get.back<void>();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();
    expect(find.byType(HelloScreen), findsOneWidget);
  });

  // The Device Preview matrix (CLAUDE.md §8), light and dark, LTR and RTL:
  // nothing may overflow, and short screens scroll instead.
  for (final size in deviceMatrix) {
    final name = '${size.width.round()} × ${size.height.round()}';
    testWidgets('lays out on $name, light, LTR', (tester) async {
      await pumpScreen(tester, const QuestionsIntroScreen(), size: size);
      expect(tester.takeException(), isNull);
    });
    testWidgets('lays out on $name, dark, RTL', (tester) async {
      await pumpScreen(
        tester,
        const QuestionsIntroScreen(),
        size: size,
        themeMode: ThemeMode.dark,
        locale: LocalizationConstants.urdu,
      );
      expect(tester.takeException(), isNull);
    });
  }

  talkPageBubbleTests(const QuestionsIntroScreen());
}

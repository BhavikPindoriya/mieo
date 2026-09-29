import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/commons/widgets/app_button.dart';
import 'package:mieo_ui8/commons/widgets/app_icon_button.dart';
import 'package:mieo_ui8/commons/widgets/app_tooltip_bubble.dart';
import 'package:mieo_ui8/commons/widgets/app_top_bar.dart';
import 'package:mieo_ui8/commons/widgets/glossy_progress_bar.dart';
import 'package:mieo_ui8/commons/widgets/highlighted_text.dart';
import 'package:mieo_ui8/commons/widgets/placeholder_screen.dart';
import 'package:mieo_ui8/commons/widgets/selectable_option_tile.dart';
import 'package:mieo_ui8/commons/widgets/speech_bubble.dart';
import 'package:mieo_ui8/core/constants/animation_constants.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/core/routes/routes.dart';
import 'package:mieo_ui8/features/onboarding/models/models.dart';
import 'package:mieo_ui8/features/onboarding/screens/daily_goal_screen.dart';
import 'package:mieo_ui8/features/onboarding/screens/learning_language_screen.dart';
import 'package:mieo_ui8/features/onboarding/screens/native_language_screen.dart';
import 'package:mieo_ui8/features/onboarding/screens/proficiency_screen.dart';
import 'package:mieo_ui8/features/onboarding/widgets/daily_goal_card.dart';
import 'package:mieo_ui8/features/onboarding/widgets/perched_mieo.dart';
import 'package:mieo_ui8/features/onboarding/widgets/setup_choice_list.dart';
import 'package:mieo_ui8/features/onboarding/widgets/signal_strength_icon.dart';

import 'helpers/test_app.dart';

// The setup questions (Figma New Account Progress "Survey" frames: native
// language 62:8472, learning language 62:10515, level 62:9688, daily goal
// 62:9100), all on SetupQuestionScaffold: where the shared pieces land on the
// 375 × 812 reference, Mieo typing his question, picking an answer, the
// minute picker and time tabs, the chain of questions and what each hands the
// next, RTL, the last answer scrolling clear of Next, and a layout check
// across the Device Preview matrix in both themes, both text directions and
// at text scale 1.3.
void main() {
  setUpAll(loadAppResources);

  const screens = <(String, Widget, SetupStep)>[
    ('native language', NativeLanguageScreen(), SetupStep.nativeLanguage),
    ('learning language', LearningLanguageScreen(), SetupStep.learningLanguage),
    ('level', ProficiencyScreen(), SetupStep.proficiency),
    ('daily goal', DailyGoalScreen(), SetupStep.dailyGoal),
  ];

  /// Rounding room for layout arithmetic.
  const tolerance = 0.01;

  /// The answers under Mieo: a choice list or the goal card.
  final answers = find.byWidgetPredicate((widget) => widget is SetupChoiceList || widget is DailyGoalCard);

  Finder tile(String label) => find.ancestor(of: find.text(label), matching: find.byType(SelectableOptionTile));

  List<String> pickedLabels(WidgetTester tester) => [
    for (final tile in tester.widgetList<SelectableOptionTile>(find.byType(SelectableOptionTile)))
      if (tile.selected) tile.label,
  ];

  group('question page', () {
    for (final (name, screen, step) in screens) {
      testWidgets('$name: places the top bar, Mieo, his bubble, the answers and Next at their Figma positions', (
        tester,
      ) async {
        await pumpScreen(tester, screen);
        expect(tester.getRect(find.byType(AppTopBar)), const Rect.fromLTWH(0, 50, 375, AppTopBar.height));
        // The bar fills the top bar's line, 16 after the back button and 16
        // from the edge: the 279 wide Figma bar.
        expect(
          tester.getRect(find.byType(GlossyProgressBar)),
          const Rect.fromLTWH(80, 77, 279, GlossyProgressBar.height),
        );

        final mieo = tester.getRect(find.byType(PerchedMieo));
        expect(mieo, const Offset(16, 146) & PerchedMieo.size);
        final bubble = tester.getRect(find.byType(SpeechBubble));
        expect(bubble.left, closeTo(mieo.right + 12, tolerance));
        expect(bubble.right, 359);
        expect(bubble.center.dy, closeTo(mieo.center.dy, tolerance));
        expect(tester.widget<SpeechBubble>(find.byType(SpeechBubble)).face, SpeechBubbleFace.start);

        final list = tester.getRect(answers);
        expect(list.top, closeTo(mieo.bottom + 32, tolerance));
        expect(list.left, 16);
        expect(list.right, 359);
        expect(tester.getRect(find.byType(AppButton)), const Rect.fromLTWH(16, 740, 343, 48));
      });

      testWidgets('$name: fills the progress bar to its step, growing from the step before', (tester) async {
        await pumpScreen(tester, screen);
        final bar = tester.widget<GlossyProgressBar>(find.byType(GlossyProgressBar));
        expect(bar.value, step.progress);
        expect(bar.from, step.previousProgress);
      });

      testWidgets('$name: Mieo’s bubble pops in after the page slides, then types his question', (tester) async {
        await pumpScreen(tester, screen, settle: false);
        final bubble = find.byType(SpeechBubble);
        final text = find.descendant(of: bubble, matching: find.byType(HighlightedText));
        expect(tester.widget<SpeechBubble>(bubble).entrance, SpeechBubbleEntrance.typing);
        await tester.pump(AnimationConstants.bubbleEntranceDelay + AnimationConstants.bubblePop);
        expect(tester.widget<HighlightedText>(text).visibleLength, greaterThan(0));

        await tester.pumpAndSettle();
        final question = tester.widget<HighlightedText>(text);
        expect(question.visibleLength, question.plainText.length);
        expect(find.text(question.plainText), findsOneWidget);
      });
    }

    test('the steps fill the Figma widths of the 279 wide bar', () {
      const barWidth = 279;
      const filled = [87, 146, 221, 243];
      for (final step in SetupStep.values) {
        expect(step.progress * barWidth, closeTo(filled[step.index], tolerance));
      }
      expect(SetupStep.nativeLanguage.previousProgress, 0);
      expect(SetupStep.dailyGoal.previousProgress, SetupStep.proficiency.progress);
    });

    testWidgets('underlines and accents the question’s marked word', (tester) async {
      await pumpScreen(tester, const NativeLanguageScreen());
      final question = tester.widget<SpeechBubble>(find.byType(SpeechBubble)).text;
      expect(question, contains('**${HighlightedText.underlineMarker}'));
      expect(find.text(HighlightedText(question).plainText), findsOneWidget);
    });

    testWidgets('mirrors in RTL: Mieo at the end, his bubble before him, the back button at the right', (tester) async {
      await pumpScreen(tester, const NativeLanguageScreen(), locale: LocalizationConstants.urdu);
      expect(tester.getTopRight(find.byType(AppBackButton)), const Offset(375 - 16, 66));
      final mieo = tester.getRect(find.byType(PerchedMieo));
      expect(mieo.right, 375 - 16);
      final bubble = tester.getRect(find.byType(SpeechBubble));
      expect(bubble.left, 16);
      expect(bubble.right, closeTo(mieo.left - 12, tolerance));
    });

    // Next floats over the page: on a short screen at larger text the page
    // scrolls, and at its end the last answer sits 24 above the button.
    for (final (name, screen, _) in screens) {
      testWidgets('$name: on an iPhone SE at text scale 1.3, the last answer scrolls clear of Next', (tester) async {
        await pumpScreen(tester, screen, size: const Size(375, 667), topInset: 20, bottomInset: 0, textScale: 1.3);
        await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -1000));
        await tester.pumpAndSettle();
        final next = tester.getRect(find.byType(AppButton));
        expect(tester.getRect(answers).bottom, lessThanOrEqualTo(next.top - ThemeConstants.spacing24 + tolerance));
      });
    }
  });

  group('answers', () {
    testWidgets('native language: Hindi is picked at first; tapping another picks it instead', (tester) async {
      await pumpScreen(tester, const NativeLanguageScreen());
      expect(tester.widgetList(find.byType(SelectableOptionTile)), hasLength(5));
      expect(pickedLabels(tester), [LangKeys.languageHindi.tr]);

      await tester.tap(find.text(LangKeys.languageFrench.tr));
      await tester.pumpAndSettle();
      expect(pickedLabels(tester), [LangKeys.languageFrench.tr]);
    });

    testWidgets('learning language: English (UK) is picked at first, each language with its flag', (tester) async {
      await pumpScreen(tester, const LearningLanguageScreen());
      expect(tester.widgetList(find.byType(SelectableOptionTile)), hasLength(6));
      expect(pickedLabels(tester), [LangKeys.languageEnglishUk.tr]);
    });

    testWidgets('level: basic words is picked at first; each level lights its share of the signal', (tester) async {
      await pumpScreen(tester, const ProficiencyScreen());
      expect(pickedLabels(tester), [LangKeys.proficiencyBasicWords.tr]);
      final icons = tester.widgetList<SignalStrengthIcon>(find.byType(SignalStrengthIcon)).toList();
      expect([for (final icon in icons) icon.strength], [0, 1, 2, 3]);
      expect([for (final icon in icons) icon.selected], [false, true, false, false]);

      await tester.tap(find.text(LangKeys.proficiencyChat.tr));
      await tester.pumpAndSettle();
      expect(pickedLabels(tester), [LangKeys.proficiencyChat.tr]);
    });

    testWidgets('screen readers hear each answer as a button in a group, and which one is selected', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpScreen(tester, const NativeLanguageScreen());
      final hindi = LangKeys.languageHindi.tr;
      final french = LangKeys.languageFrench.tr;
      expect(
        tester.getSemantics(tile(hindi)),
        isSemantics(label: hindi, isButton: true, isSelected: true, isInMutuallyExclusiveGroup: true),
      );
      expect(
        tester.getSemantics(tile(french)),
        isSemantics(label: french, isButton: true, isSelected: false, isInMutuallyExclusiveGroup: true),
      );
      semantics.dispose();
    });
  });

  group('daily goal card', () {
    ScrollPosition strip(WidgetTester tester) => tester
        .state<ScrollableState>(find.descendant(of: find.byType(DailyGoalCard), matching: find.byType(Scrollable)))
        .position;

    double tooltipScale(WidgetTester tester) => tester
        .widget<AnimatedScale>(find.ancestor(of: find.byType(AppTooltipBubble), matching: find.byType(AnimatedScale)))
        .scale;

    Finder pill() => find.descendant(
      of: find.descendant(of: find.byType(DailyGoalCard), matching: find.byType(AnimatedAlign)),
      matching: find.byType(DecoratedBox),
    );

    /// The middle of the strip, where the frame is.
    const frameX = 375 / 2;

    /// Distance between two goals.
    const goalExtent = 65.0;

    testWidgets('matches the Figma card: 15 in the frame, the tooltip on the strip, Morning picked', (tester) async {
      await pumpScreen(tester, const DailyGoalScreen());
      final card = tester.getRect(find.byType(DailyGoalCard));
      // 12 + the 58 strip + 16 + the 34 tabs + 12.
      expect(card.height, closeTo(132, tolerance));
      expect(tester.getCenter(find.text('15')).dx, frameX);
      expect(strip(tester).pixels, 2 * goalExtent);

      final tooltip = tester.getRect(find.byType(AppTooltipBubble));
      expect(tooltip.bottom, closeTo(card.top + ThemeConstants.spacing12, tolerance));
      expect(tooltip.center.dx, frameX);
      expect(tooltipScale(tester), 1);

      final morning = tester.getCenter(find.text(LangKeys.practiceTimeMorning.tr));
      expect(tester.getRect(pill()).center.dx, closeTo(morning.dx, tolerance));
      expect(tester.getSize(pill()).height, 34);
    });

    testWidgets('a tapped goal scrolls into the frame', (tester) async {
      await pumpScreen(tester, const DailyGoalScreen());
      await tester.tap(find.text('45'));
      await tester.pumpAndSettle();
      expect(strip(tester).pixels, 4 * goalExtent);
      expect(tester.getCenter(find.text('45')).dx, frameX);
    });

    testWidgets('a drag settles with a goal in the frame, the tooltip ducking away meanwhile', (tester) async {
      await pumpScreen(tester, const DailyGoalScreen());
      final gesture = await tester.startGesture(tester.getCenter(find.text('15')));
      for (var step = 0; step < 4; step++) {
        await gesture.moveBy(const Offset(-25, 0));
        await tester.pump();
      }
      expect(tooltipScale(tester), 0);
      await gesture.up();
      await tester.pumpAndSettle();

      final pixels = strip(tester).pixels;
      expect(pixels, greaterThan(2 * goalExtent));
      expect(pixels % goalExtent, closeTo(0, tolerance));
      expect(tooltipScale(tester), 1);
    });

    testWidgets('a fling past the end settles on the last goal', (tester) async {
      await pumpScreen(tester, const DailyGoalScreen());
      await tester.fling(find.text('15'), const Offset(-400, 0), 2000);
      await tester.pumpAndSettle();
      expect(strip(tester).pixels, 4 * goalExtent);
    });

    testWidgets('a tapped time of day takes the pill, each tab taking taps 48 high', (tester) async {
      await pumpScreen(tester, const DailyGoalScreen());
      final evening = find.text(LangKeys.practiceTimeEvening.tr);
      await tester.tap(evening);
      await tester.pumpAndSettle();
      expect(tester.getRect(pill()).center.dx, closeTo(tester.getCenter(evening).dx, tolerance));
      final tab = find.ancestor(of: evening, matching: find.byType(GestureDetector)).first;
      expect(tester.getSize(tab).height, ThemeConstants.minTapTarget);
    });

    testWidgets('in RTL the goals run from the right, 15 still in the frame', (tester) async {
      await pumpScreen(tester, const DailyGoalScreen(), locale: LocalizationConstants.urdu);
      expect(tester.getCenter(find.text('15')).dx, frameX);
      expect(tester.getCenter(find.text('05')).dx, greaterThan(frameX));
      expect(tester.getCenter(find.text('45')).dx, lessThan(frameX));
    });
  });

  testWidgets('Next walks the questions, handing on the language to learn and the daily goal', (tester) async {
    await pumpScreen(tester, const NativeLanguageScreen());
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.setupLearningLanguage);
    expect(find.byType(LearningLanguageScreen), findsOneWidget);

    await tester.tap(find.text(LangKeys.languageTamil.tr));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.setupProficiency);
    // The level question asks about the language just picked.
    final question = tester.widget<SpeechBubble>(find.byType(SpeechBubble)).text;
    expect(question, LangKeys.setupProficiencyMessage.trParams({'language': LangKeys.languageTamil.tr}));

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.setupDailyGoal);
    expect(find.byType(DailyGoalScreen), findsOneWidget);

    await tester.tap(find.text('30'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(LangKeys.practiceTimeEvening.tr));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, Routes.setupLoading);
    final goal = ModalRoute.settingsOf(tester.element(find.byType(PlaceholderScreen)))!.arguments! as DailyGoal;
    expect(goal.minutes, 30);
    expect(goal.time, PracticeTime.evening);

    Get.back<void>();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();
    expect(find.byType(ProficiencyScreen), findsOneWidget);
  });

  // The Device Preview matrix (CLAUDE.md §8): light LTR at text scale 1.0,
  // dark RTL at 1.3. Nothing may overflow; short screens scroll instead.
  for (final (name, screen, _) in screens) {
    for (final size in deviceMatrix) {
      final device = '${size.width.round()} × ${size.height.round()}';
      testWidgets('$name: lays out on $device, light, LTR', (tester) async {
        await pumpScreen(tester, screen, size: size);
        expect(tester.takeException(), isNull);
      });
      testWidgets('$name: lays out on $device, dark, RTL, text scale 1.3', (tester) async {
        await pumpScreen(
          tester,
          screen,
          size: size,
          themeMode: ThemeMode.dark,
          locale: LocalizationConstants.urdu,
          textScale: 1.3,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
}

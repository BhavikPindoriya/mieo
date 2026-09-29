import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/commons/widgets/highlighted_text.dart';
import 'package:mieo_ui8/commons/widgets/typewriter/typewriter_schedule.dart';
import 'package:mieo_ui8/commons/widgets/typewriter/typewriter_text.dart';
import 'package:mieo_ui8/core/constants/animation_constants.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';

import 'helpers/test_app.dart';

// TypewriterText and its schedule: the schedule times each character (whole
// graphemes, a beat after a phrase), and the widget waits out its delay, then
// types without ever changing size, rebuilding only when a character appears,
// and shows everything at once with animations turned off.
void main() {
  setUpAll(loadAppResources);

  const step = AnimationConstants.typewriterCharacter;

  group('TypewriterSchedule', () {
    test('shows a character per step, and waits after a phrase', () {
      final schedule = TypewriterSchedule('Hi! I’m Mieo');
      // H i ! (then a pause) ␠ I ’ m ␠ M i e o
      expect(schedule.visibleLength(Duration.zero), 1);
      expect(schedule.visibleLength(step * 2), 3);
      expect(schedule.visibleLength(step * (2 + TypewriterSchedule.pauseSteps) - step), 3);
      expect(schedule.visibleLength(step * (2 + TypewriterSchedule.pauseSteps)), 4);
      expect(schedule.duration, step * (11 + TypewriterSchedule.pauseSteps));
      expect(schedule.visibleLength(schedule.duration), 'Hi! I’m Mieo'.length);
    });

    test('pauses once after a run of punctuation, never at the end', () {
      final schedule = TypewriterSchedule('Yey..! Please...!');
      // Y e y . . ! (pause) ␠ P l e a s e . . . !
      expect(schedule.duration, step * (16 + TypewriterSchedule.pauseSteps));
      expect(schedule.visibleLength(step * 5), 6);
      expect(schedule.visibleLength(step * (5 + TypewriterSchedule.pauseSteps)), 7);
    });

    test('pauses after Urdu punctuation too', () {
      final schedule = TypewriterSchedule('جی۔ ہاں');
      expect(schedule.visibleLength(step * 2), 3);
      expect(schedule.visibleLength(step * (2 + TypewriterSchedule.pauseSteps) - step), 3);
      expect(schedule.visibleLength(step * (2 + TypewriterSchedule.pauseSteps)), 4);
    });

    test('never splits a character made of several code units', () {
      // A waving hand with a skin tone (four code units), and an e with a
      // combining accent (two).
      final schedule = TypewriterSchedule('👋🏽é!');
      expect(schedule.visibleLength(Duration.zero), 4);
      expect(schedule.visibleLength(step), 6);
      expect(schedule.visibleLength(step * 2), 7);
      expect(schedule.visibleLength(schedule.duration), 7);
    });

    test('shows nothing before typing starts, and nothing for no text', () {
      expect(TypewriterSchedule('Hi').visibleLength(-step), 0);
      final empty = TypewriterSchedule('');
      expect(empty.duration, Duration.zero);
      expect(empty.visibleLength(step), 0);
    });
  });

  group('TypewriterText', () {
    const text = 'Hi! I’m **Mieo**';
    const plain = 'Hi! I’m Mieo';

    Widget host({bool disableAnimations = false, String message = text, Duration delay = Duration.zero}) => MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: disableAnimations),
          child: Center(
            child: SizedBox(
              width: 240,
              child: TypewriterText(message, textAlign: TextAlign.center, delay: delay),
            ),
          ),
        ),
      ),
    );

    HighlightedText paragraphOf(WidgetTester tester) => tester.widget<HighlightedText>(find.byType(HighlightedText));

    int visibleIn(WidgetTester tester) => paragraphOf(tester).visibleLength!;

    testWidgets('types the text out straight away, never changing size', (tester) async {
      await tester.pumpWidget(host());
      final size = tester.getSize(find.byType(TypewriterText));
      expect(visibleIn(tester), 1);

      await tester.pump(step * 2);
      expect(visibleIn(tester), 3);
      expect(tester.getSize(find.byType(TypewriterText)), size);

      await tester.pumpAndSettle();
      expect(visibleIn(tester), plain.length);
      expect(tester.getSize(find.byType(TypewriterText)), size);
    });

    testWidgets('waits out its delay before the first character', (tester) async {
      const delay = AnimationConstants.bubblePop;
      await tester.pumpWidget(host(delay: delay));
      expect(visibleIn(tester), 0);
      await tester.pump(delay - step);
      expect(visibleIn(tester), 0);
      await tester.pump(step);
      expect(visibleIn(tester), 1);
      await tester.pumpAndSettle();
      expect(visibleIn(tester), plain.length);
    });

    testWidgets('rebuilds the paragraph only when a character appears', (tester) async {
      await tester.pumpWidget(host());
      final first = paragraphOf(tester);
      // A frame inside the first character's step: nothing new to show.
      await tester.pump(step ~/ 2);
      expect(paragraphOf(tester), same(first));
      await tester.pump(step ~/ 2);
      expect(paragraphOf(tester), isNot(same(first)));
      await tester.pumpAndSettle();
    });

    testWidgets('reads the whole text to a screen reader from the start', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(host(delay: AnimationConstants.bubblePop));
      expect(find.bySemanticsLabel(plain), findsOneWidget);
      await tester.pumpAndSettle();
      semantics.dispose();
    });

    testWidgets('shows the text at once with animations turned off', (tester) async {
      await tester.pumpWidget(host(disableAnimations: true, delay: AnimationConstants.bubblePop));
      expect(visibleIn(tester), plain.length);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('shows the rest at once when animations are turned off while typing', (tester) async {
      await tester.pumpWidget(host());
      await tester.pump(step);
      expect(visibleIn(tester), lessThan(plain.length));
      await tester.pumpWidget(host(disableAnimations: true));
      expect(visibleIn(tester), plain.length);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('shows a new text in full', (tester) async {
      await tester.pumpWidget(host());
      await tester.pump(step);
      await tester.pumpWidget(host(message: 'Yey'));
      expect(visibleIn(tester), 'Yey'.length);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}

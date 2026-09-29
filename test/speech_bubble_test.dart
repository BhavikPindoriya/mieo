import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/commons/widgets/highlighted_text.dart';
import 'package:mieo_ui8/commons/widgets/speech_bubble.dart';
import 'package:mieo_ui8/commons/widgets/typewriter/typewriter_text.dart';
import 'package:mieo_ui8/core/constants/animation_constants.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';

import 'helpers/test_app.dart';

// SpeechBubble (Figma Talk Bubble): its two widths, its two faces, its
// measured height, and the typing entrance: after the page's slide it pops out
// of its tail, then types its words out as soon as it is open, keeping its
// final size all along.
void main() {
  setUpAll(loadAppResources);

  const message = 'Yey..! I just want to Ask you some **Questions**. Please...!';
  const plain = 'Yey..! I just want to Ask you some Questions. Please...!';
  const entranceDelay = AnimationConstants.bubbleEntranceDelay;
  const step = AnimationConstants.typewriterCharacter;

  /// The width the bubble is laid out in, like the talk page's frame.
  const slotWidth = 375.0;

  Widget host(
    SpeechBubble bubble, {
    bool disableAnimations = false,
    bool textSpacing = false,
    TextDirection textDirection = TextDirection.ltr,
  }) => MaterialApp(
    theme: AppTheme.light,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(disableAnimations: disableAnimations)
            .applyTextStyleOverrides(
              lineHeightScaleFactorOverride: textSpacing ? 1.5 : null,
              letterSpacingOverride: textSpacing ? 1.2 : null,
              wordSpacingOverride: textSpacing ? 4 : null,
              paragraphSpacingOverride: null,
            ),
        child: Directionality(
          textDirection: textDirection,
          child: Material(
            child: Center(
              child: SizedBox(
                width: slotWidth,
                child: Center(child: bubble),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  double opacityOf(WidgetTester tester) => tester
      .widget<FadeTransition>(find.descendant(of: find.byType(SpeechBubble), matching: find.byType(FadeTransition)))
      .opacity
      .value;

  double scaleOf(WidgetTester tester) => tester
      .widget<ScaleTransition>(find.descendant(of: find.byType(SpeechBubble), matching: find.byType(ScaleTransition)))
      .scale
      .value;

  int visibleIn(WidgetTester tester) => tester.widget<HighlightedText>(find.byType(HighlightedText)).visibleLength!;

  testWidgets('without an entrance, is simply there with its words', (tester) async {
    await tester.pumpWidget(host(const SpeechBubble(message, width: 283)));
    expect(find.byType(TypewriterText), findsNothing);
    expect(find.descendant(of: find.byType(SpeechBubble), matching: find.byType(FadeTransition)), findsNothing);
    expect(tester.widget<HighlightedText>(find.byType(HighlightedText)).visibleLength, isNull);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('typing: waits for the page, pops up, then types, at its final size throughout', (tester) async {
    await tester.pumpWidget(host(const SpeechBubble(message, width: 283, entrance: SpeechBubbleEntrance.typing)));
    final size = tester.getSize(find.byType(SpeechBubble));
    expect(opacityOf(tester), 0);
    expect(scaleOf(tester), AnimationConstants.bubblePopScale);
    expect(visibleIn(tester), 0);

    // Still hidden until the page has slid in.
    await tester.pump(entranceDelay - step);
    expect(opacityOf(tester), 0);

    // Popping in, still blank.
    await tester.pump(AnimationConstants.bubblePop);
    expect(opacityOf(tester), 1);
    expect(visibleIn(tester), 0);

    // Open: the first word starts typing straight away.
    await tester.pump(step);
    expect(scaleOf(tester), 1);
    expect(visibleIn(tester), 1);

    await tester.pumpAndSettle();
    expect(visibleIn(tester), plain.length);
    expect(tester.getSize(find.byType(SpeechBubble)), size);
    expect(size.width, 283);
  });

  testWidgets('typing: a screen reader reads the words while the bubble is still hidden', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(host(const SpeechBubble(message, entrance: SpeechBubbleEntrance.typing)));
    expect(find.bySemanticsLabel(plain), findsOneWidget);
    await tester.pumpAndSettle();
    semantics.dispose();
  });

  testWidgets('typing: with animations turned off, is there with its words at once', (tester) async {
    await tester.pumpWidget(
      host(const SpeechBubble(message, entrance: SpeechBubbleEntrance.typing), disableAnimations: true),
    );
    expect(opacityOf(tester), 1);
    expect(scaleOf(tester), 1);
    expect(visibleIn(tester), plain.length);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('typing: animations turned off mid-entrance show the bubble and its words at once', (tester) async {
    await tester.pumpWidget(host(const SpeechBubble(message, entrance: SpeechBubbleEntrance.typing)));
    await tester.pump(entranceDelay + step);
    await tester.pumpWidget(
      host(const SpeechBubble(message, entrance: SpeechBubbleEntrance.typing), disableAnimations: true),
    );
    expect(opacityOf(tester), 1);
    expect(scaleOf(tester), 1);
    expect(visibleIn(tester), plain.length);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('typing: switched on after the first build, plays from the start; switched off, simply shows', (
    tester,
  ) async {
    await tester.pumpWidget(host(const SpeechBubble(message, width: 283)));
    await tester.pumpWidget(host(const SpeechBubble(message, width: 283, entrance: SpeechBubbleEntrance.typing)));
    expect(opacityOf(tester), 0);
    expect(visibleIn(tester), 0);
    await tester.pump(entranceDelay + AnimationConstants.bubblePop);
    expect(scaleOf(tester), 1);
    expect(visibleIn(tester), 1);
    await tester.pumpAndSettle();
    expect(visibleIn(tester), plain.length);

    await tester.pumpWidget(host(const SpeechBubble(message, width: 283)));
    expect(find.descendant(of: find.byType(SpeechBubble), matching: find.byType(FadeTransition)), findsNothing);
    expect(tester.widget<HighlightedText>(find.byType(HighlightedText)).visibleLength, isNull);
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('face start: the words align to the start and the bubble pops out of its start edge', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        host(
          SpeechBubble(
            message,
            key: ValueKey(direction),
            width: 189,
            face: SpeechBubbleFace.start,
            entrance: SpeechBubbleEntrance.typing,
          ),
          textDirection: direction,
        ),
      );
      final scale = tester.widget<ScaleTransition>(
        find.descendant(of: find.byType(SpeechBubble), matching: find.byType(ScaleTransition)),
      );
      expect(scale.alignment, AlignmentDirectional.centerStart.resolve(direction));
      await tester.pumpAndSettle();
      expect(tester.widget<HighlightedText>(find.byType(HighlightedText)).textAlign, TextAlign.start);
    }
  });

  testWidgets('face bottom: the words are centred and the bubble pops up from its bottom edge', (tester) async {
    await tester.pumpWidget(host(const SpeechBubble(message, width: 283, entrance: SpeechBubbleEntrance.typing)));
    final scale = tester.widget<ScaleTransition>(
      find.descendant(of: find.byType(SpeechBubble), matching: find.byType(ScaleTransition)),
    );
    expect(scale.alignment, Alignment.bottomCenter);
    await tester.pumpAndSettle();
    expect(tester.widget<HighlightedText>(find.byType(HighlightedText)).textAlign, TextAlign.center);
  });

  testWidgets('boxHeight measures the box as laid out, with either entrance and any text spacing', (tester) async {
    for (final textSpacing in [false, true]) {
      for (final entrance in SpeechBubbleEntrance.values) {
        for (final width in [null, 283.0]) {
          // Keyed by entrance, so each typing bubble mounts with its pop.
          final bubble = SpeechBubble(message, key: ValueKey(entrance), width: width, entrance: entrance);
          await tester.pumpWidget(host(bubble, textSpacing: textSpacing));
          final measured = bubble.boxHeight(tester.element(find.byType(SpeechBubble)), maxWidth: slotWidth);
          expect(measured, closeTo(tester.getSize(find.byType(SpeechBubble)).height, 0.01));
          await tester.pumpAndSettle();
        }
      }
    }
  });
}

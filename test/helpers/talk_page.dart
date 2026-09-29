import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/commons/widgets/app_top_bar.dart';
import 'package:mieo_ui8/commons/widgets/highlighted_text.dart';
import 'package:mieo_ui8/commons/widgets/meadow/meadow_stage.dart';
import 'package:mieo_ui8/commons/widgets/speech_bubble.dart';
import 'package:mieo_ui8/core/constants/animation_constants.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';

import 'test_app.dart';

// Checks every talk page (a MeadowTalkScaffold screen) shares:
//   • Mieo talks: once the page has slid in, the bubble pops up and, as soon
//     as it is open, types his words out, at its final size throughout.
//   • The bubble grows upwards from its Figma bottom edge, so on short,
//     landscape and tablet screens, at text scale 1.0 and 1.3, in English and
//     Urdu, SpeechBubble.boxHeight must measure the bubble as laid out and the
//     stage must keep its top MeadowStage.clearance below the top bar.

/// Screens whose scene the stage shrinks or scrolls, with their status bar.
const List<(Size, double)> _shortScreens = [
  (Size(375, 667), 20), // iPhone SE
  (Size(320, 568), 20),
  (Size(812, 375), 0), // phone, landscape
  (Size(1024, 768), 24), // iPad, landscape
];

const List<double> _textScales = [1, 1.3];

const List<Locale> _locales = [LocalizationConstants.english, LocalizationConstants.urdu];

/// Rounding room for layout arithmetic.
const double _tolerance = 0.01;

void talkPageBubbleTests(Widget screen) {
  testWidgets('pops the bubble in after the page slides, then types Mieo’s words', (tester) async {
    await pumpScreen(tester, screen, settle: false);
    final bubble = find.byType(SpeechBubble);
    final rect = tester.getRect(bubble);
    int visible() => tester
        .widget<HighlightedText>(find.descendant(of: bubble, matching: find.byType(HighlightedText)))
        .visibleLength!;
    double opacity() =>
        tester.widget<FadeTransition>(find.descendant(of: bubble, matching: find.byType(FadeTransition))).opacity.value;

    expect(tester.widget<SpeechBubble>(bubble).entrance, SpeechBubbleEntrance.typing);
    expect(opacity(), 0);
    await tester.pump(
      AnimationConstants.bubbleEntranceDelay + AnimationConstants.bubblePop - AnimationConstants.typewriterCharacter,
    );
    expect(opacity(), 1);
    expect(visible(), 0);
    await tester.pump(AnimationConstants.typewriterCharacter);
    expect(visible(), greaterThan(0));

    await tester.pumpAndSettle();
    final message = tester.widget<SpeechBubble>(bubble).text;
    expect(visible(), message.replaceAll(HighlightedText.marker, '').length);
    expect(tester.getRect(bubble), rect);
  });

  for (final (size, topInset) in _shortScreens) {
    for (final textScale in _textScales) {
      for (final locale in _locales) {
        final name = '${size.width.round()} × ${size.height.round()}, text scale $textScale, ${locale.languageCode}';
        testWidgets('keeps the bubble clear of the top bar on $name', (tester) async {
          await pumpScreen(tester, screen, size: size, topInset: topInset, textScale: textScale, locale: locale);
          expect(tester.takeException(), isNull);

          final bubble = find.byType(SpeechBubble);
          final measured = tester
              .widget<SpeechBubble>(bubble)
              .boxHeight(tester.element(bubble), maxWidth: MeadowStage.frameSize.width);
          expect(measured, closeTo(tester.getSize(bubble).height, _tolerance));

          final topBar = tester.getRect(find.byType(AppTopBar));
          expect(tester.getRect(bubble).top, greaterThanOrEqualTo(topBar.bottom + MeadowStage.clearance - _tolerance));
        });
      }
    }
  }
}

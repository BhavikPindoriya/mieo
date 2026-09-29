import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/commons/widgets/highlighted_text.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/core/theme/colors.dart';

// HighlightedText: `**`-marked runs take the highlight colour and `__`-marked
// runs are underlined; the rest keeps the style, and the markers never reach
// the screen. A visible length hides the rest of the text without moving it,
// and textPainter measures the text as it is drawn.
void main() {
  List<TextSpan> runsOf(WidgetTester tester) {
    final text = tester.widget<Text>(find.byType(Text));
    final span = text.textSpan! as TextSpan;
    return span.children!.cast<TextSpan>();
  }

  testWidgets('draws the marked word in Texts/primary and drops the markers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const HighlightedText('Learn any **Language** Faster then ever.')),
    );
    final runs = runsOf(tester);
    expect(runs.map((run) => run.text), ['Learn any ', 'Language', ' Faster then ever.']);
    expect(runs[0].style, isNull);
    expect(runs[1].style?.color, AppColorTokens.light.text.primary);
    expect(runs[2].style, isNull);
    expect(find.text('Learn any Language Faster then ever.'), findsOneWidget);
  });

  testWidgets('takes a custom highlight colour, and highlights a leading word', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HighlightedText('**Hi!** I am Mieo', highlightColor: AppColors.secondary700)),
    );
    final runs = runsOf(tester);
    expect(runs.map((run) => run.text), ['Hi!', ' I am Mieo']);
    expect(runs[0].style?.color, AppColors.secondary700);
    expect(runs[1].style, isNull);
  });

  testWidgets('with a visible length, draws only the start and keeps the rest in place, transparent', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const HighlightedText('Hi! I am **Mieo**', visibleLength: 11)),
    );
    final runs = runsOf(tester);
    expect(runs.map((run) => run.text), ['Hi! I am ', 'Mi', 'eo']);
    expect(runs[0].style, isNull);
    expect(runs[1].style?.color, AppColorTokens.light.text.primary);
    expect(runs[2].style?.color, Colors.transparent);
    expect(find.text('Hi! I am Mieo'), findsOneWidget);
  });

  testWidgets('textPainter lays the text out exactly as it is drawn', (tester) async {
    // As is, at text scale 1.3, with bold text, and with the platform's
    // text-spacing settings.
    final settings = <MediaQueryData Function(MediaQueryData data)>[
      (data) => data,
      (data) => data.copyWith(textScaler: const TextScaler.linear(1.3)),
      (data) => data.copyWith(boldText: true),
      (data) => data.applyTextStyleOverrides(
        lineHeightScaleFactorOverride: 1.5,
        letterSpacingOverride: 1.2,
        wordSpacingOverride: 4,
        paragraphSpacingOverride: null,
      ),
    ];
    for (final setting in settings) {
      late HighlightedText widget;
      late TextPainter painter;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (context) => MediaQuery(
              data: setting(MediaQuery.of(context)),
              child: Material(
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: Builder(
                      builder: (context) {
                        widget = const HighlightedText(
                          'Learn any **Language** Faster then ever.',
                          textAlign: TextAlign.center,
                        );
                        painter = widget.textPainter(context);
                        return widget;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      painter.layout(minWidth: 200, maxWidth: 200);
      expect(painter.text!.style, tester.widget<RichText>(find.byType(RichText)).text.style);
      expect(Size(painter.width, painter.height), tester.getSize(find.byType(HighlightedText)));
      const all = TextSelection(baseOffset: 0, extentOffset: 'Learn any Language Faster then ever.'.length);
      expect(
        painter.getBoxesForSelection(all),
        tester.renderObject<RenderParagraph>(find.byType(RichText)).getBoxesForSelection(all),
      );
      painter.dispose();
    }
  });

  testWidgets('underlines runs between double underscores, accented or not, and drops those markers', (tester) async {
    const text = HighlightedText('Your **__Native__** and __own__ tongue');
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: text));
    final runs = runsOf(tester);
    expect(runs.map((run) => run.text), ['Your ', 'Native', ' and ', 'own', ' tongue']);
    expect(runs[0].style, isNull);
    expect(runs[1].style?.color, AppColorTokens.light.text.primary);
    expect(runs[1].style?.decoration, TextDecoration.underline);
    expect(runs[3].style?.color, isNull);
    expect(runs[3].style?.decoration, TextDecoration.underline);
    expect(runs[4].style, isNull);
    expect(text.plainText, 'Your Native and own tongue');
    expect(find.text(text.plainText), findsOneWidget);
  });

  testWidgets('a visible length counts only the words, not the underline markers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const HighlightedText('Your **__Native__** tongue', visibleLength: 8)),
    );
    final runs = runsOf(tester);
    expect(runs.map((run) => run.text), ['Your ', 'Nat', 'ive', ' tongue']);
    expect(runs[1].style?.decoration, TextDecoration.underline);
    expect(runs[2].style?.color, Colors.transparent);
    expect(runs[3].style?.color, Colors.transparent);
  });

  testWidgets('text without markers is one plain run', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: const HighlightedText('Resume Journey')));
    final runs = runsOf(tester);
    expect(runs.map((run) => run.text), ['Resume Journey']);
    expect(runs.single.style, isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/commons/widgets/app_radio.dart';
import 'package:mieo_ui8/commons/widgets/app_tooltip_bubble.dart';
import 'package:mieo_ui8/commons/widgets/app_top_bar.dart';
import 'package:mieo_ui8/commons/widgets/glossy_progress_bar.dart';
import 'package:mieo_ui8/commons/widgets/selectable_option_tile.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/core/theme/colors.dart';

import 'helpers/test_app.dart';

// The shared pieces of the setup question screens: the radio (Figma Radio
// Button), the option tile it sits on (Input Option), the glossy progress bar
// (Progress Bar), the tooltip (Tool Tip) and the top bar's centre slot.
void main() {
  setUpAll(loadAppResources);

  const colors = AppColorTokens.light;

  Widget host(Widget child, {TextDirection textDirection = TextDirection.ltr}) => MaterialApp(
    theme: AppTheme.light,
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsetsDirectional.all(ThemeConstants.spacing16),
          child: Align(alignment: AlignmentDirectional.topStart, child: child),
        ),
      ),
    ),
  );

  BoxDecoration decorationIn(WidgetTester tester, Finder widget) =>
      tester.widget<DecoratedBox>(find.descendant(of: widget, matching: find.byType(DecoratedBox)).first).decoration
          as BoxDecoration;

  group('AppRadio', () {
    double dotScale(WidgetTester tester) => tester
        .widget<AnimatedScale>(find.descendant(of: find.byType(AppRadio), matching: find.byType(AnimatedScale)))
        .scale;

    testWidgets('off: an outlined 21 circle on a hard shadow 2, no dot', (tester) async {
      await tester.pumpWidget(host(const AppRadio(selected: false)));
      expect(tester.getSize(find.byType(AppRadio)), const Size.square(AppRadio.size));
      final decoration = decorationIn(tester, find.byType(AppRadio));
      expect(decoration.color, colors.surface.backgroundNeutral);
      expect((decoration.border! as Border).top.color, colors.surface.extraDimNeutral);
      expect(decoration.boxShadow!.single.offset.dy, ThemeConstants.hardShadowOffsetSm);
      expect(dotScale(tester), 0);
    });

    testWidgets('on: a Surface/Primary circle with the dot, no outline or shadow', (tester) async {
      await tester.pumpWidget(host(const AppRadio(selected: true)));
      final decoration = decorationIn(tester, find.byType(AppRadio));
      expect(decoration.color, colors.surface.primary);
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, isNull);
      expect(dotScale(tester), 1);
    });
  });

  group('SelectableOptionTile', () {
    Widget tile({required bool selected, VoidCallback? onPressed}) => SizedBox(
      width: 343,
      child: SelectableOptionTile(
        icon: const Icon(Icons.flag),
        label: 'Hindi',
        selected: selected,
        onPressed: onPressed ?? () {},
      ),
    );

    testWidgets('is 56 high: the icon 24 in, the label 16 after it, the radio 16 from the end', (tester) async {
      await tester.pumpWidget(host(tile(selected: false)));
      final box = tester.getRect(find.byType(SelectableOptionTile));
      expect(box.height, 56);
      expect(tester.getTopLeft(find.byIcon(Icons.flag)).dx, box.left + 24);
      expect(tester.getTopLeft(find.text('Hindi')).dx, box.left + 24 + 24 + 16);
      expect(tester.getTopRight(find.byType(AppRadio)).dx, box.right - 16);
    });

    testWidgets('off: outlined in Stroke/Extra Dim/Nuturel on a hard shadow 2', (tester) async {
      await tester.pumpWidget(host(tile(selected: false)));
      final decoration = decorationIn(tester, find.byType(SelectableOptionTile));
      expect(decoration.color, colors.surface.backgroundNeutral);
      expect((decoration.border! as Border).top.color, colors.stroke.extraDimNeutral);
      expect(decoration.boxShadow!.single.color, colors.shadow.neutralExtraLight);
      expect(decoration.boxShadow!.single.offset.dy, ThemeConstants.hardShadowOffsetSm);
      expect(tester.widget<AppRadio>(find.byType(AppRadio)).selected, isFalse);
    });

    testWidgets('on: Surface/Extra Dim/Primary in a Stroke/Primary outline on a hard shadow 4', (tester) async {
      await tester.pumpWidget(host(tile(selected: true)));
      final decoration = decorationIn(tester, find.byType(SelectableOptionTile));
      expect(decoration.color, Color.alphaBlend(colors.surface.extraDimPrimary, colors.surface.body));
      expect((decoration.border! as Border).top.color, colors.stroke.primary);
      expect(decoration.boxShadow!.single.color, colors.shadow.primaryFull);
      expect(decoration.boxShadow!.single.offset.dy, ThemeConstants.hardShadowOffset);
      expect(tester.widget<AppRadio>(find.byType(AppRadio)).selected, isTrue);
    });

    testWidgets('takes taps, and mirrors in RTL: the icon at the right, the radio at the left', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(tile(selected: false, onPressed: () => taps++), textDirection: TextDirection.rtl));
      final box = tester.getRect(find.byType(SelectableOptionTile));
      expect(tester.getTopRight(find.byIcon(Icons.flag)).dx, box.right - 24);
      expect(tester.getTopLeft(find.byType(AppRadio)).dx, box.left + 16);
      await tester.tap(find.byType(SelectableOptionTile));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });
  });

  group('GlossyProgressBar', () {
    TweenAnimationBuilder<double> fill(WidgetTester tester) => tester.widget<TweenAnimationBuilder<double>>(
      find.descendant(of: find.byType(GlossyProgressBar), matching: find.byType(TweenAnimationBuilder<double>)),
    );

    testWidgets('is a 26-high pill on a hard shadow 2 in Shadow/Primary/Lighter, outlined 1px outside', (tester) async {
      await tester.pumpWidget(host(const SizedBox(width: 279, child: GlossyProgressBar(value: 0.5))));
      expect(tester.getSize(find.byType(GlossyProgressBar)), const Size(279, GlossyProgressBar.height));
      final decoration = decorationIn(tester, find.byType(GlossyProgressBar));
      expect(decoration.color, colors.icon.onNeutral);
      final outline = (decoration.border! as Border).top;
      expect(outline.color, colors.stroke.dimPrimary);
      expect(outline.width, 1);
      expect(outline.strokeAlign, BorderSide.strokeAlignOutside);
      expect(decoration.boxShadow!.single.color, colors.shadow.primaryLighter);
      expect(decoration.boxShadow!.single.offset.dy, ThemeConstants.hardShadowOffsetSm);
    });

    testWidgets('grows from where it starts to its value, and reads as a percentage', (tester) async {
      final semantics = tester.ensureSemantics();
      // Through the app's translations, for the percentage.
      await pumpScreen(
        tester,
        const Scaffold(
          body: Center(child: SizedBox(width: 279, child: GlossyProgressBar(value: 0.5, from: 0.25))),
        ),
        settle: false,
      );
      expect(fill(tester).tween.begin, 0.25);
      expect(fill(tester).tween.end, 0.5);
      expect(tester.getSemantics(find.byType(GlossyProgressBar)), isSemantics(value: '50%'));
      await tester.pumpAndSettle();
      semantics.dispose();
    });

    testWidgets('without a start, shows its value straight away', (tester) async {
      await tester.pumpWidget(host(const SizedBox(width: 279, child: GlossyProgressBar(value: 0.5))));
      expect(fill(tester).tween.begin, 0.5);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('AppTooltipBubble', () {
    testWidgets('is its label in label/medium between 12 and 8 paddings; the tail hangs outside', (tester) async {
      await tester.pumpWidget(host(const AppTooltipBubble('Nice')));
      final bubble = tester.getRect(find.byType(AppTooltipBubble));
      final label = tester.getRect(find.text('Nice'));
      expect(label.left - bubble.left, ThemeConstants.spacing12);
      expect(bubble.right - label.right, ThemeConstants.spacing12);
      expect(label.top - bubble.top, ThemeConstants.spacing8);
      expect(bubble.bottom - label.bottom, ThemeConstants.spacing8);
      final text = tester.widget<Text>(find.text('Nice'));
      expect(text.style?.color, colors.text.onPrimary);
      expect(text.style?.fontSize, AppTheme.light.textTheme.labelMedium?.fontSize);
    });
  });

  group('AppTopBar', () {
    testWidgets('puts a centre widget in the title’s place, 16 after the back button and 16 from the end', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Column(children: [AppTopBar(center: GlossyProgressBar(value: 0.5))]),
          ),
        ),
      );
      final bar = tester.getRect(find.byType(GlossyProgressBar));
      expect(bar.left, 16 + 48 + 16);
      expect(bar.right, 800 - 16);
      expect(bar.center.dy, AppTopBar.height / 2);
    });
  });
}

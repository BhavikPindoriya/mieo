import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/commons/widgets/app_button.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/core/theme/colors.dart';

// AppButton: size, tap handling, the press animation (sinking into the hard
// shadow) and the disabled state, for each Figma variant.
void main() {
  Widget host(Widget button, {ThemeData? theme}) => MaterialApp(
    theme: theme ?? AppTheme.light,
    home: Scaffold(body: Center(child: button)),
  );

  // Vertical offset of the button's box: 0 at rest, the shadow offset when
  // fully pressed.
  double sinkOf(WidgetTester tester) {
    final transform = tester.widget<Transform>(
      find.descendant(of: find.byType(AppButton), matching: find.byType(Transform)),
    );
    return transform.transform.getTranslation().y;
  }

  BoxDecoration decorationOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find.descendant(of: find.byType(AppButton), matching: find.byType(DecoratedBox)),
    );
    return box.decoration as BoxDecoration;
  }

  testWidgets('is 48 high, fills the width and shows its label', (tester) async {
    await tester.pumpWidget(host(AppButton(label: 'Continue', onPressed: () {})));
    expect(tester.getSize(find.byType(AppButton)), const Size(800, ThemeConstants.buttonHeight));
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('calls onPressed when tapped', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(AppButton(label: 'Continue', onPressed: () => taps++)));
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('sinks into its shadow while held down, and rises when released', (tester) async {
    await tester.pumpWidget(host(AppButton(label: 'Continue', onPressed: () {})));
    expect(sinkOf(tester), 0);
    expect(decorationOf(tester).boxShadow!.single.offset.dy, ThemeConstants.hardShadowOffset);

    final gesture = await tester.startGesture(tester.getCenter(find.byType(AppButton)));
    await tester.pump(kPressTimeout);
    await tester.pumpAndSettle();
    expect(sinkOf(tester), ThemeConstants.hardShadowOffset);
    expect(decorationOf(tester).boxShadow!.single.offset.dy, 0);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(sinkOf(tester), 0);
  });

  testWidgets('a null onPressed disables the button: no sink, disabled colours', (tester) async {
    await tester.pumpWidget(host(const AppButton(label: 'Continue', onPressed: null)));
    final gesture = await tester.startGesture(tester.getCenter(find.byType(AppButton)));
    await tester.pump(kPressTimeout);
    await tester.pumpAndSettle();
    expect(sinkOf(tester), 0);
    await gesture.up();

    const colors = AppColorTokens.light;
    expect(decorationOf(tester).color, colors.surface.backgroundNeutral);
    expect(decorationOf(tester).boxShadow!.single.color, colors.shadow.neutralExtraLight);
    expect(tester.widget<Text>(find.text('Continue')).style?.color, AppColors.neutral300);
  });

  testWidgets('each variant uses its Figma tokens, in both themes', (tester) async {
    for (final (theme, colors) in [(AppTheme.light, AppColorTokens.light), (AppTheme.dark, AppColorTokens.dark)]) {
      await tester.pumpWidget(
        host(
          AppButton(label: 'Continue', onPressed: () {}),
          theme: theme,
        ),
      );
      await tester.pumpAndSettle();
      expect(decorationOf(tester).color, colors.surface.primary);
      expect(decorationOf(tester).border, isNull);
      expect(decorationOf(tester).boxShadow!.single.color, colors.shadow.primaryDarker);
      expect(tester.widget<Text>(find.text('Continue')).style?.color, colors.text.onPrimary);

      await tester.pumpWidget(
        host(
          AppButton(label: 'Continue', variant: AppButtonVariant.outlined, onPressed: () {}),
          theme: theme,
        ),
      );
      await tester.pumpAndSettle();
      expect(decorationOf(tester).color, colors.surface.backgroundNeutral);
      expect((decorationOf(tester).border! as Border).top.color, colors.stroke.neutral);
      expect(decorationOf(tester).boxShadow!.single.color, colors.shadow.neutralFull);
      expect(tester.widget<Text>(find.text('Continue')).style?.color, colors.text.heading);
    }
  });
}

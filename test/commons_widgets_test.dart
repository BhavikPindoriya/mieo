import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/commons/models/enums/gender.dart';
import 'package:mieo_ui8/commons/models/profile_details.dart';
import 'package:mieo_ui8/commons/widgets/app_icon_button.dart';
import 'package:mieo_ui8/commons/widgets/app_social_button.dart';
import 'package:mieo_ui8/commons/widgets/app_tap_target.dart';
import 'package:mieo_ui8/commons/widgets/app_text_link.dart';
import 'package:mieo_ui8/commons/widgets/app_top_bar.dart';
import 'package:mieo_ui8/commons/widgets/labeled_divider.dart';
import 'package:mieo_ui8/commons/widgets/profile_form_fields.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/core/theme/colors.dart';

import 'helpers/test_app.dart';

// The shared building blocks of the form screens: the icon and back buttons
// (Figma Back Button), the top bar (TopAppBar General), the social sign-in
// button, the text link with its tap target, and the labelled divider.
void main() {
  setUpAll(loadAppResources);

  const colors = AppColorTokens.light;

  Widget host(Widget child, {TextDirection textDirection = TextDirection.ltr}) => MaterialApp(
    theme: AppTheme.light,
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(
        body: Padding(padding: const EdgeInsetsDirectional.all(ThemeConstants.spacing16), child: child),
      ),
    ),
  );

  BoxDecoration decorationIn(WidgetTester tester, Finder widget) =>
      tester.widget<DecoratedBox>(find.descendant(of: widget, matching: find.byType(DecoratedBox)).first).decoration
          as BoxDecoration;

  double sinkIn(WidgetTester tester, Finder widget) => tester
      .widget<Transform>(find.descendant(of: widget, matching: find.byType(Transform)).first)
      .transform
      .getTranslation()
      .y;

  group('AppIconButton', () {
    testWidgets('is a 48 square that sinks 2 into its shadow while held', (tester) async {
      // Disposed at the end of the body: flutter_test fails a test whose
      // handle is still open when the body returns, before tear-downs run.
      final semantics = tester.ensureSemantics();
      var taps = 0;
      await tester.pumpWidget(
        host(
          Align(
            alignment: AlignmentDirectional.topStart,
            child: AppIconButton(icon: const Icon(Icons.add), semanticLabel: 'Add', onPressed: () => taps++),
          ),
        ),
      );
      final button = find.byType(AppIconButton);
      expect(tester.getSize(button), const Size.square(AppIconButton.size));
      final decoration = decorationIn(tester, button);
      expect((decoration.border! as Border).top.color, colors.stroke.extraDimNeutral);
      expect(decoration.boxShadow!.single.color, colors.shadow.neutralExtraLight);
      expect(decoration.boxShadow!.single.offset.dy, ThemeConstants.hardShadowOffsetSm);

      final gesture = await tester.startGesture(tester.getCenter(button));
      await tester.pump(kPressTimeout);
      await tester.pumpAndSettle();
      expect(sinkIn(tester, button), ThemeConstants.hardShadowOffsetSm);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(sinkIn(tester, button), 0);
      expect(taps, 1);
      expect(find.bySemanticsLabel('Add'), findsOneWidget);
      semantics.dispose();
    });
  });

  group('AppBackButton', () {
    testWidgets('goes back a page', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(body: Text('First')),
        ),
      );
      Get.to<void>(() => const Scaffold(body: Center(child: AppBackButton())));
      await tester.pumpAndSettle();
      expect(find.text('First'), findsNothing);

      await tester.tap(find.byType(AppBackButton));
      await tester.pumpAndSettle();
      expect(find.text('First'), findsOneWidget);
    });

    testWidgets('points its arrow the other way in RTL', (tester) async {
      await tester.pumpWidget(host(AppBackButton(onPressed: () {}), textDirection: TextDirection.rtl));
      final arrow = tester.widget<SvgPicture>(
        find.descendant(of: find.byType(AppBackButton), matching: find.byType(SvgPicture)),
      );
      expect(arrow.matchTextDirection, isTrue);
    });
  });

  group('AppTopBar', () {
    testWidgets('is 80 high with the back button 16 in, then the title 16 after it', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: Column(
              children: [AppTopBar(title: 'Edit Profile', background: AppTopBarBackground.card)],
            ),
          ),
        ),
      );
      final bar = find.byType(AppTopBar);
      expect(tester.getSize(bar).height, AppTopBar.height);
      expect(AppTopBar.height, 80);
      expect(tester.getTopLeft(find.byType(AppBackButton)), const Offset(16, 16));
      expect(tester.getTopLeft(find.text('Edit Profile')).dx, 16 + AppIconButton.size + 16);
      expect(decorationIn(tester, bar).color, colors.surface.backgroundNeutral);
    });

    testWidgets('leaves the page showing through without a background', (tester) async {
      await tester.pumpWidget(host(const AppTopBar()));
      expect(decorationIn(tester, find.byType(AppTopBar)).color, isNull);
      expect(find.byType(AppBackButton), findsOneWidget);
    });
  });

  group('AppSocialButton', () {
    testWidgets('is 52 high with a 2px border inside and a hard shadow 4 below', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(AppSocialButton(icon: const Icon(Icons.mail), label: 'Google', onPressed: () => taps++)),
      );
      final button = find.byType(AppSocialButton);
      expect(tester.getSize(button).height, ThemeConstants.fieldHeight);
      final decoration = decorationIn(tester, button);
      final border = (decoration.border! as Border).top;
      expect(border.width, 2);
      expect(border.strokeAlign, BorderSide.strokeAlignInside);
      expect(border.color, colors.stroke.extraDimNeutral);
      expect(decoration.boxShadow!.single.offset.dy, ThemeConstants.hardShadowOffset);
      expect(decoration.boxShadow!.single.spreadRadius, 0);
      expect(tester.widget<Text>(find.text('Google')).style?.color, colors.text.body);

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(taps, 1);
    });
  });

  group('AppTapTarget', () {
    testWidgets('takes taps in a 48 square around a small child without growing', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          Column(
            children: [
              const SizedBox(height: ThemeConstants.spacing48),
              AppTapTarget(
                child: GestureDetector(
                  key: const Key('dot'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => taps++,
                  child: const SizedBox.square(dimension: ThemeConstants.iconSize16),
                ),
              ),
              const SizedBox(height: ThemeConstants.spacing48),
            ],
          ),
        ),
      );
      final child = tester.getRect(find.byKey(const Key('dot')));
      expect(child.size, const Size.square(ThemeConstants.iconSize16));
      expect(tester.getSize(find.byType(AppTapTarget)).height, ThemeConstants.iconSize16);

      // 12 beyond the 16 square: inside the 48 target.
      await tester.tapAt(child.center + const Offset(0, 20));
      await tester.tapAt(child.center - const Offset(20, 0));
      await tester.pump();
      expect(taps, 2);
      await tester.tapAt(child.center + const Offset(0, 30));
      await tester.pump();
      expect(taps, 2);
    });
  });

  group('AppTextLink', () {
    testWidgets('underlines its label, sits at its alignment and reports taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextLink(label: 'Forgot', alignment: AlignmentDirectional.centerEnd, onPressed: () => taps++),
            ],
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('Forgot'));
      expect(text.style?.decoration, TextDecoration.underline);
      expect(tester.getTopRight(find.text('Forgot')).dx, 800 - ThemeConstants.spacing16);

      await tester.tap(find.text('Forgot'));
      await tester.pump();
      expect(taps, 1);
    });
  });

  group('ProfileFormController', () {
    test('starts from the given details and reads the entered ones back', () {
      final form = ProfileFormController(
        const ProfileDetails(fullName: 'Jenny Frost', email: 'jennyfrost@gmail.com', gender: Gender.female, age: 8),
      );
      addTearDown(form.dispose);
      expect(form.fullName.text, 'Jenny Frost');
      expect(form.age.text, '8');
      expect(form.gender.value, Gender.female);

      form.fullName.text = ' Jenny ';
      form.age.text = '9';
      form.gender.value = Gender.other;
      final details = form.details;
      expect(details.fullName, 'Jenny');
      expect(details.email, 'jennyfrost@gmail.com');
      expect(details.gender, Gender.other);
      expect(details.age, 9);
    });

    test('starts empty without details', () {
      final form = ProfileFormController();
      addTearDown(form.dispose);
      expect(form.fullName.text, isEmpty);
      expect(form.age.text, isEmpty);
      expect(form.gender.value, isNull);
    });
  });

  group('LabeledDivider', () {
    testWidgets('centres its label between two equal lines 16 away', (tester) async {
      await tester.pumpWidget(host(const LabeledDivider(label: 'Or Continue With')));
      final dividers = find.byType(Divider);
      expect(dividers, findsNWidgets(2));
      final start = tester.getRect(dividers.first);
      final end = tester.getRect(dividers.last);
      final label = tester.getRect(find.text('Or Continue With'));
      expect(start.width, closeTo(end.width, 1e-6));
      expect(label.left - start.right, closeTo(ThemeConstants.spacing16, 1e-6));
      expect(end.left - label.right, closeTo(ThemeConstants.spacing16, 1e-6));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/commons/widgets/app_tap_target.dart';
import 'package:mieo_ui8/commons/widgets/fields/app_dropdown_field.dart';
import 'package:mieo_ui8/commons/widgets/fields/app_text_field.dart';
import 'package:mieo_ui8/core/constants/assets_constants.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/core/theme/colors.dart';
import 'package:mieo_ui8/utils/input_validators.dart';

import 'helpers/test_app.dart';

// The Figma Input Field widgets: AppTextField's four looks (Default, Focused,
// Selected, error), its validation, the password eye and its tap target, the
// inline label; AppDropdownField's menu, choice and validation.
void main() {
  setUpAll(loadAppResources);

  const colors = AppColorTokens.light;
  final formKey = GlobalKey<FormState>();

  Widget host(Widget field) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.all(ThemeConstants.spacing16),
        child: Form(key: formKey, child: field),
      ),
    ),
  );

  BoxDecoration boxOf(WidgetTester tester) =>
      tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration! as BoxDecoration;

  Color outlineOf(WidgetTester tester) => (boxOf(tester).border! as Border).top.color;

  Color shadowOf(WidgetTester tester) => boxOf(tester).boxShadow!.single.color;

  ColorFilter? tintOf(WidgetTester tester, String asset) => tester
      .widgetList<SvgPicture>(find.byType(SvgPicture))
      .firstWhere((icon) => (icon.bytesLoader as SvgAssetLoader).assetName == asset)
      .colorFilter;

  group('AppTextField', () {
    testWidgets('is 52 high and shows the hint in Texts/Body Text while empty, in the Default look', (tester) async {
      await tester.pumpWidget(
        host(AppTextField(controller: TextEditingController(), icon: AssetsConstants.icMail, hintText: 'Email')),
      );
      await tester.pumpAndSettle();

      expect(tester.getSize(find.byType(AnimatedContainer)).height, ThemeConstants.fieldHeight);
      expect(find.text('Email'), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintStyle?.color, colors.text.body);
      expect(outlineOf(tester), colors.stroke.extraDimNeutral);
      expect(shadowOf(tester), colors.shadow.neutralExtraLight);
      expect(boxOf(tester).boxShadow!.single.offset, const Offset(0, ThemeConstants.hardShadowOffsetSm));
      expect(tintOf(tester, AssetsConstants.icMail), ColorFilter.mode(colors.icon.neutral, BlendMode.srcIn));
    });

    testWidgets('takes the Focused look while editing, and the Selected look once it holds a value', (tester) async {
      await tester.pumpWidget(host(AppTextField(controller: TextEditingController(), icon: AssetsConstants.icMail)));
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(outlineOf(tester), colors.stroke.primary);
      expect(shadowOf(tester), colors.shadow.primaryFull);
      expect(tintOf(tester, AssetsConstants.icMail), ColorFilter.mode(colors.icon.primary, BlendMode.srcIn));

      await tester.enterText(find.byType(TextField), 'jennyfrost@gmail.com');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(outlineOf(tester), colors.stroke.dimNeutral);
      expect(shadowOf(tester), colors.shadow.neutralLight);
      expect(tintOf(tester, AssetsConstants.icMail), ColorFilter.mode(colors.icon.neutral, BlendMode.srcIn));
    });

    testWidgets('a tap on the box around the text focuses it', (tester) async {
      await tester.pumpWidget(host(AppTextField(controller: TextEditingController(), icon: AssetsConstants.icMail)));
      await tester.pumpAndSettle();
      await tester.tapAt(tester.getCenter(find.byType(SvgPicture)));
      await tester.pumpAndSettle();
      expect(outlineOf(tester), colors.stroke.primary);
    });

    testWidgets('shows the validator message in the error look, and clears it once the value is fixed', (tester) async {
      await tester.pumpWidget(
        host(AppTextField(controller: TextEditingController(), validator: InputValidators.required)),
      );
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text(LangKeys.validationRequired.tr), findsOneWidget);
      expect(outlineOf(tester), colors.stroke.red);
      expect(shadowOf(tester), colors.shadow.redLighter);

      await tester.enterText(find.byType(TextField), 'Jenny');
      await tester.pumpAndSettle();
      expect(find.text(LangKeys.validationRequired.tr), findsNothing);
      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets('an obscurable field hides its text until the eye is tapped', (tester) async {
      await tester.pumpWidget(host(AppTextField(controller: TextEditingController(text: 'secret'), obscurable: true)));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);

      await tester.tapAt(tester.getCenter(find.byType(AppTapTarget)));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isFalse);
      expect(tintOf(tester, AssetsConstants.icEye), ColorFilter.mode(colors.icon.primary, BlendMode.srcIn));
    });

    testWidgets('the eye takes taps in a full tap target around its 24 icon', (tester) async {
      await tester.pumpWidget(host(AppTextField(controller: TextEditingController(), obscurable: true)));
      await tester.pumpAndSettle();
      final eye = tester.getRect(find.descendant(of: find.byType(AppTapTarget), matching: find.byType(SvgPicture)));
      expect(eye.size, const Size.square(ThemeConstants.iconSize24));

      // 4 before the icon, and 8 above it: outside the glyph, inside the target.
      await tester.tapAt(eye.centerLeft - const Offset(4, 0));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isFalse);
      await tester.tapAt(eye.topCenter - const Offset(0, 8));
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
    });

    testWidgets('places an inline label 16 before the box, and the message under both', (tester) async {
      await tester.pumpWidget(
        host(AppTextField(controller: TextEditingController(), label: 'Age', validator: InputValidators.age)),
      );
      final label = tester.getRect(find.text('Age'));
      final box = tester.getRect(find.byType(AnimatedContainer));
      expect(box.left - label.right, closeTo(ThemeConstants.spacing16, 1e-6));
      expect(label.center.dy, closeTo(box.center.dy, 1e-6));

      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      final message = tester.getRect(find.text(LangKeys.validationRequired.tr));
      expect(message.left, label.left);
      expect(message.top, closeTo(box.bottom + ThemeConstants.spacing8, 1e-6));
    });
  });

  group('AppDropdownField', () {
    const options = [AppDropdownOption('f', 'Female'), AppDropdownOption('m', 'Male'), AppDropdownOption('o', 'Other')];

    Widget dropdown({String? initial, ValueChanged<String>? onPicked}) {
      var value = initial;
      return StatefulBuilder(
        builder: (context, setState) => AppDropdownField<String>(
          options: options,
          value: value,
          hintText: 'Select',
          label: 'Gender',
          validator: InputValidators.selection,
          onChanged: (picked) {
            setState(() => value = picked);
            onPicked?.call(picked);
          },
        ),
      );
    }

    testWidgets('shows the hint in the Default look before a choice', (tester) async {
      await tester.pumpWidget(host(dropdown()));
      await tester.pumpAndSettle();
      expect(find.text('Select'), findsOneWidget);
      expect(tester.widget<Text>(find.text('Select')).style?.color, colors.text.body);
      expect(outlineOf(tester), colors.stroke.extraDimNeutral);
    });

    testWidgets('opens the options under the box, and picking one reports it and closes the menu', (tester) async {
      String? picked;
      await tester.pumpWidget(host(dropdown(initial: 'f', onPicked: (value) => picked = value)));
      await tester.pumpAndSettle();
      expect(outlineOf(tester), colors.stroke.dimNeutral);

      await tester.tap(find.text('Female'));
      await tester.pumpAndSettle();
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
      expect(outlineOf(tester), colors.stroke.primary);
      final box = tester.getRect(find.byType(AnimatedContainer));
      expect(tester.getRect(find.byType(MenuItemButton).first).top, greaterThan(box.bottom));

      await tester.tap(find.text('Male'));
      await tester.pumpAndSettle();
      expect(picked, 'm');
      expect(find.byType(MenuItemButton), findsNothing);
      expect(find.text('Male'), findsOneWidget);
      expect(outlineOf(tester), colors.stroke.dimNeutral);
    });

    testWidgets('asks for a choice when validated empty', (tester) async {
      await tester.pumpWidget(host(dropdown()));
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      expect(find.text(LangKeys.validationRequired.tr), findsOneWidget);
      expect(outlineOf(tester), colors.stroke.red);

      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Other'));
      await tester.pumpAndSettle();
      expect(find.text(LangKeys.validationRequired.tr), findsNothing);
    });
  });
}

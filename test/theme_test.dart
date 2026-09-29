import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/core/theme/colors.dart';
import 'package:mieo_ui8/core/theme/fonts.dart';
import 'package:mieo_ui8/utils/extensions/context_extensions.dart';

// Guards the Figma → Flutter design-token mapping (Figma Style Guide page):
//   • colour tokens carry the Figma "Colors" Light / Dark values, both themes
//     register them and `context.colors` resolves the active set;
//   • theme changes interpolate every token;
//   • every "Mieo/<role>/<size>" text style matches its Figma spec and keeps
//     Figma's "Auto" line height (the font's natural height) through Theme.of.
void main() {
  group('colour tokens', () {
    test('mirror the Figma Light and Dark values', () {
      const light = AppColorTokens.light;
      const dark = AppColorTokens.dark;

      // A sample from every group, including the translucent dark-mode tokens.
      expect(light.surface.body, const Color(0xFFFAFAFA));
      expect(dark.surface.body, const Color(0xFF171A1C));
      expect(light.surface.backgroundNeutral, const Color(0xFFFFFFFF));
      expect(dark.surface.backgroundNeutral, const Color(0xFF2E3438));
      expect(light.surface.primary, const Color(0xFF59C8FF));
      expect(dark.surface.primary, const Color(0xFF1AB3FF));
      expect(dark.surface.dimPrimary, const Color(0x291AB3FF));
      expect(dark.surface.skyTop, const Color(0x14FFFFFF));
      expect(light.text.heading, const Color(0xFF171A1C));
      expect(dark.text.heading, const Color(0xFFE3E6E8));
      expect(light.text.body, const Color(0xFF5D686F));
      expect(dark.text.body, const Color(0xFFADB5BA));
      expect(light.icon.neutral, const Color(0xFF464E53));
      expect(dark.icon.neutral, const Color(0xFFC7CDD1));
      expect(light.stroke.extraDimNeutral, const Color(0xFFE3E6E8));
      expect(dark.stroke.extraDimNeutral, const Color(0xFF464E53));
      expect(light.shadow.primaryDarker, const Color(0xFF3E8CB2));
      expect(dark.shadow.primaryDarker, const Color(0xFF006EA4));
      expect(dark.shadow.secondaryDarker, const Color(0xFFFFF1D3));
      expect(light.cloud.layer1, const Color(0xFFFFFFFF));
      expect(dark.cloud.layer1, const Color(0xFF2A2D30));
    });

    test('both themes register the token set of their brightness', () {
      expect(AppTheme.light.extension<AppColorTokens>(), same(AppColorTokens.light));
      expect(AppTheme.dark.extension<AppColorTokens>(), same(AppColorTokens.dark));
      expect(AppTheme.light.colorScheme.brightness, Brightness.light);
      expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
      expect(AppTheme.light.scaffoldBackgroundColor, AppColorTokens.light.surface.body);
      expect(AppTheme.dark.scaffoldBackgroundColor, AppColorTokens.dark.surface.body);
    });

    test('lerp interpolates every token between the modes', () {
      const light = AppColorTokens.light;
      const dark = AppColorTokens.dark;

      expect(light.lerp(dark, 0).surface.body, light.surface.body);
      expect(light.lerp(dark, 1).shadow.primaryDarker, dark.shadow.primaryDarker);
      expect(light.lerp(dark, 0.5).text.heading, Color.lerp(light.text.heading, dark.text.heading, 0.5));
      expect(light.lerp(null, 0.5), same(light));
    });

    testWidgets('context.colors resolves the active theme', (tester) async {
      late AppColorTokens resolved;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (context) {
              resolved = context.colors;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolved.surface.body, AppColorTokens.dark.surface.body);
    });

    test('status bar icons contrast with the page', () {
      expect(AppTheme.systemOverlayStyle(Brightness.light).statusBarIconBrightness, Brightness.dark);
      expect(AppTheme.systemOverlayStyle(Brightness.dark).statusBarIconBrightness, Brightness.light);
      expect(AppTheme.systemOverlayStyle(Brightness.dark).systemNavigationBarColor, AppColorTokens.dark.surface.body);
    });
  });

  group('typography', () {
    // Figma Style Guide → Typography: size, weight and letter spacing per style.
    final specs = <String, (TextStyle? Function(TextTheme), double, FontWeight, double)>{
      'Mieo/display/large': ((t) => t.displayLarge, 57, FontWeight.w900, -0.25),
      'Mieo/display/medium': ((t) => t.displayMedium, 45, FontWeight.w900, 0),
      'Mieo/display/small': ((t) => t.displaySmall, 36, FontWeight.w800, 0),
      'Mieo/headline/large': ((t) => t.headlineLarge, 32, FontWeight.w900, 0),
      'Mieo/headline/medium': ((t) => t.headlineMedium, 28, FontWeight.w800, 0),
      'Mieo/headline/small': ((t) => t.headlineSmall, 24, FontWeight.w700, 0),
      'Mieo/title/large': ((t) => t.titleLarge, 22, FontWeight.w800, 0),
      'Mieo/title/medium': ((t) => t.titleMedium, 16, FontWeight.w800, 0.15),
      'Mieo/title/small': ((t) => t.titleSmall, 14, FontWeight.w800, 0.1),
      'Mieo/body/large': ((t) => t.bodyLarge, 16, FontWeight.w500, 0.5),
      'Mieo/body/medium': ((t) => t.bodyMedium, 14, FontWeight.w500, 0.25),
      'Mieo/body/small': ((t) => t.bodySmall, 12, FontWeight.w500, 0),
      'Mieo/label/large - prominent': ((t) => t.labelLargeProminent, 14, FontWeight.w600, 0.1),
      'Mieo/label/large': ((t) => t.labelLarge, 14, FontWeight.w500, 0.1),
      'Mieo/label/medium - prominent': ((t) => t.labelMediumProminent, 12, FontWeight.w600, 0.5),
      'Mieo/label/medium': ((t) => t.labelMedium, 12, FontWeight.w500, 0.5),
      'Mieo/label/small': ((t) => t.labelSmall, 11, FontWeight.w500, 0.5),
    };

    testWidgets('Theme.of keeps every Figma style intact', (tester) async {
      late TextTheme textTheme;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (context) {
              textTheme = Theme.of(context).textTheme;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      for (final MapEntry(key: name, value: spec) in specs.entries) {
        final (resolve, size, weight, letterSpacing) = spec;
        final style = resolve(textTheme);
        expect(style, isNotNull, reason: name);
        expect(style!.fontFamily, AppFonts.fontFamily, reason: name);
        expect(style.fontSize, size, reason: name);
        expect(style.fontWeight, weight, reason: name);
        expect(style.letterSpacing, letterSpacing, reason: name);
        expect(style.height, isNull, reason: '$name must keep the Figma "Auto" line height');
        expect(style.color, AppColorTokens.light.text.heading, reason: name);
      }
    });
  });
}

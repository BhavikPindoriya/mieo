import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/core/theme/fonts.dart';

// Pixel check for the type scale: with the real Nunito font loaded, a line of
// each Mieo text style must be as tall as its sample in the Figma Typography
// frame (Figma line height "Auto" = Nunito's natural 1.364 × size). Material's
// default text geometry (line height 1.43–1.5) would make every line 1–3px
// taller and fail this test.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final loader = FontLoader(AppFonts.fontFamily)..addFont(rootBundle.load('assets/fonts/Nunito-VariableFont.ttf'));
    await loader.load();
  });

  // Height of the one-line "Lorem ipsum" sample of each style in Figma.
  final figmaHeights = <String, (TextStyle? Function(TextTheme), double)>{
    'Mieo/display/large': ((t) => t.displayLarge, 78),
    'Mieo/display/medium': ((t) => t.displayMedium, 61),
    'Mieo/display/small': ((t) => t.displaySmall, 49),
    'Mieo/headline/large': ((t) => t.headlineLarge, 44),
    'Mieo/headline/medium': ((t) => t.headlineMedium, 38),
    'Mieo/headline/small': ((t) => t.headlineSmall, 33),
    'Mieo/title/large': ((t) => t.titleLarge, 30),
    'Mieo/title/medium': ((t) => t.titleMedium, 22),
    'Mieo/title/small': ((t) => t.titleSmall, 19),
    'Mieo/body/large': ((t) => t.bodyLarge, 22),
    'Mieo/body/medium': ((t) => t.bodyMedium, 19),
    'Mieo/body/small': ((t) => t.bodySmall, 16),
    'Mieo/label/large - prominent': ((t) => t.labelLargeProminent, 19),
    'Mieo/label/large': ((t) => t.labelLarge, 19),
    'Mieo/label/medium - prominent': ((t) => t.labelMediumProminent, 16),
    'Mieo/label/medium': ((t) => t.labelMedium, 16),
    'Mieo/label/small': ((t) => t.labelSmall, 15),
  };

  testWidgets('one line of every style is as tall as in Figma', (tester) async {
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

    for (final MapEntry(key: name, value: (resolve, figmaHeight)) in figmaHeights.entries) {
      final painter = TextPainter(
        text: TextSpan(text: 'Lorem ipsum', style: resolve(textTheme)),
        textDirection: TextDirection.ltr,
      )..layout();
      // Figma rounds text boxes to whole pixels; Flutter keeps the fraction.
      expect(painter.height, closeTo(figmaHeight, 0.5), reason: name);
      painter.dispose();
    }
  });
}

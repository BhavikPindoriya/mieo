import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/features/splash/widgets/splash_stage.dart';

// The splash scene's geometry: how the 375 × 812 Figma frame is fitted to
// different screens. (Its clouds come from the shared library, tested in
// clouds_test.dart.)
void main() {
  // Space the footer takes at the bottom edge (Figma "Footer", 58 high).
  const footer = 58.0;

  SplashStage fit(Size screen, {double top = 0, bool tablet = false}) =>
      SplashStage.fit(screen: screen, topInset: top, bottomInset: footer, allowUpscale: tablet);

  group('SplashStage', () {
    test('is the identity on the 375 × 812 reference, so layers land on their Figma pixels', () {
      final stage = fit(const Size(375, 812), top: 47);
      expect(stage.scale, 1);
      expect(stage.frameRect, Offset.zero & SplashStage.frameSize);
    });

    test('centres the frame at design size on a larger phone', () {
      final stage = fit(const Size(390, 844), top: 47);
      expect(stage.scale, 1);
      expect(stage.frameRect.left, closeTo(7.5, 1e-9));
      expect(stage.frameRect.top, closeTo(16, 1e-9));
    });

    test('shrinks only as far as needed to keep the character frame on a narrow phone', () {
      final stage = fit(const Size(320, 568), top: 20);
      expect(stage.scale, lessThan(1));
      final contentLeft = stage.frameRect.left + SplashStage.content.left * stage.scale;
      expect(contentLeft, closeTo(0, 1e-9));
    });

    test('keeps the character frame between the status bar and the footer in landscape', () {
      const screen = Size(812, 375);
      final stage = fit(screen);
      final contentTop = stage.toScreenY(SplashStage.content.top);
      final contentBottom = stage.toScreenY(SplashStage.content.bottom);
      expect(contentTop, greaterThanOrEqualTo(0));
      expect(contentBottom, closeTo(screen.height - footer, 1e-9));
    });

    test('scales up on tablets until the frame fills the screen height', () {
      const screen = Size(768, 1024);
      final stage = fit(screen, top: 24, tablet: true);
      expect(stage.scale, closeTo(screen.height / SplashStage.frameSize.height, 1e-9));
      expect(stage.frameRect.top, closeTo(0, 1e-9));
    });

    test('never scales up on phones', () {
      expect(fit(const Size(430, 932), top: 59).scale, 1);
    });

    test('viewport is the screen in frame coordinates', () {
      for (final screen in const [Size(375, 812), Size(320, 568), Size(812, 375), Size(1024, 1366)]) {
        final stage = fit(screen, tablet: screen.shortestSide >= 600);
        final viewport = stage.viewport;
        expect(stage.frameRect.left + viewport.left * stage.scale, closeTo(0, 1e-9));
        expect(stage.frameRect.top + viewport.top * stage.scale, closeTo(0, 1e-9));
        expect(viewport.width * stage.scale, closeTo(screen.width, 1e-9));
        expect(viewport.height * stage.scale, closeTo(screen.height, 1e-9));
      }
    });
  });
}

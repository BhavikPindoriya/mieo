import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/commons/widgets/app_button.dart';
import 'package:mieo_ui8/commons/widgets/app_tag.dart';
import 'package:mieo_ui8/commons/widgets/highlighted_text.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';
import 'package:mieo_ui8/core/constants/theme_constants.dart';
import 'package:mieo_ui8/core/localization/app_translations.dart';
import 'package:mieo_ui8/core/localization/lang_keys.dart';
import 'package:mieo_ui8/core/routes/routes.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/features/onboarding/screens/hello_screen.dart';
import 'package:mieo_ui8/features/onboarding/screens/onboarding_screen.dart';
import 'package:mieo_ui8/features/onboarding/widgets/onboarding_stage.dart';

// The Onboarding screen: how its scene is fitted to different slots, where the
// pieces land on the 375 × 812 reference, where the buttons lead, and a layout
// check across the Device Preview matrix in both themes and text directions.
void main() {
  group('OnboardingStage', () {
    // Height of the intro with the real Nunito: 54 + tag 32.4 + 8 + two
    // heading lines of 43.6. The slot is the sky panel below it.
    const introBottom = 181.67;

    OnboardingStage fit(double width, double panelHeight, {bool tablet = false}) => OnboardingStage.fit(
      Size(width, panelHeight - introBottom),
      maxScale: tablet ? OnboardingStage.tabletMaxScale : OnboardingStage.designScale,
    );

    test('is the identity on the reference, bottom-anchored like the Figma frame', () {
      final stage = fit(375, 593);
      expect(stage.scale, 1);
      expect(stage.frameRect.left, 0);
      expect(stage.frameRect.top + introBottom, closeTo(0, 1e-9));
    });

    test('keeps the design size on a taller phone, centred, with more sky above Mieo', () {
      final stage = fit(430, 704);
      expect(stage.scale, 1);
      expect(stage.frameRect.left, closeTo((430 - 375) / 2, 1e-9));
      expect(stage.frameRect.bottom, closeTo(704 - introBottom, 1e-9));
    });

    test('lowers and then shrinks the scene to keep Mieo clear of the intro on a short phone', () {
      const panel = 478.0; // iPhone SE: 667 − status bar 20 − gap 9 − actions 160
      final stage = fit(375, panel);
      expect(stage.scale, inExclusiveRange(OnboardingStage.minScale, 1));
      final earTips = stage.frameRect.top + OnboardingStage.mustSeeTop * stage.scale;
      final bandBottom = stage.frameRect.top + OnboardingStage.mustSeeBottom * stage.scale;
      expect(earTips, closeTo(OnboardingStage.introClearance, 1e-9));
      expect(bandBottom, closeTo(panel - introBottom, 1e-9));
    });

    test('never shrinks below minScale, which minSlotHeight holds exactly', () {
      final atMinimum = OnboardingStage.fit(const Size(375, OnboardingStage.minSlotHeight), maxScale: 1);
      expect(atMinimum.scale, closeTo(OnboardingStage.minScale, 1e-9));
      expect(OnboardingStage.fit(const Size(375, 100), maxScale: 1).scale, OnboardingStage.minScale);
    });

    test('grows on tablets up to the width of the content column', () {
      final stage = fit(768, 831, tablet: true);
      expect(stage.scale, closeTo(OnboardingStage.tabletMaxScale, 1e-9));
      expect(stage.frameRect.width, closeTo(ThemeConstants.maxContentWidth, 1e-9));
      expect(stage.frameRect.bottom, closeTo(831 - introBottom, 1e-9));
    });
  });

  group('OnboardingScreen', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await AppTranslations.load();
    });

    Future<void> pumpScreen(
      WidgetTester tester, {
      Size size = const Size(375, 812),
      Locale locale = LocalizationConstants.english,
      ThemeMode themeMode = ThemeMode.light,
      double textScale = 1,
    }) async {
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          translations: AppTranslations(),
          locale: locale,
          fallbackLocale: LocalizationConstants.fallbackLocale,
          supportedLocales: LocalizationConstants.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          getPages: AppPages.pages,
          home: const OnboardingScreen(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows the tag, the heading without its markers and both actions', (tester) async {
      await pumpScreen(tester);
      expect(find.text(LangKeys.onboardingKidsSafe.tr), findsOneWidget);
      expect(find.text(LangKeys.onboardingTitle.tr.replaceAll(HighlightedText.marker, '')), findsOneWidget);
      expect(find.text(LangKeys.onboardingFreshStart.tr), findsOneWidget);
      expect(find.text(LangKeys.onboardingResumeJourney.tr), findsOneWidget);
    });

    testWidgets('places the intro and the buttons at their Figma positions on the reference', (tester) async {
      await pumpScreen(tester);
      // No status bar in tests, so the sky panel starts at the top edge.
      expect(tester.getTopLeft(find.byType(AppTag)), const Offset(18, 54));
      final buttons = find.byType(AppButton);
      expect(tester.getRect(buttons.at(0)), const Rect.fromLTWH(16, 676, 343, 48));
      expect(tester.getRect(buttons.at(1)), const Rect.fromLTWH(16, 740, 343, 48));
    });

    testWidgets('mirrors the intro in RTL', (tester) async {
      await pumpScreen(tester, locale: LocalizationConstants.urdu);
      expect(Directionality.of(tester.element(find.byType(AppTag))), TextDirection.rtl);
      expect(tester.getTopRight(find.byType(AppTag)), const Offset(375 - 18, 54));
    });

    testWidgets('Fresh Start opens account setup; Resume Journey opens login', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text(LangKeys.onboardingFreshStart.tr));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.accountSetup);
      expect(find.byType(HelloScreen), findsOneWidget);

      Get.back<void>();
      await tester.pumpAndSettle();
      await tester.tap(find.text(LangKeys.onboardingResumeJourney.tr));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, Routes.login);
    });

    // The Device Preview matrix (CLAUDE.md §8), light and dark, LTR and RTL:
    // nothing may overflow, and short screens scroll instead.
    const screens = [
      Size(375, 812), // iPhone 13 mini, the reference
      Size(375, 667), // iPhone SE
      Size(320, 568),
      Size(430, 932), // iPhone 15 Pro Max
      Size(360, 800), // Android
      Size(812, 375), // phone, landscape
      Size(768, 1024), // iPad mini
      Size(1024, 768),
      Size(1024, 1366), // iPad Pro 12.9
    ];
    for (final size in screens) {
      final name = '${size.width.round()} × ${size.height.round()}';
      testWidgets('lays out on $name, light, LTR', (tester) async {
        await pumpScreen(tester, size: size);
        expect(tester.takeException(), isNull);
      });
      testWidgets('lays out on $name, dark, RTL', (tester) async {
        await pumpScreen(tester, size: size, themeMode: ThemeMode.dark, locale: LocalizationConstants.urdu);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('lays out at text scale 1.3 on the iPhone SE', (tester) async {
      await pumpScreen(tester, size: const Size(375, 667), textScale: 1.3);
      expect(tester.takeException(), isNull);
    });
  });
}

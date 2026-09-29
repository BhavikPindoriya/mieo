import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';
import 'package:mieo_ui8/core/localization/app_translations.dart';
import 'package:mieo_ui8/core/routes/routes.dart';
import 'package:mieo_ui8/core/theme/app_theme.dart';
import 'package:mieo_ui8/core/theme/fonts.dart';

// Shared set-up for screen tests: the app's translations and real font, and a
// pump that shows a screen the way the app does (GetMaterialApp with the
// app's themes, translations and routes) on a simulated device — its size,
// status bar and home indicator, keyboard, text scale, theme and locale — and
// lets its entrance animations finish unless told not to settle.

/// The reference device's insets (iPhone 13 mini): status bar and home
/// indicator.
const double referenceTopInset = 50;
const double referenceBottomInset = 34;

/// Loads the translation files and the Nunito font, so text has the app's
/// copy and real metrics. Call from setUpAll.
Future<void> loadAppResources() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await AppTranslations.load();
  final font = FontLoader(AppFonts.fontFamily)..addFont(rootBundle.load('assets/fonts/Nunito-VariableFont.ttf'));
  await font.load();
}

Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(375, 812),
  double topInset = referenceTopInset,
  double bottomInset = referenceBottomInset,
  double keyboard = 0,
  Locale locale = LocalizationConstants.english,
  ThemeMode themeMode = ThemeMode.light,
  double textScale = 1,
  bool settle = true,
}) async {
  final insets = FakeViewPadding(top: topInset, bottom: bottomInset);
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1
    ..viewPadding = insets
    ..padding = keyboard > 0 ? FakeViewPadding(top: topInset) : insets
    ..viewInsets = FakeViewPadding(bottom: keyboard);
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
      home: screen,
    ),
  );
  if (settle) await tester.pumpAndSettle();
}

/// The Device Preview matrix (CLAUDE.md §8) as screen sizes.
const List<Size> deviceMatrix = [
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

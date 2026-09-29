import 'package:flutter/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LOCALIZATION CONSTANTS
//
// Supported locales and where their translation files live. English is LTR;
// Urdu is RTL — registering it in supportedLocales (main.dart) is what makes
// Flutter flip Directionality for the whole tree when it's active.
//
// Adding a language: add its Locale here and to supportedLocales, then add
// assets/languages/<languageCode>.json with every key en.json has.
// ─────────────────────────────────────────────────────────────────────────────
class LocalizationConstants {
  LocalizationConstants._();

  static const Locale english = Locale('en', 'US');
  static const Locale urdu = Locale('ur');

  static const List<Locale> supportedLocales = [english, urdu];
  static const Locale defaultLocale = english;

  /// Locale GetX falls back to when a key is missing for the active one.
  static const Locale fallbackLocale = english;

  static const String languagesPath = 'assets/languages';

  /// `assets/languages/<languageCode>.json` — e.g. en.json, ur.json.
  static String translationFile(Locale locale) => '$languagesPath/${locale.languageCode}.json';
}

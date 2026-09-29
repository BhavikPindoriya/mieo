import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constants/localization_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP TRANSLATIONS
//
// load() reads one JSON file per supported locale into a static map, once,
// from main() before runApp() — so the first frame's `.tr` lookups already
// resolve instead of showing raw keys. The `keys` getter GetX requires then
// just returns that map synchronously.
//
// Map shape: { 'en_US': { 'app_name': 'Mieo', … }, 'ur': { … } }
// Outer key = Locale.toString(), which is what GetX matches the active
// Get.locale against.
// ─────────────────────────────────────────────────────────────────────────────
class AppTranslations extends Translations {
  static Map<String, Map<String, String>> _translations = {};

  static Future<void> load() async {
    _translations = {
      for (final locale in LocalizationConstants.supportedLocales)
        locale.toString(): await _loadJson(LocalizationConstants.translationFile(locale)),
    };
  }

  static Future<Map<String, String>> _loadJson(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as String));
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/core/constants/localization_constants.dart';

// Guards the i18n contract: every LangKeys value exists in every language
// file, all files carry the same key set, and no value is left blank — so a
// missing translation fails CI instead of rendering a raw key on screen.
void main() {
  final langKeysSource = File('lib/core/localization/lang_keys.dart').readAsStringSync();
  final langKeyValues = RegExp(r"static const String \w+ = '([a-z0-9_]+)';")
      .allMatches(langKeysSource)
      .map((match) => match.group(1)!)
      .toSet();

  Map<String, String> readLanguageFile(String path) {
    final decoded = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as String));
  }

  final languageFiles = {
    for (final locale in LocalizationConstants.supportedLocales)
      LocalizationConstants.translationFile(locale): readLanguageFile(LocalizationConstants.translationFile(locale)),
  };

  test('LangKeys declares at least one key', () {
    expect(langKeyValues, isNotEmpty);
  });

  test('every LangKeys value exists in every language file', () {
    languageFiles.forEach((path, translations) {
      final missing = langKeyValues.difference(translations.keys.toSet());
      expect(missing, isEmpty, reason: '$path is missing keys');
    });
  });

  test('every language file has the same key set', () {
    final referenceKeys = languageFiles.values.first.keys.toSet();
    languageFiles.forEach((path, translations) {
      expect(translations.keys.toSet(), referenceKeys, reason: '$path key set differs');
    });
  });

  test('no translation value is blank', () {
    languageFiles.forEach((path, translations) {
      final blank = translations.entries.where((entry) => entry.value.trim().isEmpty).map((entry) => entry.key);
      expect(blank, isEmpty, reason: '$path has blank values');
    });
  });
}

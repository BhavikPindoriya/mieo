import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constants/hive_constants.dart';
import '../constants/localization_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LANGUAGE CUBIT
//
// App-wide UI language. State is the active Locale.
//
//   • Created in main.dart with the already-open settings box, so the saved
//     language is read synchronously and passed to GetMaterialApp as its
//     initial locale (no English → saved-language flash).
//   • changeLocale() persists the language code, then calls
//     Get.updateLocale(), which swaps every `.tr` string and — because all
//     supported locales are registered with GetMaterialApp — flips
//     Directionality to RTL/LTR for the whole tree. The emitted state is
//     what a language picker reads to show the current selection.
// ─────────────────────────────────────────────────────────────────────────────
class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(this._settingsBox) : super(_savedLocale(_settingsBox));

  final Box<dynamic> _settingsBox;

  static Locale _savedLocale(Box<dynamic> box) {
    final savedCode = box.get(HiveConstants.languageCodeKey) as String?;
    return LocalizationConstants.supportedLocales.firstWhere(
      (locale) => locale.languageCode == savedCode,
      orElse: () => LocalizationConstants.defaultLocale,
    );
  }

  Future<void> changeLocale(Locale locale) async {
    await _settingsBox.put(HiveConstants.languageCodeKey, locale.languageCode);
    await Get.updateLocale(locale);
    emit(locale);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HIVE CONSTANTS
//
// Box names and keys for locally persisted app settings. The settings box is
// opened once in main() before runApp(), so cubits can read it synchronously
// when they're created.
// ─────────────────────────────────────────────────────────────────────────────
class HiveConstants {
  HiveConstants._();

  static const String settingsBox = 'settings';

  // ── settingsBox keys ──
  /// ThemeMode.name ('light' / 'dark' / 'system').
  static const String themeModeKey = 'theme_mode';

  /// Locale.languageCode of the chosen app language.
  static const String languageCodeKey = 'language_code';
}

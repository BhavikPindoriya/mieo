import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP THEME
//
// Builds the light and dark ThemeData from one recipe (_build), so the two
// themes differ only where the Figma tokens do (AppColorTokens.light / .dark,
// the Light and Dark modes of the Figma "Colors" collection).
//
//   extensions  — AppColorTokens: every Figma colour token for the mode, read
//                 with `context.colors`. MaterialApp animates theme changes and
//                 the tokens lerp, so light ↔ dark cross-fades.
//   ColorScheme — Material roles mapped onto the same tokens, so stock widgets
//                 (text selection, progress indicators, dialogs) match:
//                   primary / onPrimary      → Surface/Primary / Texts/On Surface/primary
//                   secondary / onSecondary  → Surface/Secondary / Texts/On Surface/secondary
//                   error / onError          → Surface/Red / Texts/On Surface/secondary Red
//                   surface / onSurface      → Surface/Body / Texts/Heading
//                   onSurfaceVariant         → Texts/Body Text
//                   surfaceContainer*        → Surface/Background Nuturel
//                   outline / outlineVariant → Stroke/Nuturel / Stroke/Extra Dim/Nuturel
//                   tertiary                 → Shades/ternary (no semantic token)
//   Typography  — AppFonts.textTheme with Texts/Heading as the ink colour.
//   Ink         — no splash or highlight: Mieo components give their own press
//                 feedback by sinking into their hard shadow.
//   System bars — systemOverlayStyle(): transparent status bar, icons that
//                 contrast with the page background.
// ─────────────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static final ThemeData light = _build(AppColorTokens.light, Brightness.light);

  static final ThemeData dark = _build(AppColorTokens.dark, Brightness.dark);

  /// Status and navigation bar styling for a page of [brightness].
  static SystemUiOverlayStyle systemOverlayStyle(Brightness brightness) {
    final colors = AppColorTokens.forBrightness(brightness);
    final iconBrightness = switch (brightness) {
      Brightness.light => Brightness.dark,
      Brightness.dark => Brightness.light,
    };
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: iconBrightness,
      statusBarBrightness: brightness,
      systemNavigationBarColor: colors.surface.body,
      systemNavigationBarIconBrightness: iconBrightness,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }

  static ThemeData _build(AppColorTokens colors, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.surface.primary,
      onPrimary: colors.text.onPrimary,
      primaryContainer: colors.surface.dimPrimary,
      onPrimaryContainer: colors.text.primary,
      secondary: colors.surface.secondary,
      onSecondary: colors.text.onSecondary,
      secondaryContainer: colors.surface.dimSecondary,
      onSecondaryContainer: colors.text.heading,
      tertiary: AppColors.ternary700,
      onTertiary: AppColors.ternary50,
      tertiaryContainer: AppColors.ternary100,
      onTertiaryContainer: AppColors.ternary950,
      error: colors.surface.red,
      onError: colors.text.onRed,
      errorContainer: colors.surface.dimError,
      onErrorContainer: colors.text.red,
      surface: colors.surface.body,
      onSurface: colors.text.heading,
      onSurfaceVariant: colors.text.body,
      surfaceContainerLowest: colors.surface.backgroundNeutral,
      surfaceContainerLow: colors.surface.backgroundNeutral,
      surfaceContainer: colors.surface.backgroundNeutral,
      surfaceContainerHigh: colors.surface.backgroundNeutral,
      surfaceContainerHighest: colors.surface.backgroundNeutral,
      outline: colors.stroke.neutral,
      outlineVariant: colors.stroke.extraDimNeutral,
      shadow: colors.shadow.neutralDarker,
      inverseSurface: colors.surface.neutral,
      onInverseSurface: colors.text.onNeutral,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.surface.body,
      fontFamily: AppFonts.fontFamily,
      textTheme: AppFonts.textTheme.apply(bodyColor: colors.text.heading, displayColor: colors.text.heading),
      iconTheme: IconThemeData(color: colors.icon.neutral),
      dividerTheme: DividerThemeData(color: colors.stroke.extraDimNeutral),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.stroke.primary,
        selectionColor: colors.surface.dimPrimary,
        selectionHandleColor: colors.stroke.primary,
      ),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      extensions: [colors],
    );
  }
}

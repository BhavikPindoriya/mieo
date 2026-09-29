import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FONTS
//
// The Figma type scale (Style Guide → Typography, styles "Mieo/<role>/<size>")
// as a Material 3 TextTheme, one role per Figma style: Mieo/title/medium →
// textTheme.titleMedium. The two "prominent" label styles have no Material
// slot; they are the `labelLargeProminent` / `labelMediumProminent` getters at
// the bottom of this file.
//
//   • Family — Nunito, a single variable font (assets/fonts). Flutter maps each
//     style's fontWeight onto the font's `wght` axis, so every weight the
//     design uses (Medium 500 → Black 900) renders from the one file.
//   • Line height — every Figma style uses "Auto": the font's natural line
//     height (Nunito ascent + descent = 1.364 × size, so 16px text is 22px
//     tall). The styles are declared `inherit: false` with no `height`, which
//     stops Theme.of() from merging in Material's default text geometry
//     (line heights of 1.43–1.5) and keeps text boxes the Figma size.
//   • Leading — `even`, like Figma: when a node sets an explicit pixel line
//     height, the extra space is split above and below the glyphs.
//   • Colour — none here; AppTheme applies Figma Texts/Heading per theme.
//
// Widgets use `Theme.of(context).textTheme.<role>` as-is. Size, weight and
// letter spacing are never overridden; `.copyWith()` is for colour or
// decoration only.
// ─────────────────────────────────────────────────────────────────────────────
class AppFonts {
  AppFonts._();

  /// Figma `font/family/Nunito`.
  static const String fontFamily = 'Nunito';

  // ── Sizes — Figma font/size/* ──
  static const double size6xl = 57;
  static const double size5xl = 45;
  static const double size4xl = 36;
  static const double size3xl = 32;
  static const double size2xl = 28;
  static const double size1xl = 24;
  static const double sizeXl = 22;
  static const double sizeL = 16;
  static const double sizeM = 14;
  static const double sizeS = 12;
  static const double sizeXs = 11;

  // ── Letter spacing — Figma font/letter-spacing/* (px) ──
  /// Styles whose Figma letter spacing is 0%.
  static const double letterSpacingNone = 0;
  static const double letterSpacingXs = -0.25;
  static const double letterSpacingS = 0.1;
  static const double letterSpacingM = 0.15;
  static const double letterSpacingL = 0.25;
  static const double letterSpacingXl = 0.5;

  // ── Weights — Figma font/weight/* ──
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  /// Every Figma text style, keyed by its Material 3 role.
  static final TextTheme textTheme = TextTheme(
    // ── Display ──
    displayLarge: _style(size6xl, black, letterSpacingXs), // Mieo/display/large
    displayMedium: _style(size5xl, black, letterSpacingNone), // Mieo/display/medium
    displaySmall: _style(size4xl, extraBold, letterSpacingNone), // Mieo/display/small
    // ── Headline ──
    headlineLarge: _style(size3xl, black, letterSpacingNone), // Mieo/headline/large
    headlineMedium: _style(size2xl, extraBold, letterSpacingNone), // Mieo/headline/medium
    headlineSmall: _style(size1xl, bold, letterSpacingNone), // Mieo/headline/small
    // ── Title ──
    titleLarge: _style(sizeXl, extraBold, letterSpacingNone), // Mieo/title/large
    titleMedium: _style(sizeL, extraBold, letterSpacingM), // Mieo/title/medium
    titleSmall: _style(sizeM, extraBold, letterSpacingS), // Mieo/title/small
    // ── Body ──
    bodyLarge: _style(sizeL, medium, letterSpacingXl), // Mieo/body/large
    bodyMedium: _style(sizeM, medium, letterSpacingL), // Mieo/body/medium
    bodySmall: _style(sizeS, medium, letterSpacingNone), // Mieo/body/small
    // ── Label ──
    labelLarge: _style(sizeM, medium, letterSpacingS), // Mieo/label/large
    labelMedium: _style(sizeS, medium, letterSpacingXl), // Mieo/label/medium
    labelSmall: _style(sizeXs, medium, letterSpacingXl), // Mieo/label/small
  );

  static TextStyle _style(double fontSize, FontWeight fontWeight, double letterSpacing) => TextStyle(
    inherit: false,
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    textBaseline: TextBaseline.alphabetic,
    leadingDistribution: TextLeadingDistribution.even,
  );
}

/// Figma text styles with no Material 3 slot. Derived from the themed label
/// styles, so they keep the family, line height and theme colour.
extension AppTextThemeX on TextTheme {
  /// Mieo/label/large - prominent — SemiBold 14, letter spacing 0.1.
  TextStyle? get labelLargeProminent => labelLarge?.copyWith(fontWeight: AppFonts.semiBold);

  /// Mieo/label/medium - prominent — SemiBold 12, letter spacing 0.5.
  TextStyle? get labelMediumProminent => labelMedium?.copyWith(fontWeight: AppFonts.semiBold);
}

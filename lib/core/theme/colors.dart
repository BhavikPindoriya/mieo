import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// COLORS
//
// Mirrors the Figma "Colors" variable collection one-to-one, in two layers:
//
//   1. AppColors — the primitive palette (Figma `Shades/<family>/<step>`).
//      Identical in both themes. The only place a literal Color(0x…) may
//      appear, together with the raw hex values the Figma tokens below use.
//
//   2. AppColorTokens — the semantic tokens (Figma `Texts/*`, `Icons/*`,
//      `Surface/*`, `Stroke/*`, `Shadow/*`, `Cloud Color/*`) with their Light
//      and Dark mode values. It is a ThemeExtension registered by AppTheme, so
//      `context.colors` returns the set for the active theme, and a theme
//      change animates every token (lerp) instead of snapping.
//
// Alongside them, ArtworkColors holds the raw fills of illustrations drawn in
// code (the mascot): not Figma variables, and the same in both themes.
//
// Mapping rule: a Figma node bound to `Surface/Dim/primary` uses
// `context.colors.surface.dimPrimary`; one bound directly to a primitive
// such as `Shades/primary/700` uses `AppColors.primary700`. Each token names
// its Figma variable in its doc comment (docs/design_tokens.md has the table).
// ─────────────────────────────────────────────────────────────────────────────

/// Primitive palette — Figma `Shades/*`, identical in light and dark mode.
///
/// Widgets use [AppColorTokens] (`context.colors`) instead, unless the Figma
/// node is bound directly to one of these primitives.
class AppColors {
  AppColors._();

  // ── Primary — Shades/primary/* · Sky blue: the brand colour. ──
  static const Color primary50 = Color(0xFFF5FCFF);
  static const Color primary100 = Color(0xFFDFF4FF);
  static const Color primary200 = Color(0xFFC9EDFF);
  static const Color primary300 = Color(0xFFB3E6FF);
  static const Color primary400 = Color(0xFF9DDFFF);
  static const Color primary500 = Color(0xFF87D7FF);
  static const Color primary600 = Color(0xFF71D0FF);
  static const Color primary700 = Color(0xFF59C8FF);
  static const Color primary800 = Color(0xFF45C1FF);
  static const Color primary900 = Color(0xFF2FBAFF);
  static const Color primary950 = Color(0xFF1AB3FF);

  // ── Secondary — Shades/secondary/* · Sunny yellow: rewards, Pro and secondary actions. ──
  static const Color secondary50 = Color(0xFFFFFFFF);
  static const Color secondary100 = Color(0xFFFFF8E9);
  static const Color secondary200 = Color(0xFFFFF1D3);
  static const Color secondary300 = Color(0xFFFFE9BD);
  static const Color secondary400 = Color(0xFFFFE2A7);
  static const Color secondary500 = Color(0xFFFFDB91);
  static const Color secondary600 = Color(0xFFFFD47B);
  static const Color secondary700 = Color(0xFFFFCB61);
  static const Color secondary800 = Color(0xFFFFC550);
  static const Color secondary900 = Color(0xFFFFBE3A);
  static const Color secondary950 = Color(0xFFFFB724);

  // ── Ternary — Shades/ternary/* · Orange: Mieo the bear and streak accents. ──
  static const Color ternary50 = Color(0xFFFFFFFF);
  static const Color ternary100 = Color(0xFFFFEEE5);
  static const Color ternary200 = Color(0xFFFFDCCB);
  static const Color ternary300 = Color(0xFFFFCBB1);
  static const Color ternary400 = Color(0xFFFFB997);
  static const Color ternary500 = Color(0xFFFFA87D);
  static const Color ternary600 = Color(0xFFFF9663);
  static const Color ternary700 = Color(0xFFFF894F);
  static const Color ternary800 = Color(0xFFFF732F);
  static const Color ternary900 = Color(0xFFFF6215);
  static const Color ternary950 = Color(0xFFFA5200);

  // ── Neutral — Shades/neutral/* · Neutral greys: text, surfaces, strokes and shadows. ──
  static const Color neutral50 = Color(0xFFFFFFFF);
  static const Color neutral100 = Color(0xFFE3E6E8);
  static const Color neutral200 = Color(0xFFC7CDD1);
  static const Color neutral300 = Color(0xFFADB5BA);
  static const Color neutral400 = Color(0xFF909BA2);
  static const Color neutral500 = Color(0xFF74818B);
  static const Color neutral600 = Color(0xFF5D686F);
  static const Color neutral700 = Color(0xFF464E53);
  static const Color neutral800 = Color(0xFF2E3438);
  static const Color neutral900 = Color(0xFF171A1C);
  static const Color neutral950 = Color(0xFF000000);

  // ── Success — Shades/Success/* · Green: correct answers and success states. ──
  static const Color success50 = Color(0xFFA6E8B7);
  static const Color success100 = Color(0xFF8BE1A1);
  static const Color success200 = Color(0xFF70DA8A);
  static const Color success300 = Color(0xFF55D374);
  static const Color success400 = Color(0xFF34C759);
  static const Color success500 = Color(0xFF2FB450);
  static const Color success600 = Color(0xFF289944);
  static const Color success700 = Color(0xFF217E38);
  static const Color success800 = Color(0xFF1A632C);
  static const Color success900 = Color(0xFF134820);
  static const Color success950 = Color(0xFF0C2C14);

  // ── Error — Shades/error/* · Red: wrong answers, hearts and error states. ──
  static const Color error50 = Color(0xFFFFFFFF);
  static const Color error100 = Color(0xFFFAE1E1);
  static const Color error200 = Color(0xFFF5C3C3);
  static const Color error300 = Color(0xFFF0A5A5);
  static const Color error400 = Color(0xFFEB8787);
  static const Color error500 = Color(0xFFE56969);
  static const Color error600 = Color(0xFFE04A4A);
  static const Color error700 = Color(0xFFDD3636);
  static const Color error800 = Color(0xFFC32121);
  static const Color error900 = Color(0xFFA51C1C);
  static const Color error950 = Color(0xFF871717);

  // ── Warning — Shades/warning/warning-* · Amber: warnings. ──
  static const Color warning50 = Color(0xFFFEFEFC);
  static const Color warning100 = Color(0xFFFDF9F1);
  static const Color warning200 = Color(0xFFFAF2E0);
  static const Color warning300 = Color(0xFFF6E7C7);
  static const Color warning400 = Color(0xFFF1DAA8);
  static const Color warning500 = Color(0xFFEBC981);
  static const Color warning600 = Color(0xFFE3B654);
  static const Color warning700 = Color(0xFFD79E23);
  static const Color warning800 = Color(0xFF785814);
  static const Color warning900 = Color(0xFF3F2E0A);
  static const Color warning950 = Color(0xFF2C2007);
}

/// Artwork colours — the raw (unbound) fills of illustrations drawn in code,
/// identical in light and dark mode like the artwork in Figma. They are not
/// Figma variables: each names the artwork it comes from.
class ArtworkColors {
  ArtworkColors._();

  /// Mieo's fur. Figma "Mieo Charachter" fill #FF8731.
  static const Color mieoFur = Color(0xFFFF8731);

  /// Mieo's legs and soles. Figma "Mieo Charachter" fill #FFAC71.
  static const Color mieoPaw = Color(0xFFFFAC71);

  /// Mieo's tongue, in his open smile. Figma "Mieo Charachter" fill #FF5555.
  static const Color mieoTongue = Color(0xFFFF5555);

  /// The hard shadow along the top of Mieo's cheeks when his paws squeeze
  /// them. Figma "Mieo Charachter" drop shadow #CC6C27.
  static const Color mieoCheekShadow = Color(0xFFCC6C27);

  /// The hard shadow under Mieo's arms when they lie across his body. Figma
  /// "Mieo Charachter" drop shadow #D46515.
  static const Color mieoArmShadow = Color(0xFFD46515);
}

/// Text colours. Figma `Texts/*`.
@immutable
class AppTextColors {
  const AppTextColors({
    required this.heading,
    required this.body,
    required this.primary,
    required this.secondary,
    required this.green,
    required this.red,
    required this.onPrimary,
    required this.onSecondary,
    required this.onGreen,
    required this.onRed,
    required this.onNeutral,
  });

  /// Headings and primary copy. Figma `Texts/Heading`.
  final Color heading;

  /// Secondary copy: subtitles, hints and captions. Figma `Texts/Body Text`.
  final Color body;

  /// Accent text: links, unit labels, durations. Figma `Texts/primary`.
  final Color primary;

  /// Yellow accent text. Figma `Texts/Secondary`.
  final Color secondary;

  /// Success text. Figma `Texts/Green`.
  final Color green;

  /// Error text. Figma `Texts/Red`.
  final Color red;

  /// Text on primary (blue) surfaces. Figma `Texts/On Surface/primary`.
  final Color onPrimary;

  /// Text on secondary (yellow) surfaces. Figma `Texts/On Surface/secondary`.
  final Color onSecondary;

  /// Text on green surfaces. Figma `Texts/On Surface/secondary Green`.
  final Color onGreen;

  /// Text on red surfaces. Figma `Texts/On Surface/secondary Red`.
  final Color onRed;

  /// Text on the inverse neutral surface ([AppSurfaceColors.neutral]). Figma `Texts/On Surface/Nuturel`.
  final Color onNeutral;

  /// Interpolates every colour, so theme changes animate smoothly.
  static AppTextColors lerp(AppTextColors a, AppTextColors b, double t) => AppTextColors(
    heading: Color.lerp(a.heading, b.heading, t)!,
    body: Color.lerp(a.body, b.body, t)!,
    primary: Color.lerp(a.primary, b.primary, t)!,
    secondary: Color.lerp(a.secondary, b.secondary, t)!,
    green: Color.lerp(a.green, b.green, t)!,
    red: Color.lerp(a.red, b.red, t)!,
    onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
    onSecondary: Color.lerp(a.onSecondary, b.onSecondary, t)!,
    onGreen: Color.lerp(a.onGreen, b.onGreen, t)!,
    onRed: Color.lerp(a.onRed, b.onRed, t)!,
    onNeutral: Color.lerp(a.onNeutral, b.onNeutral, t)!,
  );
}

/// Icon glyph colours. Figma `Icons/*`.
@immutable
class AppIconColors {
  const AppIconColors({required this.primary, required this.neutral, required this.onPrimary, required this.onNeutral});

  /// Accent icons: active tab, focused field icon. Figma `Icons/primary`.
  final Color primary;

  /// Default icon glyphs. Figma `Icons/Nuturel`.
  final Color neutral;

  /// Icons on primary (blue) surfaces. Figma `Icons/On Surface/primary`.
  final Color onPrimary;

  /// Icons on the inverse neutral surface ([AppSurfaceColors.neutral]). Figma `Icons/On Surface/Nuturel`.
  final Color onNeutral;

  /// Interpolates every colour, so theme changes animate smoothly.
  static AppIconColors lerp(AppIconColors a, AppIconColors b, double t) => AppIconColors(
    primary: Color.lerp(a.primary, b.primary, t)!,
    neutral: Color.lerp(a.neutral, b.neutral, t)!,
    onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
    onNeutral: Color.lerp(a.onNeutral, b.onNeutral, t)!,
  );
}

/// Fill colours for pages and components. Figma `Surface/*`.
@immutable
class AppSurfaceColors {
  const AppSurfaceColors({
    required this.body,
    required this.backgroundNeutral,
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.primary,
    required this.secondary,
    required this.green,
    required this.red,
    required this.neutral,
    required this.dimPrimary,
    required this.dimSecondary,
    required this.dimNeutral,
    required this.dimSuccess,
    required this.dimError,
    required this.extraDimPrimary,
    required this.extraDimSecondary,
    required this.extraDimNeutral,
    required this.skyTop,
    required this.skyBottom,
  });

  /// Page (scaffold) background. Figma `Surface/Body`.
  final Color body;

  /// Cards, fields, tiles, sheets, chips and the bottom bar. Figma `Surface/Background Nuturel`.
  final Color backgroundNeutral;

  /// Primary-tinted page background. Figma `Surface/Background Primacy`.
  final Color backgroundPrimary;

  /// Secondary-tinted background. Figma `Surface/Background Secondary`.
  final Color backgroundSecondary;

  /// Filled primary buttons and accents. Figma `Surface/Primary`.
  final Color primary;

  /// Filled secondary (yellow) buttons. Figma `Surface/Secondary`.
  final Color secondary;

  /// Success buttons and indicators. Figma `Surface/Green`.
  final Color green;

  /// Error buttons and indicators. Figma `Surface/Red`.
  final Color red;

  /// Inverse neutral surface: dark grey in the light theme, white in the dark theme. Figma `Surface/Nuturel`.
  final Color neutral;

  /// Selected tile, active tab highlight, shaded button. Figma `Surface/Dim/primary`.
  final Color dimPrimary;

  /// Dim secondary fill. Figma `Surface/Dim/secondary`.
  final Color dimSecondary;

  /// Disabled and locked fills. Figma `Surface/Dim/neutral`.
  final Color dimNeutral;

  /// Success feedback sheet. Figma `Surface/Dim/success`.
  final Color dimSuccess;

  /// Error feedback sheet. Figma `Surface/Dim/error`.
  final Color dimError;

  /// Faint primary fill. Figma `Surface/Extra Dim/Primary`.
  final Color extraDimPrimary;

  /// Faint secondary fill. Figma `Surface/Extra Dim/Secondary`.
  final Color extraDimSecondary;

  /// Faint neutral fill: tracks, empty progress. Figma `Surface/Extra Dim/Nuturel`.
  final Color extraDimNeutral;

  /// Top stop of the sky backdrop gradient. Figma `Surface/Sky/Top`.
  final Color skyTop;

  /// Bottom stop of the sky backdrop gradient. Figma `Surface/Sky/Bottom`.
  final Color skyBottom;

  /// Interpolates every colour, so theme changes animate smoothly.
  static AppSurfaceColors lerp(AppSurfaceColors a, AppSurfaceColors b, double t) => AppSurfaceColors(
    body: Color.lerp(a.body, b.body, t)!,
    backgroundNeutral: Color.lerp(a.backgroundNeutral, b.backgroundNeutral, t)!,
    backgroundPrimary: Color.lerp(a.backgroundPrimary, b.backgroundPrimary, t)!,
    backgroundSecondary: Color.lerp(a.backgroundSecondary, b.backgroundSecondary, t)!,
    primary: Color.lerp(a.primary, b.primary, t)!,
    secondary: Color.lerp(a.secondary, b.secondary, t)!,
    green: Color.lerp(a.green, b.green, t)!,
    red: Color.lerp(a.red, b.red, t)!,
    neutral: Color.lerp(a.neutral, b.neutral, t)!,
    dimPrimary: Color.lerp(a.dimPrimary, b.dimPrimary, t)!,
    dimSecondary: Color.lerp(a.dimSecondary, b.dimSecondary, t)!,
    dimNeutral: Color.lerp(a.dimNeutral, b.dimNeutral, t)!,
    dimSuccess: Color.lerp(a.dimSuccess, b.dimSuccess, t)!,
    dimError: Color.lerp(a.dimError, b.dimError, t)!,
    extraDimPrimary: Color.lerp(a.extraDimPrimary, b.extraDimPrimary, t)!,
    extraDimSecondary: Color.lerp(a.extraDimSecondary, b.extraDimSecondary, t)!,
    extraDimNeutral: Color.lerp(a.extraDimNeutral, b.extraDimNeutral, t)!,
    skyTop: Color.lerp(a.skyTop, b.skyTop, t)!,
    skyBottom: Color.lerp(a.skyBottom, b.skyBottom, t)!,
  );
}

/// Outline colours. Figma `Stroke/*`.
@immutable
class AppStrokeColors {
  const AppStrokeColors({
    required this.primary,
    required this.secondary,
    required this.green,
    required this.green2,
    required this.red,
    required this.neutral,
    required this.body,
    required this.dimPrimary,
    required this.dimSecondary,
    required this.dimNeutral,
    required this.dimSuccess,
    required this.dimError,
    required this.extraDimPrimary,
    required this.extraDimSecondary,
    required this.extraDimNeutral,
  });

  /// Focused field and selected tile outline. Figma `Stroke/Primary`.
  final Color primary;

  /// Secondary outline. Figma `Stroke/Secondary`.
  final Color secondary;

  /// Correct answer outline. Figma `Stroke/Green`.
  final Color green;

  /// Same value as [green]; mirrors a second Figma variable of the same colour. Figma `Stroke/Green 2`.
  final Color green2;

  /// Wrong answer outline. Figma `Stroke/Red`.
  final Color red;

  /// Strong outline: outlined buttons. Figma `Stroke/Nuturel`.
  final Color neutral;

  /// White outline on imagery. Figma `Stroke/Body`.
  final Color body;

  /// Primary-tinted outline: stat chips. Figma `Stroke/Dim/primary`.
  final Color dimPrimary;

  /// Dim secondary outline. Figma `Stroke/Dim/secondary`.
  final Color dimSecondary;

  /// Dim neutral outline. Figma `Stroke/Dim/neutral`.
  final Color dimNeutral;

  /// Dim success outline. Figma `Stroke/Dim/success`.
  final Color dimSuccess;

  /// Dim error outline. Figma `Stroke/Dim/error`.
  final Color dimError;

  /// Faint primary outline. Figma `Stroke/Extra Dim/Primary`.
  final Color extraDimPrimary;

  /// Faint secondary outline. Figma `Stroke/Extra Dim/Secondary`.
  final Color extraDimSecondary;

  /// Resting outline of cards, fields and tiles. Figma `Stroke/Extra Dim/Nuturel`.
  final Color extraDimNeutral;

  /// Interpolates every colour, so theme changes animate smoothly.
  static AppStrokeColors lerp(AppStrokeColors a, AppStrokeColors b, double t) => AppStrokeColors(
    primary: Color.lerp(a.primary, b.primary, t)!,
    secondary: Color.lerp(a.secondary, b.secondary, t)!,
    green: Color.lerp(a.green, b.green, t)!,
    green2: Color.lerp(a.green2, b.green2, t)!,
    red: Color.lerp(a.red, b.red, t)!,
    neutral: Color.lerp(a.neutral, b.neutral, t)!,
    body: Color.lerp(a.body, b.body, t)!,
    dimPrimary: Color.lerp(a.dimPrimary, b.dimPrimary, t)!,
    dimSecondary: Color.lerp(a.dimSecondary, b.dimSecondary, t)!,
    dimNeutral: Color.lerp(a.dimNeutral, b.dimNeutral, t)!,
    dimSuccess: Color.lerp(a.dimSuccess, b.dimSuccess, t)!,
    dimError: Color.lerp(a.dimError, b.dimError, t)!,
    extraDimPrimary: Color.lerp(a.extraDimPrimary, b.extraDimPrimary, t)!,
    extraDimSecondary: Color.lerp(a.extraDimSecondary, b.extraDimSecondary, t)!,
    extraDimNeutral: Color.lerp(a.extraDimNeutral, b.extraDimNeutral, t)!,
  );
}

/// Hard-shadow colours: the solid, unblurred offset under 3D components. Figma `Shadow/*`.
@immutable
class AppShadowColors {
  const AppShadowColors({
    required this.primaryFull,
    required this.primaryDarker,
    required this.primaryLighter,
    required this.secondary,
    required this.secondaryFull,
    required this.secondaryDarker,
    required this.secondaryLighter,
    required this.greenDarker,
    required this.greenLighter,
    required this.redDarker,
    required this.redLighter,
    required this.neutralFull,
    required this.neutralDarker,
    required this.neutralLight,
    required this.neutralExtraLight,
  });

  /// Under focused fields and selected tiles. Figma `Shadow/Primary/Full`.
  final Color primaryFull;

  /// Under filled primary buttons. Figma `Shadow/Primary/Darker`.
  final Color primaryDarker;

  /// Under primary-tinted chips. Figma `Shadow/Primary/Lighter`.
  final Color primaryLighter;

  /// Secondary shadow. Figma `Shadow/Secondary`.
  final Color secondary;

  /// Full secondary shadow. Figma `Shadow/Secondary/Full`.
  final Color secondaryFull;

  /// Under filled secondary buttons. Figma `Shadow/Secondary/Darker`.
  final Color secondaryDarker;

  /// Under secondary-tinted chips. Figma `Shadow/Secondary/Lighter`.
  final Color secondaryLighter;

  /// Under green buttons. Figma `Shadow/Green/Darker`.
  final Color greenDarker;

  /// Success sheet edge, green tiles. Figma `Shadow/Green/Lighter`.
  final Color greenLighter;

  /// Under red buttons. Figma `Shadow/Red/Red`.
  final Color redDarker;

  /// Error sheet edge, red tiles. Figma `Shadow/Red/Lighter`.
  final Color redLighter;

  /// Under outlined buttons. Figma `Shadow/Nutural/Full`.
  final Color neutralFull;

  /// Darkest neutral shadow. Figma `Shadow/Nutural/Darker`.
  final Color neutralDarker;

  /// Light neutral shadow. Figma `Shadow/Nutural/Light`.
  final Color neutralLight;

  /// Under neutral cards, fields and tiles. Figma `Shadow/Nutural/Extra Light`.
  final Color neutralExtraLight;

  /// Interpolates every colour, so theme changes animate smoothly.
  static AppShadowColors lerp(AppShadowColors a, AppShadowColors b, double t) => AppShadowColors(
    primaryFull: Color.lerp(a.primaryFull, b.primaryFull, t)!,
    primaryDarker: Color.lerp(a.primaryDarker, b.primaryDarker, t)!,
    primaryLighter: Color.lerp(a.primaryLighter, b.primaryLighter, t)!,
    secondary: Color.lerp(a.secondary, b.secondary, t)!,
    secondaryFull: Color.lerp(a.secondaryFull, b.secondaryFull, t)!,
    secondaryDarker: Color.lerp(a.secondaryDarker, b.secondaryDarker, t)!,
    secondaryLighter: Color.lerp(a.secondaryLighter, b.secondaryLighter, t)!,
    greenDarker: Color.lerp(a.greenDarker, b.greenDarker, t)!,
    greenLighter: Color.lerp(a.greenLighter, b.greenLighter, t)!,
    redDarker: Color.lerp(a.redDarker, b.redDarker, t)!,
    redLighter: Color.lerp(a.redLighter, b.redLighter, t)!,
    neutralFull: Color.lerp(a.neutralFull, b.neutralFull, t)!,
    neutralDarker: Color.lerp(a.neutralDarker, b.neutralDarker, t)!,
    neutralLight: Color.lerp(a.neutralLight, b.neutralLight, t)!,
    neutralExtraLight: Color.lerp(a.neutralExtraLight, b.neutralExtraLight, t)!,
  );
}

/// Sky backdrop cloud layers, in paint order: body, shade, base. Figma `Cloud Color/*`.
@immutable
class AppCloudColors {
  const AppCloudColors({required this.layer1, required this.layer2, required this.layer3});

  /// Cloud body: the whole silhouette, painted first. Figma `Cloud Color/1`.
  final Color layer1;

  /// Cloud shade: the lower half of the body, painted over it. Figma `Cloud Color/2`.
  final Color layer2;

  /// Cloud base: the rim along the bottom and small curls, painted last. Figma `Cloud Color/3`.
  final Color layer3;

  /// Interpolates every colour, so theme changes animate smoothly.
  static AppCloudColors lerp(AppCloudColors a, AppCloudColors b, double t) => AppCloudColors(
    layer1: Color.lerp(a.layer1, b.layer1, t)!,
    layer2: Color.lerp(a.layer2, b.layer2, t)!,
    layer3: Color.lerp(a.layer3, b.layer3, t)!,
  );
}

/// The Figma colour tokens for one theme mode, registered on ThemeData as an
/// extension by AppTheme. Read them with `context.colors`
/// (utils/extensions/context_extensions.dart):
///
/// ```dart
/// ColoredBox(color: context.colors.surface.backgroundNeutral)
/// ```
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.text,
    required this.icon,
    required this.surface,
    required this.stroke,
    required this.shadow,
    required this.cloud,
  });

  /// Figma `Texts/*`.
  final AppTextColors text;

  /// Figma `Icons/*`.
  final AppIconColors icon;

  /// Figma `Surface/*`.
  final AppSurfaceColors surface;

  /// Figma `Stroke/*`.
  final AppStrokeColors stroke;

  /// Figma `Shadow/*`.
  final AppShadowColors shadow;

  /// Figma `Cloud Color/*`.
  final AppCloudColors cloud;

  /// Figma "Colors" collection, Light mode.
  static const AppColorTokens light = AppColorTokens(
    text: AppTextColors(
      heading: AppColors.neutral900,
      body: AppColors.neutral600,
      primary: AppColors.primary950,
      secondary: AppColors.secondary700,
      green: AppColors.success400,
      red: Color(0xFFDD3636),
      onPrimary: AppColors.primary50,
      onSecondary: AppColors.secondary50,
      onGreen: Color(0xFFF0FFF4),
      onRed: Color(0xFFFFF0F0),
      onNeutral: AppColors.neutral50,
    ),
    icon: AppIconColors(
      primary: AppColors.primary700,
      neutral: AppColors.neutral700,
      onPrimary: AppColors.primary50,
      onNeutral: AppColors.neutral50,
    ),
    surface: AppSurfaceColors(
      body: Color(0xFFFAFAFA),
      backgroundNeutral: Color(0xFFFFFFFF),
      backgroundPrimary: AppColors.primary50,
      backgroundSecondary: Color(0xFFFFFFFF),
      primary: AppColors.primary700,
      secondary: AppColors.secondary700,
      green: AppColors.success400,
      red: Color(0xFFDD3636),
      neutral: AppColors.neutral700,
      dimPrimary: AppColors.primary100,
      dimSecondary: AppColors.secondary200,
      dimNeutral: AppColors.neutral300,
      dimSuccess: Color(0xFFEDFFF2),
      dimError: Color(0xFFFFEDED),
      extraDimPrimary: AppColors.primary50,
      extraDimSecondary: AppColors.secondary100,
      extraDimNeutral: AppColors.neutral100,
      skyTop: AppColors.primary300,
      skyBottom: Color(0xFFFFFFFF),
    ),
    stroke: AppStrokeColors(
      primary: AppColors.primary700,
      secondary: AppColors.secondary700,
      green: AppColors.success400,
      green2: Color(0xFF34C759),
      red: Color(0xFFDD3636),
      neutral: AppColors.neutral700,
      body: Color(0xFFFFFFFF),
      dimPrimary: AppColors.primary200,
      dimSecondary: AppColors.secondary200,
      dimNeutral: AppColors.neutral300,
      dimSuccess: Color(0xFFEDFFF2),
      dimError: Color(0xFFF5C3C3),
      extraDimPrimary: AppColors.primary50,
      extraDimSecondary: AppColors.secondary100,
      extraDimNeutral: AppColors.neutral100,
    ),
    shadow: AppShadowColors(
      primaryFull: Color(0xFF1AB3FF),
      primaryDarker: Color(0xFF3E8CB2),
      primaryLighter: Color(0xFFC9EDFF),
      secondary: Color(0xFF996E16),
      secondaryFull: Color(0xFFFFCB61),
      secondaryDarker: Color(0xFF996E16),
      secondaryLighter: AppColors.secondary200,
      greenDarker: AppColors.success700,
      greenLighter: AppColors.success50,
      redDarker: AppColors.error900,
      redLighter: Color(0xFFF5C3C3),
      neutralFull: Color(0xFF464E53),
      neutralDarker: Color(0xFF000000),
      neutralLight: Color(0xFFADB5BA),
      neutralExtraLight: Color(0xFFE3E6E8),
    ),
    cloud: AppCloudColors(layer1: Color(0xFFFFFFFF), layer2: Color(0xFFE9F7FF), layer3: Color(0xFFCFEBFF)),
  );

  /// Figma "Colors" collection, Dark mode.
  static const AppColorTokens dark = AppColorTokens(
    text: AppTextColors(
      heading: AppColors.neutral100,
      body: AppColors.neutral300,
      primary: AppColors.primary950,
      secondary: AppColors.secondary700,
      green: AppColors.success400,
      red: Color(0xFFDD3636),
      onPrimary: AppColors.primary50,
      onSecondary: AppColors.secondary50,
      onGreen: Color(0xFFF0FFF4),
      onRed: Color(0xFFFFF0F0),
      onNeutral: AppColors.neutral700,
    ),
    icon: AppIconColors(
      primary: AppColors.primary950,
      neutral: AppColors.neutral200,
      onPrimary: AppColors.primary50,
      onNeutral: AppColors.neutral700,
    ),
    surface: AppSurfaceColors(
      body: AppColors.neutral900,
      backgroundNeutral: AppColors.neutral800,
      backgroundPrimary: AppColors.neutral900, // Figma alias: Surface/Body
      backgroundSecondary: Color(0xFF2F2002),
      primary: AppColors.primary950,
      secondary: AppColors.secondary700,
      green: AppColors.success400,
      red: Color(0xFFDD3636),
      neutral: AppColors.neutral50,
      dimPrimary: Color(0x291AB3FF), // #1AB3FF 16%
      dimSecondary: Color(0x1FFFB724), // #FFB724 12%
      dimNeutral: AppColors.neutral700,
      dimSuccess: Color(0xFF1A2F24),
      dimError: Color(0xFF2E1D1F),
      extraDimPrimary: Color(0x1F1AB3FF), // #1AB3FF 12%
      extraDimSecondary: Color(0x0DFFCB61), // #FFCB61 5%
      extraDimNeutral: AppColors.neutral700,
      skyTop: Color(0x14FFFFFF), // #FFFFFF 8%
      skyBottom: Color(0x00FFFFFF), // #FFFFFF 0%
    ),
    stroke: AppStrokeColors(
      primary: AppColors.primary950,
      secondary: AppColors.secondary700,
      green: AppColors.success400,
      green2: Color(0xFF34C759),
      red: Color(0xFFDD3636),
      neutral: AppColors.neutral100,
      body: Color(0xFFFFFFFF),
      dimPrimary: AppColors.neutral700,
      dimSecondary: Color(0x1FFFCB61), // #FFCB61 12%
      dimNeutral: Color(0x1FE3E6E8), // #E3E6E8 12%
      dimSuccess: AppColors.success700,
      dimError: Color(0xFFDD3636), // Figma alias: Texts/Red
      extraDimPrimary: AppColors.primary50,
      extraDimSecondary: AppColors.secondary100,
      extraDimNeutral: AppColors.neutral700,
    ),
    shadow: AppShadowColors(
      primaryFull: Color(0xFF1AB3FF),
      primaryDarker: Color(0xFF006EA4),
      primaryLighter: AppColors.neutral700,
      secondary: Color(0xFF996E16),
      secondaryFull: Color(0xFF996E16),
      secondaryDarker: Color(0xFFFFF1D3),
      secondaryLighter: Color(0xFF3F2D0C),
      greenDarker: AppColors.success700,
      greenLighter: AppColors.success400,
      redDarker: AppColors.error900,
      redLighter: AppColors.error700,
      neutralFull: Color(0xFFE3E6E8),
      neutralDarker: Color(0xFF000000),
      neutralLight: Color(0xFF5D686F),
      neutralExtraLight: Color(0xFF464E53),
    ),
    cloud: AppCloudColors(layer1: Color(0xFF2A2D30), layer2: Color(0xFF414548), layer3: Color(0xFF535B5F)),
  );

  /// The token set for [brightness].
  static AppColorTokens forBrightness(Brightness brightness) => switch (brightness) {
    Brightness.light => light,
    Brightness.dark => dark,
  };

  @override
  AppColorTokens copyWith({
    AppTextColors? text,
    AppIconColors? icon,
    AppSurfaceColors? surface,
    AppStrokeColors? stroke,
    AppShadowColors? shadow,
    AppCloudColors? cloud,
  }) {
    return AppColorTokens(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      surface: surface ?? this.surface,
      stroke: stroke ?? this.stroke,
      shadow: shadow ?? this.shadow,
      cloud: cloud ?? this.cloud,
    );
  }

  @override
  AppColorTokens lerp(AppColorTokens? other, double t) {
    if (other == null) {
      return this;
    }
    return AppColorTokens(
      text: AppTextColors.lerp(text, other.text, t),
      icon: AppIconColors.lerp(icon, other.icon, t),
      surface: AppSurfaceColors.lerp(surface, other.surface, t),
      stroke: AppStrokeColors.lerp(stroke, other.stroke, t),
      shadow: AppShadowColors.lerp(shadow, other.shadow, t),
      cloud: AppCloudColors.lerp(cloud, other.cloud, t),
    );
  }
}

import 'package:flutter/painting.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THEME CONSTANTS
//
// Every spacing, radius, stroke, hard-shadow, icon and layout value widgets
// use, mirroring the Figma "Spacing & Radius" collection, the `Border`
// variable, the "Layout Grid" style and the values the components repeat.
// Widgets reference these by name: a bare number for a gap, padding, radius
// or size in a screen or widget file is a rule violation (tool/check_rules.sh).
//
// Values are Figma pixels used 1:1 as logical pixels (design frame 375 × 812
// @1x), never scaled by screen size. Names carry the pixel value, so a Figma
// spec maps straight to a token: gap 16 → spacing16, radius 12 → radius12.
//
// A value the design repeats that isn't here yet is added here first, with its
// Figma source; a one-off component dimension becomes a named constant in that
// component's file.
// ─────────────────────────────────────────────────────────────────────────────
class ThemeConstants {
  ThemeConstants._();

  // ── Spacing — Figma Spacing/* ──
  static const double spacing4 = 4; // Spacing/0,5
  static const double spacing8 = 8; // Spacing/1
  static const double spacing12 = 12; // Spacing/1,5
  static const double spacing16 = 16; // Spacing/2
  static const double spacing24 = 24; // Spacing/3
  static const double spacing28 = 28; // no variable: the section gap of the Login and Create Profile forms
  static const double spacing32 = 32; // Spacing/4
  static const double spacing40 = 40; // Spacing/5
  static const double spacing48 = 48; // Spacing/6
  static const double spacing64 = 64; // Spacing/8
  static const double spacing80 = 80; // Spacing/10
  static const double spacing96 = 96; // Spacing/12
  static const double spacing128 = 128; // Spacing/16

  // ── Radius — corner radii the components use (Figma has no radius variables) ──
  static const double radius8 = 8;
  static const double radius12 = 12; // text fields
  static const double radius16 = 16; // buttons, cards, option tiles
  static const double radius24 = 24; // sheets, large cards, rounded app-bar bottom

  /// Fully rounded ends: pills, chips, circles (Figma uses 100 and 1000).
  static const double radiusPill = 1000;

  // ── Stroke — Figma Border ──
  /// Outline width of cards, fields, tiles, chips and outlined buttons.
  static const double borderWidth = 1.5;

  /// Figma draws component outlines outside the frame, so a border never
  /// changes the component's layout size (AppBorders applies it).
  static const double borderStrokeAlign = BorderSide.strokeAlignOutside;

  // ── Hard shadow (AppShadows in core/theme/app_decorations.dart) ──
  /// Solid, unblurred offset under buttons, cards and chips.
  static const double hardShadowOffset = 4;

  /// Smaller offset under text fields, tiles and small chips.
  static const double hardShadowOffsetSm = 2;

  // ── Icons ──
  static const double iconSize16 = 16;
  static const double iconSize20 = 20;

  /// Figma icon frame size.
  static const double iconSize24 = 24;

  /// Minimum size of anything tappable (Material / WCAG).
  static const double minTapTarget = 48;

  // ── Buttons — Figma Button (53:1086) ──
  /// Height of the standard button: its label box with 14 above and below.
  static const double buttonHeight = 48;

  // ── Fields — Figma Input Field (277:5682) ──
  /// Height of text fields, dropdowns and the social sign-in buttons: a 24
  /// icon with 14 above and below.
  static const double fieldHeight = 52;

  // ── System insets ──
  /// Bottom inset of the iPhone home indicator. Figma layouts sit their bottom
  /// content over an inset this size (or a smaller gesture pill); a taller
  /// inset is a navigation bar, which content is lifted above
  /// (`context.navigationBarInset`).
  static const double homeIndicatorInset = 34;

  // ── Layout — Figma "Layout Grid": 4 columns, 16 gutter, 16 margin ──
  /// Horizontal gutter between screen content and the device edge.
  static const double screenPaddingHorizontal = spacing16;

  /// Gap between columns of a grid.
  static const double gridGutter = spacing16;

  /// Shortest-side width at which the layout switches from Mobile to Tablet
  /// (Material 3's compact → medium window-size boundary).
  static const double tabletBreakpoint = 600;

  /// Content column width cap on tablets, so forms, cards and text keep their
  /// mobile proportions instead of stretching edge-to-edge.
  static const double maxContentWidth = 560;
}

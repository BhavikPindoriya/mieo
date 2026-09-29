import 'package:flutter/painting.dart';

import '../constants/theme_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP DECORATIONS
//
// The two decoration recipes almost every Mieo component shares, so each
// component states only its colours:
//
//   • AppBorders — the Figma `Border` outline: 1.5px, drawn outside the frame
//     so it never changes the component's layout size.
//   • AppShadows — the "hard shadow" behind Mieo's 3D look: a solid, unblurred
//     copy of the component's shape offset straight down (Figma drop shadow
//     x 0, y 4 or 2, blur 0) in a `Shadow/*` token colour. Figma casts it from
//     the whole layer including the outside outline, so a bordered component's
//     shadow spreads by the border width to cover the same area. A negative
//     offset casts upwards (feedback sheets and bars pinned to the bottom).
//
// Pressed 3D components move down by their shadow offset while the shadow
// animates to 0: that sink is Mieo's press feedback.
//
// Colours always come from `context.colors` (stroke.* for outlines, shadow.*
// for shadows), so both recipes follow the active theme.
// ─────────────────────────────────────────────────────────────────────────────
class AppBorders {
  AppBorders._();

  /// The standard component outline in [color], e.g. `stroke.extraDimNeutral`.
  static Border outline(Color color) =>
      Border.all(color: color, width: ThemeConstants.borderWidth, strokeAlign: ThemeConstants.borderStrokeAlign);

  /// The same outline as a single side, for InputBorder and shape borders.
  static BorderSide side(Color color) =>
      BorderSide(color: color, width: ThemeConstants.borderWidth, strokeAlign: ThemeConstants.borderStrokeAlign);
}

class AppShadows {
  AppShadows._();

  /// The hard shadow under a component, in the Figma `Shadow/*` [color].
  ///
  /// [bordered] matches a component drawn with [AppBorders.outline].
  static List<BoxShadow> hard(Color color, {double offset = ThemeConstants.hardShadowOffset, bool bordered = true}) => [
    BoxShadow(color: color, offset: Offset(0, offset), spreadRadius: bordered ? ThemeConstants.borderWidth : 0),
  ];
}

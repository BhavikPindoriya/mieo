import 'package:flutter/painting.dart';

import '../../../core/theme/colors.dart';

/// Reads one colour from the active theme's Figma tokens.
typedef ColorResolver = Color Function(AppColorTokens colors);

/// One Figma colour variable, e.g. `Surface/Dim/primary`, and how to read it
/// from the active theme's [AppColorTokens].
class ColorToken {
  const ColorToken({required this.figmaName, required this.dartName, required this.resolve});

  /// Figma variable name, e.g. `Surface/Dim/primary`.
  final String figmaName;

  /// Accessor on `context.colors`, e.g. `surface.dimPrimary`.
  final String dartName;

  final ColorResolver resolve;

  /// `#RRGGBB`, plus the opacity when the colour is translucent.
  static String hexOf(Color color) {
    final argb = color.toARGB32();
    final rgb = (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
    final alpha = argb >> 24;
    return alpha == 0xFF ? '#$rgb' : '#$rgb · ${(alpha / 0xFF * 100).round()}%';
  }
}

/// A Figma variable group, e.g. every `Surface/*` token.
class ColorTokenGroup {
  const ColorTokenGroup({required this.figmaName, required this.tokens});

  final String figmaName;
  final List<ColorToken> tokens;
}

/// One primitive colour family, `Shades/<family>/50…950`.
class ColorRamp {
  const ColorRamp({required this.figmaName, required this.colors});

  /// The Figma step of each entry in [colors].
  static const List<int> steps = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950];

  final String figmaName;
  final List<Color> colors;
}

/// The primitive palette, `Shades/*`.
class ColorRampGroup {
  const ColorRampGroup({required this.figmaName, required this.ramps});

  final String figmaName;
  final List<ColorRamp> ramps;
}

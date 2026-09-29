import 'package:flutter/material.dart';

import '../../../core/theme/fonts.dart';
import 'size_token.dart';

/// Reads one text style from the active theme's TextTheme.
typedef TextStyleResolver = TextStyle? Function(TextTheme textTheme);

/// One Figma text style, e.g. `Mieo/title/medium`, and its Flutter role.
class TypeStyleToken {
  const TypeStyleToken({required this.figmaName, required this.role, required this.weightName, required this.resolve});

  /// Figma style name, e.g. `Mieo/title/medium`.
  final String figmaName;

  /// TextTheme role, e.g. `titleMedium`.
  final String role;

  /// Figma font style: Medium, SemiBold, Bold, ExtraBold or Black.
  final String weightName;

  final TextStyleResolver resolve;

  /// `textTheme.displayLarge · Nunito Black · 57 / -0.25`: the Flutter role,
  /// then family, weight, size and letter spacing of the resolved [style].
  String describe(TextStyle? style) =>
      'textTheme.$role · ${AppFonts.fontFamily} $weightName · '
      '${_number(style?.fontSize)} / ${_number(style?.letterSpacing)}';

  static String _number(double? value) => value == null ? '–' : SizeToken.format(value);
}

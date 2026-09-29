import 'color_token.dart';

/// One component look built on a hard shadow: its fill, optional outline and
/// Figma `Shadow/*` colour, all read from the active theme.
class ShadowToken {
  const ShadowToken({
    required this.figmaName,
    required this.offset,
    required this.fill,
    required this.shadow,
    this.border,
  });

  /// Figma shadow variable, e.g. `Shadow/Primary/Darker`.
  final String figmaName;

  /// Downward offset of the shadow in logical pixels.
  final double offset;

  final ColorResolver fill;
  final ColorResolver shadow;

  /// Outline colour, for looks drawn with the standard outside border.
  final ColorResolver? border;
}

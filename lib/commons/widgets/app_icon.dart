import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/theme_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP ICON
//
// One of the Figma icons exported to assets/icons (AssetsConstants.ic*),
// drawn in a [size] square (24, the Figma icon frame, by default).
//
//   • Line icons are tinted: [color] (a context.colors token) replaces the
//     glyph's own colour, so they follow the theme.
//   • Multi-colour icons (brand logos) leave [color] null and keep their own
//     colours in both themes, like Figma.
//   • [matchTextDirection] mirrors a glyph that points along the reading
//     direction (the back arrow) in RTL.
//
// Decorative unless given a [semanticLabel].
// ─────────────────────────────────────────────────────────────────────────────
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.asset, {
    super.key,
    this.color,
    this.size = ThemeConstants.iconSize24,
    this.matchTextDirection = false,
    this.semanticLabel,
  });

  /// An `AssetsConstants.ic*` path.
  final String asset;

  /// Tint of a line icon; null draws the SVG's own colours.
  final Color? color;

  final double size;
  final bool matchTextDirection;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tint = color;
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      matchTextDirection: matchTextDirection,
      colorFilter: tint == null ? null : ColorFilter.mode(tint, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}

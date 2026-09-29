import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RESPONSIVE CONTENT
//
// Wraps a screen's content column so the same layout reads correctly on
// Mobile and Tablet:
//
//   • Mobile — content fills the width, inset by the horizontal screen
//     gutter (the Figma frame's side padding).
//   • Tablet — the same content is capped at [maxWidth] and centered, so
//     forms, cards and text lines keep their mobile proportions instead of
//     stretching edge-to-edge.
//
// Layouts that should genuinely *use* the extra tablet width (grids, two-pane
// views) adapt with `context.responsive(...)` instead of being capped.
// ─────────────────────────────────────────────────────────────────────────────
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = ThemeConstants.maxContentWidth,
    this.horizontalPadding = ThemeConstants.screenPaddingHorizontal,
  });

  final Widget child;
  final double maxWidth;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}

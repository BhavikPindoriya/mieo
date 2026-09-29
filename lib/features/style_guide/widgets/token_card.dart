import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TOKEN CARD
//
// The neutral Mieo card the style guide lays its samples on: Surface/Background
// Nuturel fill, Stroke/Extra Dim/Nuturel outline and a 2px Shadow/Nutural/Extra
// Light hard shadow at radius 12. The child is clipped to the card's corners.
// ─────────────────────────────────────────────────────────────────────────────
class TokenCard extends StatelessWidget {
  const TokenCard({super.key, required this.child});

  final Widget child;

  static const BorderRadiusGeometry _radius = BorderRadiusDirectional.all(Radius.circular(ThemeConstants.radius12));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.backgroundNeutral,
        borderRadius: _radius,
        border: AppBorders.outline(colors.stroke.extraDimNeutral),
        boxShadow: AppShadows.hard(colors.shadow.neutralExtraLight, offset: ThemeConstants.hardShadowOffsetSm),
      ),
      child: ClipRRect(borderRadius: _radius, child: child),
    );
  }
}

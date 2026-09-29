import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';
import '../../core/theme/fonts.dart';
import '../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP TAG
//
// A small label chip with an optional leading icon: the Figma "Tag" of the
// Onboarding intro ("100% Kids Safe", 31:93). Surface/Extra Dim/Primary fill
// in 8-radius corners with a 1px Stroke/Dim/primary outline inside them,
// padding 12 × 8, a 16 × 16 icon 8 before a label/medium - prominent label in
// Texts/primary. Hugs its content; the label stays on one line.
// ─────────────────────────────────────────────────────────────────────────────
class AppTag extends StatelessWidget {
  const AppTag({super.key, required this.label, this.icon});

  final String label;

  /// Leading icon, laid out in a 16 × 16 box.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final leading = icon;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.extraDimPrimary,
        // Border.all's default width and alignment: the Figma 1px stroke inside.
        border: Border.all(color: colors.stroke.dimPrimary),
        borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.radius8)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: ThemeConstants.spacing12,
          vertical: ThemeConstants.spacing8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: ThemeConstants.spacing8,
          children: [
            if (leading != null) SizedBox.square(dimension: ThemeConstants.iconSize16, child: leading),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMediumProminent?.copyWith(color: colors.text.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

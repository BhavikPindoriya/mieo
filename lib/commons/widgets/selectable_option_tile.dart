import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';
import '../../core/theme/app_decorations.dart';
import '../../utils/extensions/context_extensions.dart';
import 'app_pressable.dart';
import 'app_radio.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SELECTABLE OPTION TILE
//
// Figma "Input Option" (37:7612): one answer in a list where one is picked (a
// language, a level). A full-width 3D tile (AppPressable, radius 16) with, 16
// apart, a 24 icon (a flag, a level icon), the label in body/large filling the
// row, and an AppRadio at the end; 24 padding before, 16 after, 16 above and
// below, so the tile is 56 high.
//
//   off — Surface/Background Nuturel inside a Stroke/Extra Dim/Nuturel
//         outline, on a hard shadow 2 in Shadow/Nutural/Extra Light;
//   on  — Surface/Extra Dim/Primary inside a Stroke/Primary outline, on a
//         hard shadow 4 in Shadow/Primary/Full, the radio on.
//
// Pressing sinks it into its shadow. Laid out Row-wise, so it mirrors in RTL.
// Screen readers hear a selectable item, and whether it is selected.
// ─────────────────────────────────────────────────────────────────────────────
class SelectableOptionTile extends StatelessWidget {
  const SelectableOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  /// A 24 × 24 picture before the label.
  final Widget icon;

  final String label;

  final bool selected;

  /// Called on tap; null disables it.
  final VoidCallback? onPressed;

  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(ThemeConstants.radius16));

  static const EdgeInsetsDirectional _padding = EdgeInsetsDirectional.fromSTEB(
    ThemeConstants.spacing24,
    ThemeConstants.spacing16,
    ThemeConstants.spacing16,
    ThemeConstants.spacing16,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // One node for screen readers: the button, its label and whether it is
    // selected.
    return MergeSemantics(
      child: Semantics(
        selected: selected,
        inMutuallyExclusiveGroup: true,
        child: AppPressable(
          onPressed: onPressed,
          style: selected
              ? PressableStyle(
                  // Surface/Extra Dim/Primary is translucent in dark mode. Figma
                  // never draws a drop shadow through its shape, so the fill is
                  // flattened onto the page colour and the shadow stays hidden.
                  color: Color.alphaBlend(colors.surface.extraDimPrimary, colors.surface.body),
                  border: AppBorders.outline(colors.stroke.primary),
                  shadowColor: colors.shadow.primaryFull,
                  borderRadius: _borderRadius,
                )
              : PressableStyle(
                  color: colors.surface.backgroundNeutral,
                  border: AppBorders.outline(colors.stroke.extraDimNeutral),
                  shadowColor: colors.shadow.neutralExtraLight,
                  borderRadius: _borderRadius,
                  depth: ThemeConstants.hardShadowOffsetSm,
                ),
          child: Padding(
            padding: _padding,
            child: Row(
              spacing: ThemeConstants.spacing16,
              children: [
                SizedBox.square(dimension: ThemeConstants.iconSize24, child: icon),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                AppRadio(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

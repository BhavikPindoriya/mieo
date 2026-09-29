import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';
import '../../core/theme/fonts.dart';
import '../../utils/extensions/context_extensions.dart';
import 'app_pressable.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP SOCIAL BUTTON
//
// The sign-in choice buttons: Login's Google and Apple (366:15242,
// 366:15246), and Save your journey's "Sign Up with Google" and "Create New
// Account". A 52-high tile on Surface/Background Nuturel with a 2px
// Stroke/Extra Dim/Nuturel border inside its 16-radius corners and a hard
// shadow 4 below in Shadow/Nutural/Extra Light; a 24 icon 10 before a
// label/large - prominent label in Texts/Body Text, centred between 24 side
// paddings. Pressing sinks it into its shadow (AppPressable).
// ─────────────────────────────────────────────────────────────────────────────

/// Figma draws these borders 2px wide, inside the tile.
const double _borderWidth = 2;

/// Gap between the icon and the label.
const double _iconGap = 10;

class AppSocialButton extends StatelessWidget {
  const AppSocialButton({super.key, required this.icon, required this.label, required this.onPressed});

  /// A 24 icon: a brand logo in its own colours, or a line icon tinted
  /// Icons/Nuturel.
  final Widget icon;

  final String label;

  /// Called on tap; null disables it.
  final VoidCallback? onPressed;

  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(ThemeConstants.radius16));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onPressed: onPressed,
      style: PressableStyle(
        color: colors.surface.backgroundNeutral,
        shadowColor: colors.shadow.neutralExtraLight,
        border: Border.all(color: colors.stroke.extraDimNeutral, width: _borderWidth),
        borderRadius: _borderRadius,
      ),
      child: SizedBox(
        height: ThemeConstants.fieldHeight,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: ThemeConstants.spacing24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: _iconGap,
            children: [
              SizedBox.square(dimension: ThemeConstants.iconSize24, child: icon),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLargeProminent?.copyWith(color: colors.text.body),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

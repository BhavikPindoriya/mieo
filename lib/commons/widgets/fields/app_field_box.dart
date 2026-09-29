import 'package:flutter/material.dart';

import '../../../core/constants/animation_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/colors.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../app_icon.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP FIELD BOX
//
// The box of the Figma "Input Field" (277:5682), around whatever shows the
// value (a TextField, a dropdown's choice): 52 high with 12-radius corners on
// Surface/Background Nuturel, a 1.5 outline and a hard shadow 2 below. Inside,
// 12 from each side: an optional 24 leading icon, 16, the content, 16, an
// optional 24 trailing widget.
//
// The outline, shadow and leading icon follow the field's status (the Figma
// variant), animating briefly when it changes:
//
//   idle     empty, not focused  Stroke/Extra Dim/Nuturel  Shadow/Nutural/Extra Light  icon Icons/Nuturel  (Default)
//   focused  being edited        Stroke/Primary            Shadow/Primary/Full         icon Icons/primary  (Focused)
//   filled   holds a value       Stroke/Dim/neutral        Shadow/Nutural/Light        icon Icons/Nuturel  (Selected)
//   error    failed validation   Stroke/Red                Shadow/Red/Lighter          icon Icons/Nuturel  (no variant)
//
// The padding is laid out inside the Row, so the Row spans the whole box and
// a trailing action can take taps in the margin around its icon
// (AppTapTarget).
// ─────────────────────────────────────────────────────────────────────────────

/// The state an input shows, one look each (see [AppFieldBox]).
enum AppFieldStatus {
  /// Empty and not focused: Figma "Default", which shows the placeholder.
  idle,

  /// Being edited: Figma "Focused".
  focused,

  /// Holds a value, not focused: Figma "Selected".
  filled,

  /// Failed validation; the error shows under the box (AppFieldLayout).
  error,
}

class AppFieldBox extends StatelessWidget {
  const AppFieldBox({super.key, required this.status, required this.child, this.leadingIcon, this.trailing});

  final AppFieldStatus status;

  /// The value (or the widget editing it), filling the space between the
  /// icons.
  final Widget child;

  /// An `AssetsConstants.ic*` line icon shown at the start, tinted by status.
  final String? leadingIcon;

  /// A 24 × 24 widget at the end: an icon, or a small action wrapped in an
  /// AppTapTarget.
  final Widget? trailing;

  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(ThemeConstants.radius12));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (outline, shadow) = _outlineAndShadow(colors);
    final leadingIcon = this.leadingIcon;
    final trailing = this.trailing;
    return AnimatedContainer(
      duration: AnimationConstants.durationFast,
      curve: AnimationConstants.curveStandard,
      height: ThemeConstants.fieldHeight,
      decoration: BoxDecoration(
        color: colors.surface.backgroundNeutral,
        border: AppBorders.outline(outline),
        borderRadius: _borderRadius,
        boxShadow: AppShadows.hard(shadow, offset: ThemeConstants.hardShadowOffsetSm),
      ),
      child: Row(
        children: [
          const SizedBox(width: ThemeConstants.spacing12),
          if (leadingIcon != null) ...[
            AppIcon(leadingIcon, color: status == AppFieldStatus.focused ? colors.icon.primary : colors.icon.neutral),
            const SizedBox(width: ThemeConstants.spacing16),
          ],
          Expanded(child: child),
          if (trailing != null) ...[const SizedBox(width: ThemeConstants.spacing16), trailing],
          const SizedBox(width: ThemeConstants.spacing12),
        ],
      ),
    );
  }

  (Color outline, Color shadow) _outlineAndShadow(AppColorTokens colors) => switch (status) {
    AppFieldStatus.idle => (colors.stroke.extraDimNeutral, colors.shadow.neutralExtraLight),
    AppFieldStatus.focused => (colors.stroke.primary, colors.shadow.primaryFull),
    AppFieldStatus.filled => (colors.stroke.dimNeutral, colors.shadow.neutralLight),
    AppFieldStatus.error => (colors.stroke.red, colors.shadow.redLighter),
  };
}

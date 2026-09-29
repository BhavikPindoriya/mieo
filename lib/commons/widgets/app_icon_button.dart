import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/assets_constants.dart';
import '../../core/constants/theme_constants.dart';
import '../../core/localization/lang_keys.dart';
import '../../core/theme/app_decorations.dart';
import '../../utils/extensions/context_extensions.dart';
import 'app_icon.dart';
import 'app_pressable.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP ICON BUTTON
//
// Figma "Back Button" (53:1329): a 48 × 48 square with 12-radius corners on
// Surface/Background Nuturel inside a Stroke/Extra Dim/Nuturel outline, a
// hard shadow 2 below in Shadow/Nutural/Extra Light, and a 24 icon centred in
// it. Pressing sinks it into its shadow (AppPressable).
//
//   AppIconButton — the shell around any icon (Figma "Back Button/Speak" puts
//                   a speaker in it), tinted Icons/Nuturel by the caller.
//   AppBackButton — the back arrow: mirrored in RTL, and goes back a page
//                   unless given its own onPressed.
// ─────────────────────────────────────────────────────────────────────────────
class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, required this.icon, required this.semanticLabel, required this.onPressed});

  /// Width and height: a 24 icon with 12 around it, also the minimum tap
  /// target.
  static const double size = ThemeConstants.minTapTarget;

  /// A 24 icon, e.g. an AppIcon in `context.colors.icon.neutral`.
  final Widget icon;

  /// What screen readers announce for it.
  final String semanticLabel;

  /// Called on tap; null disables it.
  final VoidCallback? onPressed;

  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(ThemeConstants.radius12));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      style: PressableStyle(
        color: colors.surface.backgroundNeutral,
        shadowColor: colors.shadow.neutralExtraLight,
        border: AppBorders.outline(colors.stroke.extraDimNeutral),
        borderRadius: _borderRadius,
        depth: ThemeConstants.hardShadowOffsetSm,
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(child: icon),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});

  /// Replaces going back a page.
  final VoidCallback? onPressed;

  static void _goBack() => Get.back<void>();

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: AppIcon(AssetsConstants.icArrowLeft, color: context.colors.icon.neutral, matchTextDirection: true),
      semanticLabel: LangKeys.actionBack.tr,
      onPressed: onPressed ?? _goBack,
    );
  }
}

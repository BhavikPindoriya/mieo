import 'package:flutter/widgets.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/constants/theme_constants.dart';
import '../../core/theme/app_decorations.dart';
import '../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP RADIO
//
// Figma "Radio Button'" (37:7589): the 21 dot at the end of an option tile.
//
//   off — Surface/Background Nuturel inside a 1.5 Surface/Extra Dim/Nuturel
//         outline, on a hard shadow 2 below in the same colour;
//   on  — Surface/Primary with an 8 Icons/On Surface/primary dot in the
//         middle, no outline and no shadow.
//
// Switching cross-fades the look and pops the dot in or out. It only shows
// the state; the tile around it takes the tap and tells screen readers.
// ─────────────────────────────────────────────────────────────────────────────
class AppRadio extends StatelessWidget {
  const AppRadio({super.key, required this.selected});

  /// Width and height, outline aside.
  static const double size = 21;

  static const double _dotSize = 8;

  /// The dot's scale when off: hidden.
  static const double _dotHidden = 0;
  static const double _dotShown = 1;

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: AnimationConstants.durationFast,
      curve: AnimationConstants.curveStandard,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.surface.primary : colors.surface.backgroundNeutral,
        border: selected ? null : AppBorders.outline(colors.surface.extraDimNeutral),
        boxShadow: selected
            ? null
            : AppShadows.hard(colors.surface.extraDimNeutral, offset: ThemeConstants.hardShadowOffsetSm),
      ),
      child: Center(
        child: AnimatedScale(
          scale: selected ? _dotShown : _dotHidden,
          duration: AnimationConstants.durationFast,
          curve: AnimationConstants.curveStandard,
          child: SizedBox.square(
            dimension: _dotSize,
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: colors.icon.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

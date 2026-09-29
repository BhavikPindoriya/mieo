import 'dart:ui';

import '../../../core/theme/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MASCOT EFFECTS
//
// The pieces the code-drawn Mieo poses (WelcomeMascotPainter,
// HelloMascotPainter, PleaseMascotPainter) share: his raw black and white, and
// the two hard Figma effects every pose uses, each turned into a path:
//
//   • Drop shadow  — the shape moved by the shadow offset, minus the shape:
//                    the sliver that shows beside it. Never shows through the
//                    shape, like Figma's.
//   • Inner shadow — the white rim along a shape's top edge: the shape minus
//                    the shape moved down by the rim's depth
//                    ([MascotEffects.rimDepth] unless a pose says otherwise).
//
// Figma exports the offsets in page space, so a rotated layer's shadow still
// falls straight down.
// ─────────────────────────────────────────────────────────────────────────────
abstract final class MascotEffects {
  /// Raw black in the artwork (eyes, nose, mouth, shadows).
  static const Color black = AppColors.neutral950;

  /// Raw white in the artwork (glints, muzzle, belly, rims).
  static const Color white = AppColors.neutral50;

  /// Depth and opacity of the white inner-shadow rim on the fur shapes.
  static const double rimDepth = 2.902;
  static const double rimOpacity = 0.55;

  /// The part of [shape] moved by [offset] that [shape] doesn't cover.
  static Path dropShadow(Path shape, Offset offset) =>
      Path.combine(PathOperation.difference, shape.shift(offset), shape);

  /// The band along the top edge of [shape] left uncovered by [shape] moved
  /// down by [depth].
  static Path topRim(Path shape, {double depth = rimDepth}) =>
      Path.combine(PathOperation.difference, shape, shape.shift(Offset(0, depth)));

  /// The inner shadow of [shape] cast by a light at [offset]: the part of
  /// [shape] that [shape] moved by [offset] doesn't cover.
  static Path innerShadow(Path shape, Offset offset) =>
      Path.combine(PathOperation.difference, shape, shape.shift(offset));
}

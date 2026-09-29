import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../core/constants/theme_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MEADOW STAGE
//
// A meadow scene (clouds, hills and trees, plus a screen's talk bubble and
// Mieo) is one picture laid out in the coordinates of the Figma "BOdy" frame,
// 375 × 716. MeadowStage fits that frame into the sky panel with one uniform
// scale:
//
//   • Bottom-anchored and centred like the Figma frame, so on the 375 × 812
//     reference the mapping is the identity and every layer lands on its Figma
//     pixel. Taller screens show more sky above the clouds.
//   • The must-see band, from [mustSeeTop] (the screen's talk bubble) down to
//     the panel's bottom edge (Mieo's feet and the meadow), stays [clearance]
//     below the top bar. On a short panel the frame shrinks, never below
//     [minScale].
//   • Phones keep the design size at most; tablets may grow the frame to the
//     width of the content column (ThemeConstants.maxContentWidth).
//
// [minSlotHeight] fits the band at [minScale]: the panel scrolls rather than
// give the scene less room.
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class MeadowStage {
  const MeadowStage._({required this.scale, required this.frameRect});

  /// Fits the frame into [slot], keeping the band from [mustSeeTop] down clear
  /// of the [topInset] (status bar and top bar) at the top of the slot.
  /// [maxScale] is [designScale] on phones and [tabletMaxScale] on tablets.
  factory MeadowStage.fit(Size slot, {required double mustSeeTop, required double topInset, required double maxScale}) {
    final fitScale = (slot.height - topInset - clearance) / (frameSize.height - mustSeeTop);
    final scale = math.max(minScale, math.min(fitScale, maxScale));
    return MeadowStage._(
      scale: scale,
      frameRect: Alignment.bottomCenter.inscribe(frameSize * scale, Offset.zero & slot),
    );
  }

  static const double _frameWidth = 375;

  /// Figma frame "BOdy" of the New Account Progress screens (e.g. Light
  /// 62:3650 / Dark 2159:37581).
  static const Size frameSize = Size(_frameWidth, 716);

  /// Least space between the top bar and the must-see band.
  static const double clearance = ThemeConstants.spacing16;

  /// Phones: the design size, never larger.
  static const double designScale = 1;

  /// Tablets: up to the width of the content column.
  static const double tabletMaxScale = ThemeConstants.maxContentWidth / _frameWidth;

  /// Smallest scale; a slot too short for it makes the panel scroll.
  static const double minScale = 0.8;

  /// Height of a slot that holds the band from [mustSeeTop] down at
  /// [minScale] under [topInset].
  static double minSlotHeight({required double mustSeeTop, required double topInset}) =>
      topInset + clearance + (frameSize.height - mustSeeTop) * minScale;

  /// Frame pixels → slot pixels.
  final double scale;

  /// Where the frame lands in the slot. Centred horizontally, so its left
  /// offset is the same measured from either edge.
  final Rect frameRect;
}

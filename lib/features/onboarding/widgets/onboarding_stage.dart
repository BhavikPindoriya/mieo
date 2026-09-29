import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../core/constants/theme_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ONBOARDING STAGE
//
// The Onboarding scene (pedestals, clouds, Mieo) is one picture laid out in
// the coordinates of its Figma "Body" frame, 375 × 593. OnboardingStage fits
// that frame into the scene's slot, the part of the sky panel under the intro
// down to the panel's bottom edge, with one uniform scale:
//
//   • Bottom-anchored and centred like the Figma frame, so on the 375 × 812
//     reference the mapping is the identity and every layer lands on its Figma
//     pixel. Taller screens show more sky between the intro and Mieo.
//   • The must-see band, from Mieo's ear tips down to just below the pedestal
//     he stands on, stays [introClearance] below the intro. On a short slot
//     the frame first moves down (the columns run further past the bottom
//     edge), then shrinks, never below [minScale].
//   • Phones keep the design size at most; tablets may grow the frame to the
//     width of the content column (ThemeConstants.maxContentWidth).
//
// [minSlotHeight] fits the band at [minScale]: the panel scrolls rather than
// give the scene less room.
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class OnboardingStage {
  const OnboardingStage._({required this.scale, required this.frameRect});

  /// Fits the frame into [slot]. [maxScale] is [designScale] on phones and
  /// [tabletMaxScale] on tablets.
  factory OnboardingStage.fit(Size slot, {required double maxScale}) {
    final fitScale = (slot.height - introClearance) / (mustSeeBottom - mustSeeTop);
    final scale = math.max(minScale, math.min(fitScale, maxScale));
    final anchored = Alignment.bottomCenter.inscribe(frameSize * scale, Offset.zero & slot);
    final lowerBy = math.max(0.0, introClearance - (anchored.top + mustSeeTop * scale));
    return OnboardingStage._(scale: scale, frameRect: anchored.translate(0, lowerBy));
  }

  static const double _frameWidth = 375;

  /// Figma frame "Body" (Light 31:139 / Dark 2159:12448).
  static const Size frameSize = Size(_frameWidth, 593);

  /// Frame y of Mieo's ear tips: the top of the must-see band.
  static const double mustSeeTop = 214.542;

  /// Frame y of the bottom of the must-see band: the rim under the "Aa"
  /// pedestal's top (its drop shadow ends at 508.845) and 16 of the column
  /// below it.
  static const double mustSeeBottom = 508.845 + ThemeConstants.spacing16;

  /// Least space between the intro and Mieo's ears.
  static const double introClearance = ThemeConstants.spacing24;

  /// Phones: the design size, never larger.
  static const double designScale = 1;

  /// Tablets: up to the width of the content column.
  static const double tabletMaxScale = ThemeConstants.maxContentWidth / _frameWidth;

  /// Smallest scale; a slot too short for it makes the panel scroll.
  static const double minScale = 0.8;

  /// Height of a slot that holds the must-see band at [minScale].
  static const double minSlotHeight = introClearance + (mustSeeBottom - mustSeeTop) * minScale;

  /// Frame pixels → slot pixels.
  final double scale;

  /// Where the frame lands in the slot. Centred horizontally, so its left
  /// offset is the same measured from either edge.
  final Rect frameRect;
}

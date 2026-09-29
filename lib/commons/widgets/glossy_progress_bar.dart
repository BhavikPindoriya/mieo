import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/constants/theme_constants.dart';
import '../../core/localization/lang_keys.dart';
import '../../core/theme/colors.dart';
import '../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GLOSSY PROGRESS BAR
//
// Figma "Progress Bar" (2016:14397, the New Account Progress top bar; also
// the lesson top bar, streak goal and language tiles): a 26-high pill that
// fills from the start.
//
//   • Track — Icons/On Surface/Nuturel inside a 1px Stroke/Dim/primary
//     outline, on a hard shadow 2 below in Shadow/Primary/Lighter.
//   • Fill  — Icons/primary, with a white 25% inner shadow along its bottom
//     and end edges and two white 30% glossy stripes (Icons/On Surface/
//     primary, tilted 36.41°) near its start, both clipped to the fill.
//
// The fill grows from [GlossyProgressBar.from] to [GlossyProgressBar.value]
// when it appears (a step forward), and animates to any new value. It mirrors
// in RTL, stripes included, so they stay near the start of the fill.
// ─────────────────────────────────────────────────────────────────────────────
class GlossyProgressBar extends StatelessWidget {
  const GlossyProgressBar({super.key, required this.value, this.from});

  /// Height of the pill.
  static const double height = 26;

  /// How much is done, from 0 to 1.
  final double value;

  /// Where the fill starts growing from when the bar appears; null shows
  /// [value] straight away.
  final double? from;

  /// Width of the outline, which the shadow spreads by to match.
  static const double _outlineWidth = 1;
  static const double _percent = 100;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      value: LangKeys.progressPercent.trParams({'percent': '${(value * _percent).round()}'}),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.icon.onNeutral,
          borderRadius: _radius,
          // Border.all's width is the 1px outline.
          border: Border.all(color: colors.stroke.dimPrimary, strokeAlign: BorderSide.strokeAlignOutside),
          boxShadow: [
            BoxShadow(color: colors.shadow.primaryLighter, offset: _shadowOffset, spreadRadius: _outlineWidth),
          ],
        ),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: from ?? value, end: value),
            duration: AnimationConstants.durationSlow,
            curve: AnimationConstants.curveStandard,
            builder: (context, shown, _) => CustomPaint(
              painter: _FillPainter(
                value: shown,
                fill: colors.icon.primary,
                gloss: colors.icon.onPrimary,
                textDirection: Directionality.of(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const BorderRadius _radius = BorderRadius.all(Radius.circular(GlossyProgressBar.height / 2));

/// The track's hard shadow, straight down.
const Offset _shadowOffset = Offset(0, ThemeConstants.hardShadowOffsetSm);

// ── Figma geometry of the fill ──
/// Inner shadow: raw white, cast from (-3, -4) with a spread of -1, so it
/// lines the fill's bottom and end edges.
const double _shadeDx = -3;
const double _shadeDy = -4;
const double _shadeSpread = -1;
const double _shadeOpacity = 0.25;

/// The glossy stripes: rectangles turned 36.41° clockwise around their own
/// top-left corner, placed in the bar's coordinates (Figma 2016:14400 and
/// 2016:14401).
const double _stripeAngle = 36.41 * math.pi / 180;
const Rect _stripeThin = Rect.fromLTWH(29.523, -14.218, 4, 56.48);
const Rect _stripeWide = Rect.fromLTWH(34.873, -9.501, 10.608, 52.678);
const double _stripeOpacity = 0.3;

/// Paints the fill, [value] of the way along, with its shade and stripes.
class _FillPainter extends CustomPainter {
  const _FillPainter({required this.value, required this.fill, required this.gloss, required this.textDirection});

  final double value;
  final Color fill;
  final Color gloss;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width * value.clamp(0, 1);
    if (width <= 0) return;
    canvas.save();
    // In RTL the fill grows from the right edge: mirror the whole drawing.
    final mirrored = textDirection == TextDirection.rtl; // check-rules: ignore — painters mirror in RTL
    if (mirrored) {
      canvas
        ..translate(size.width, 0)
        ..scale(-1, 1);
    }
    final shape = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width, size.height), _radius.topLeft);
    final path = Path()..addRRect(shape);
    final paint = Paint()..color = fill;
    canvas
      ..clipRRect(shape)
      ..drawRRect(shape, paint);

    // ── Inner shadow ──
    final light = Path()..addRRect(shape.inflate(-_shadeSpread).shift(const Offset(_shadeDx, _shadeDy)));
    canvas.drawPath(
      Path.combine(PathOperation.difference, path, light),
      paint..color = AppColors.neutral50.withValues(alpha: _shadeOpacity),
    );

    // ── Glossy stripes ──
    paint.color = gloss.withValues(alpha: _stripeOpacity);
    for (final stripe in [_stripeThin, _stripeWide]) {
      canvas
        ..save()
        ..translate(stripe.left, stripe.top)
        ..rotate(_stripeAngle)
        ..drawRect(Offset.zero & stripe.size, paint)
        ..restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_FillPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.fill != fill ||
      oldDelegate.gloss != gloss ||
      oldDelegate.textDirection != textDirection;
}

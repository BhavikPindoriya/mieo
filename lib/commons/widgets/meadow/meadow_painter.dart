import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../../core/theme/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MEADOW PAINTER
//
// The ground Mieo stands on in the New Account Progress scenes ("Hi! I’m
// Mieo" 62:3826, "Ask you some Questions" 62:11907…): Figma "Ground" without
// the talk bubble and the mascot, in the coordinates of the scenes' "BOdy"
// frame (375 × 716). Painted in Figma's layer order:
//
//   1. Hills  — three large overlapping ovals whose tops show as rolling
//               hills at the bottom of the frame (they run far past it).
//   2. Shadow — the flat oval under Mieo's feet.
//   3. Trees  — two tall pines at the edges (a rounded triangle on a trunk)
//               and two small round-crowned trees, each over its own ground
//               shadow.
//
// Every fill is bound to a Shades/* variable (the same in both themes) except
// the lightest crown green, a raw #55D374, which equals Shades/Success/300.
// The scene is artwork: it doesn't mirror in RTL.
// ─────────────────────────────────────────────────────────────────────────────
class MeadowPainter extends CustomPainter {
  const MeadowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    void oval(Rect rect, Color color) => canvas.drawOval(rect, paint..color = color);
    void path(Path path, Color color) => canvas.drawPath(path, paint..color = color);

    // ── 1. Hills ──
    oval(const Rect.fromLTWH(-216, 604, 848, 880), AppColors.success600);
    oval(const Rect.fromLTWH(82, 628, 681, 681), AppColors.success700);
    oval(const Rect.fromLTWH(-394, 586, 848, 848), AppColors.success500);

    // ── 2. Shadow under Mieo ──
    oval(const Rect.fromLTWH(98, 676, 174, 21), AppColors.success600);

    // ── 3. Trees ──
    for (final pine in _pines) {
      canvas
        ..save()
        ..translate(pine.origin.dx, pine.origin.dy);
      oval(_Pine.shadow, pine.shadowColor);
      canvas.drawRect(_Pine.trunk, paint..color = AppColors.error950);
      path(_Pine.crown, AppColors.success300);
      canvas.restore();
    }
    for (final tree in _roundTrees) {
      oval(tree.shadow, tree.shadowColor);
      path(tree.trunk, AppColors.error950);
      oval(tree.crownBack, AppColors.success500);
      oval(tree.crownTop, AppColors.success400);
      oval(tree.crownFront, AppColors.success300);
    }
  }

  @override
  bool shouldRepaint(MeadowPainter oldDelegate) => false;
}

/// A pine: its shape in its own 66 × 110.55 box, and where that box sits.
@immutable
class _Pine {
  const _Pine(this.origin, this.shadowColor);

  final Offset origin;
  final Color shadowColor;

  static const Rect shadow = Rect.fromLTWH(8.8, 104.5, 50.6, 6.05);
  static const Rect trunk = Rect.fromLTWH(22, 31, 24, 77);

  /// A triangle with rounded corners (Figma "Polygon 7", radius 8).
  static final Path crown = Path()
    ..moveTo(25.99, 12.745)
    ..cubicTo(29.03, 7.219, 36.97, 7.219, 40.01, 12.745)
    ..lineTo(59.48, 48.145)
    ..cubicTo(62.412, 53.476, 58.555, 60, 52.47, 60)
    ..lineTo(13.53, 60)
    ..cubicTo(7.445, 60, 3.588, 53.476, 6.52, 48.145)
    ..lineTo(25.99, 12.745)
    ..close();
}

/// Figma "Group 40143" (left edge) and "Group 40146" (right edge): the
/// top-left corners of their boxes.
const double _leftPineX = -28;
const double _leftPineY = 506;
const double _rightPineX = 347;
const double _rightPineY = 567;
const List<_Pine> _pines = [
  _Pine(Offset(_leftPineX, _leftPineY), AppColors.success600),
  _Pine(Offset(_rightPineX, _rightPineY), AppColors.success800),
];

/// A small tree: a forked trunk under three overlapping round crowns, in the
/// frame's coordinates.
@immutable
class _RoundTree {
  const _RoundTree({
    required this.shadow,
    required this.shadowColor,
    required this.trunk,
    required this.crownBack,
    required this.crownTop,
    required this.crownFront,
  });

  final Rect shadow;
  final Color shadowColor;
  final Path trunk;
  final Rect crownBack;
  final Rect crownTop;
  final Rect crownFront;
}

/// Figma "Group 40144" (left) and "Group 40145" (right, smaller).
final List<_RoundTree> _roundTrees = [
  _RoundTree(
    shadow: const Rect.fromLTWH(45.582, 592.537, 20.597, 2.463),
    shadowColor: AppColors.success600,
    trunk: Path()
      ..moveTo(51.758, 569.533)
      ..cubicTo(51.476, 568.405, 53.02, 567.785, 53.597, 568.794)
      ..lineTo(55.053, 571.343)
      ..cubicTo(55.453, 572.043, 56.475, 572.006, 56.823, 571.278)
      ..lineTo(59.371, 565.951)
      ..cubicTo(59.842, 564.967, 61.323, 565.339, 61.273, 566.428)
      ..lineTo(60.044, 593.046)
      ..cubicTo(60.019, 593.58, 59.579, 594, 59.045, 594)
      ..lineTo(53.137, 594)
      ..cubicTo(52.534, 594, 52.068, 593.47, 52.146, 592.872)
      ..lineTo(53.976, 578.687)
      ..cubicTo(53.992, 578.563, 53.984, 578.438, 53.954, 578.317)
      ..lineTo(51.758, 569.533)
      ..close(),
    crownBack: const Rect.fromLTWH(41, 560, 14, 13),
    crownTop: const Rect.fromLTWH(46, 551, 13, 13),
    crownFront: const Rect.fromLTWH(53, 552, 18, 18),
  ),
  _RoundTree(
    shadow: const Rect.fromLTWH(313.332, 630.209, 14.98, 1.791),
    shadowColor: AppColors.success700,
    trunk: Path()
      ..moveTo(318.234, 615.118)
      ..cubicTo(317.963, 614.035, 319.446, 613.439, 320, 614.408)
      ..cubicTo(320.384, 615.081, 321.366, 615.045, 321.7, 614.346)
      ..lineTo(322.781, 612.087)
      ..cubicTo(323.251, 611.103, 324.732, 611.475, 324.682, 612.564)
      ..lineTo(323.862, 630.319)
      ..cubicTo(323.838, 630.853, 323.398, 631.273, 322.863, 631.273)
      ..lineTo(319.137, 631.273)
      ..cubicTo(318.534, 631.273, 318.068, 630.743, 318.146, 630.145)
      ..lineTo(319.43, 620.187)
      ..cubicTo(319.446, 620.064, 319.439, 619.938, 319.409, 619.817)
      ..lineTo(318.234, 615.118)
      ..close(),
    crownBack: const Rect.fromLTWH(310, 606.545, 10.182, 9.455),
    crownTop: const Rect.fromLTWH(313.636, 600, 9.455, 9.455),
    crownFront: const Rect.fromLTWH(318.727, 600.727, 13.091, 13.091),
  ),
];

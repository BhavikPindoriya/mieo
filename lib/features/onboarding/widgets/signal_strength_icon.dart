import 'package:flutter/widgets.dart';

import '../../../core/constants/animation_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SIGNAL STRENGTH ICON
//
// Figma "wifi 1" (53:1592) on the level question: a dot under two arcs, lit
// from the dot outwards to show how well the learner knows the language
// ([strength] 0 to 3 parts lit).
//
// Figma binds the parts to Shades primitives, the same in both themes:
//   on a picked tile — lit Shades/primary/700, unlit Shades/primary/400;
//   otherwise        — lit Shades/neutral/700, unlit Shades/neutral/200.
// Picking the tile cross-fades between the two. The glyph is symmetric, so it
// looks the same in RTL.
// ─────────────────────────────────────────────────────────────────────────────
class SignalStrengthIcon extends StatelessWidget {
  const SignalStrengthIcon({super.key, required this.strength, required this.selected});

  /// Parts lit, from the dot: 0 (none) to 3 (all).
  final int strength;

  /// Whether the tile it sits on is picked.
  final bool selected;

  static const double _unpicked = 0;
  static const double _picked = 1;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: selected ? _picked : _unpicked),
      duration: AnimationConstants.durationFast,
      curve: AnimationConstants.curveStandard,
      builder: (context, picked, _) => CustomPaint(
        size: const Size.square(ThemeConstants.iconSize24),
        painter: _SignalPainter(
          strength: strength,
          lit: Color.lerp(AppColors.neutral700, AppColors.primary700, picked)!,
          unlit: Color.lerp(AppColors.neutral200, AppColors.primary400, picked)!,
        ),
      ),
    );
  }
}

/// Paints the dot and the two arcs in the 24 × 24 Figma frame, the first
/// [strength] of them (from the dot) in [lit], the rest in [unlit].
class _SignalPainter extends CustomPainter {
  const _SignalPainter({required this.strength, required this.lit, required this.unlit});

  final int strength;
  final Color lit;
  final Color unlit;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final (index, part) in _parts.indexed) {
      canvas.drawPath(part, paint..color = index < strength ? lit : unlit);
    }
  }

  @override
  bool shouldRepaint(_SignalPainter oldDelegate) =>
      oldDelegate.strength != strength || oldDelegate.lit != lit || oldDelegate.unlit != unlit;
}

// ── Figma geometry, in the 24 × 24 frame ──
/// The dot: a 4 × 4 circle at (10, 16).
const double _dotX = 12;
const double _dotY = 18;
const double _dotRadius = 2;

/// The parts from the dot outwards: "Ellipse 543", then the inner and outer
/// "Vector" arcs.
final List<Path> _parts = [
  Path()..addOval(Rect.fromCircle(center: const Offset(_dotX, _dotY), radius: _dotRadius)),
  Path()
    ..moveTo(7.425, 15.803)
    ..cubicTo(6.839, 16.389, 5.889, 16.389, 5.304, 15.803)
    ..cubicTo(4.718, 15.218, 4.718, 14.268, 5.304, 13.682)
    ..lineTo(6, 12.985)
    ..cubicTo(7.592, 11.394, 9.75, 10.5, 12, 10.5)
    ..cubicTo(14.251, 10.5, 16.409, 11.394, 18, 12.985)
    ..lineTo(18.697, 13.682)
    ..cubicTo(19.283, 14.268, 19.283, 15.218, 18.697, 15.803)
    ..cubicTo(18.111, 16.389, 17.162, 16.389, 16.576, 15.803)
    ..lineTo(15.879, 15.107)
    ..cubicTo(14.85, 14.078, 13.455, 13.5, 12, 13.5)
    ..cubicTo(10.546, 13.5, 9.15, 14.078, 8.122, 15.107)
    ..lineTo(7.425, 15.803)
    ..close(),
  Path()
    ..moveTo(1.061, 11.561)
    ..cubicTo(0.475, 10.975, 0.475, 10.025, 1.061, 9.439)
    ..lineTo(1.757, 8.743)
    ..cubicTo(4.474, 6.026, 8.158, 4.5, 12, 4.5)
    ..cubicTo(15.842, 4.5, 19.526, 6.026, 22.243, 8.743)
    ..lineTo(22.939, 9.439)
    ..cubicTo(23.525, 10.025, 23.525, 10.975, 22.939, 11.561)
    ..cubicTo(22.354, 12.146, 21.404, 12.146, 20.818, 11.561)
    ..lineTo(20.121, 10.864)
    ..cubicTo(17.967, 8.71, 15.046, 7.5, 12, 7.5)
    ..cubicTo(8.954, 7.5, 6.033, 8.71, 3.879, 10.864)
    ..lineTo(3.182, 11.561)
    ..cubicTo(2.596, 12.146, 1.646, 12.146, 1.061, 11.561)
    ..close(),
];

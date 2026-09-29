import 'package:flutter/widgets.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SHIELD CHECK ICON
//
// The mark on the "100% Kids Safe" tag: Figma "Icon" (53:1392), a 16 × 16
// frame holding a shield in Surface/Primary with a check mark in front of it
// in Icons/On Surface/primary. Drawn from the Figma vectors so both parts
// follow the theme; scales to [size].
// ─────────────────────────────────────────────────────────────────────────────
class ShieldCheckIcon extends StatelessWidget {
  const ShieldCheckIcon({super.key, this.size = ThemeConstants.iconSize16});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _ShieldCheckPainter(shield: colors.surface.primary, check: colors.icon.onPrimary),
      ),
    );
  }
}

class _ShieldCheckPainter extends CustomPainter {
  const _ShieldCheckPainter({required this.shield, required this.check});

  final Color shield;
  final Color check;

  /// Side of the Figma icon frame the paths are drawn in.
  static const double _frameSize = ThemeConstants.iconSize16;

  static final Path _shield = Path()
    ..moveTo(2.252, 3.388)
    ..cubicTo(2, 3.747, 2, 4.812, 2, 6.944)
    ..lineTo(2, 7.994)
    ..cubicTo(2, 11.753, 4.826, 13.577, 6.599, 14.351)
    ..cubicTo(7.08, 14.561, 7.32, 14.666, 8, 14.666)
    ..cubicTo(8.68, 14.666, 8.92, 14.561, 9.401, 14.351)
    ..cubicTo(11.174, 13.577, 14, 11.753, 14, 7.994)
    ..lineTo(14, 6.944)
    ..cubicTo(14, 4.812, 14, 3.747, 13.748, 3.388)
    ..cubicTo(13.497, 3.029, 12.494, 2.686, 10.49, 2)
    ..lineTo(10.108, 1.869)
    ..cubicTo(9.063, 1.512, 8.541, 1.333, 8, 1.333)
    ..cubicTo(7.459, 1.333, 6.937, 1.512, 5.892, 1.869)
    ..lineTo(5.51, 2)
    ..cubicTo(3.506, 2.686, 2.503, 3.029, 2.252, 3.388)
    ..close();

  static final Path _check = Path()
    ..moveTo(10.039, 7)
    ..cubicTo(10.223, 6.794, 10.205, 6.478, 9.999, 6.294)
    ..cubicTo(9.793, 6.11, 9.477, 6.128, 9.293, 6.334)
    ..lineTo(7.285, 8.583)
    ..lineTo(6.706, 7.934)
    ..cubicTo(6.522, 7.728, 6.206, 7.71, 6, 7.894)
    ..cubicTo(5.794, 8.078, 5.776, 8.394, 5.96, 8.6)
    ..lineTo(6.912, 9.667)
    ..cubicTo(7.007, 9.773, 7.143, 9.834, 7.285, 9.834)
    ..cubicTo(7.428, 9.834, 7.563, 9.773, 7.658, 9.667)
    ..lineTo(10.039, 7)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas
      ..scale(size.width / _frameSize)
      ..drawPath(_shield, paint..color = shield)
      ..drawPath(_check, paint..color = check);
  }

  @override
  bool shouldRepaint(_ShieldCheckPainter oldDelegate) => oldDelegate.shield != shield || oldDelegate.check != check;
}

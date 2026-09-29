import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';
import '../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP TOOLTIP BUBBLE
//
// Figma "Tool Tip" (440:7620): a short cheer over what it points at ("Nice
// 👍" above the chosen daily goal). A Surface/Primary pill with the label in
// label/medium, Texts/On Surface/primary, between 12 side and 8 top/bottom
// paddings, and a 20 × 7 tail under its middle pointing down. The tail hangs
// below the pill without adding to its layout size, like the Figma instance;
// it is centred, so the bubble looks the same in RTL.
// ─────────────────────────────────────────────────────────────────────────────
class AppTooltipBubble extends StatelessWidget {
  const AppTooltipBubble(this.label, {super.key});

  /// How far the tail reaches below the pill.
  static const double tailDepth = 7;

  final String label;

  static const EdgeInsetsDirectional _padding = EdgeInsetsDirectional.symmetric(
    horizontal: ThemeConstants.spacing12,
    vertical: ThemeConstants.spacing8,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CustomPaint(
      painter: _TooltipPainter(color: colors.surface.primary),
      child: Padding(
        padding: _padding,
        child: Text(
          label,
          maxLines: 1,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.text.onPrimary),
        ),
      ),
    );
  }
}

/// Half the width of the tail's base.
const double _tailHalfWidth = 10;

/// Paints the pill and the tail under it.
class _TooltipPainter extends CustomPainter {
  const _TooltipPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = size.width / 2;
    canvas
      ..drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(ThemeConstants.radiusPill)), paint)
      ..drawPath(
        Path()
          ..moveTo(center - _tailHalfWidth, size.height)
          ..lineTo(center + _tailHalfWidth, size.height)
          ..lineTo(center, size.height + AppTooltipBubble.tailDepth)
          ..close(),
        paint,
      );
  }

  @override
  bool shouldRepaint(_TooltipPainter oldDelegate) => oldDelegate.color != color;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/colors.dart';
import '../../utils/extensions/context_extensions.dart';
import 'app_pressable.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP BUTTON
//
// Figma "Button" (53:1086): a full-width, 48-high button with 16-radius
// corners, a hard shadow 4 below and a one-line label (title/medium) centred
// between 24 side paddings. One look per variant, and a disabled look for any
// variant whose onPressed is null:
//
//   filled   — Surface/Primary with two glossy white stripes near the start,
//              shadow Shadow/Primary/Darker, label Texts/On Surface/primary.
//   outlined — Surface/Background Nuturel inside a Stroke/Nuturel outline,
//              shadow Shadow/Nutural/Full, label Texts/Heading.
//   shaded   — Surface/Dim/primary inside a Stroke/primary outline, shadow
//              Shadow/Primary/Full, label Texts/primary.
//   disabled — (Figma "Dissabled") Surface/Background Nuturel inside a
//              Stroke/Extra Dim/Nuturel outline, shadow Shadow/Nutural/Extra
//              light, label Shades/neutral/300.
//
// Pressed, it sinks into its shadow (AppPressable): Mieo's press feedback.
// ─────────────────────────────────────────────────────────────────────────────

/// The Figma Button variants. Any of them shows disabled when
/// `AppButton.onPressed` is null.
enum AppButtonVariant {
  /// Main action: primary fill with glossy stripes.
  filled,

  /// Secondary action: neutral fill inside a dark outline.
  outlined,

  /// Softer primary action: dim primary fill inside a primary outline.
  shaded,
}

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label, required this.onPressed, this.variant = AppButtonVariant.filled});

  final String label;

  /// Called when the button is tapped; null disables the button.
  final VoidCallback? onPressed;

  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final style = _ButtonStyle.of(context.colors, variant, enabled: onPressed != null);
    final outline = style.outline;
    return AppPressable(
      onPressed: onPressed,
      style: PressableStyle(
        color: style.fill,
        shadowColor: style.shadow,
        border: outline == null ? null : AppBorders.outline(outline),
        borderRadius: _borderRadius,
      ),
      child: _ButtonFace(label: label, style: style),
    );
  }
}

const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(ThemeConstants.radius16));

/// What sits inside the box: the gloss (filled only) and the label.
class _ButtonFace extends StatelessWidget {
  const _ButtonFace({required this.label, required this.style});

  final String label;
  final _ButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ThemeConstants.buttonHeight,
      child: ClipRRect(
        borderRadius: _borderRadius,
        clipBehavior: style.glossy ? Clip.antiAlias : Clip.none,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (style.glossy) const CustomPaint(painter: _GlossPainter()),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: ThemeConstants.spacing24),
              child: Center(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: style.label),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The colours of one variant and state.
@immutable
class _ButtonStyle {
  const _ButtonStyle({
    required this.fill,
    required this.shadow,
    required this.label,
    this.outline,
    this.glossy = false,
  });

  factory _ButtonStyle.of(AppColorTokens colors, AppButtonVariant variant, {required bool enabled}) {
    if (!enabled) {
      return _ButtonStyle(
        fill: colors.surface.backgroundNeutral,
        outline: colors.stroke.extraDimNeutral,
        shadow: colors.shadow.neutralExtraLight,
        label: AppColors.neutral300,
      );
    }
    return switch (variant) {
      AppButtonVariant.filled => _ButtonStyle(
        fill: colors.surface.primary,
        shadow: colors.shadow.primaryDarker,
        label: colors.text.onPrimary,
        glossy: true,
      ),
      AppButtonVariant.outlined => _ButtonStyle(
        fill: colors.surface.backgroundNeutral,
        outline: colors.stroke.neutral,
        shadow: colors.shadow.neutralFull,
        label: colors.text.heading,
      ),
      // Surface/Dim/primary is translucent in dark mode. Figma never draws a
      // drop shadow through its shape, so the fill is flattened onto the page
      // colour and the shadow behind stays hidden.
      AppButtonVariant.shaded => _ButtonStyle(
        fill: Color.alphaBlend(colors.surface.dimPrimary, colors.surface.body),
        outline: colors.stroke.primary,
        shadow: colors.shadow.primaryFull,
        label: colors.text.primary,
      ),
    };
  }

  final Color fill;

  /// Outline colour; null for an unoutlined button.
  final Color? outline;

  final Color shadow;
  final Color label;

  /// Whether the gloss stripes are drawn.
  final bool glossy;
}

/// The filled button's gloss (Figma 62:3890 and 62:3941): two white stripes,
/// 88.134 long and tilted 119.15°, crossing the box near its start and
/// clipped by its corners. A light reflection, so like artwork it keeps its
/// place in RTL.
class _GlossPainter extends CustomPainter {
  const _GlossPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final stripe in _glossStripes) {
      canvas
        ..save()
        ..translate(stripe.dx, stripe.dy)
        ..rotate(_glossAngle)
        ..drawRect(
          Rect.fromCenter(center: Offset.zero, width: _glossLength, height: stripe.width),
          paint..color = AppColors.neutral50.withValues(alpha: stripe.opacity),
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_GlossPainter oldDelegate) => false;
}

/// One gloss stripe: its centre in the button box, width and opacity.
@immutable
class _GlossStripe {
  const _GlossStripe(this.dx, this.dy, this.width, this.opacity);

  final double dx;
  final double dy;
  final double width;
  final double opacity;
}

const List<_GlossStripe> _glossStripes = [
  _GlossStripe(31.844, 20.043, 14.606, 0.3),
  _GlossStripe(46.318, 23.666, 5.34, 0.2),
];

const double _glossLength = 88.134;

/// 119.15°, clockwise from the x axis.
const double _glossAngle = 119.15 * math.pi / 180;

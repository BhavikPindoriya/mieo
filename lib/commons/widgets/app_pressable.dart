import 'package:flutter/material.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/constants/theme_constants.dart';
import '../../core/theme/app_decorations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP PRESSABLE
//
// The 3D press every tappable Mieo surface shares — buttons, icon buttons,
// the social sign-in buttons. The surface is a box (PressableStyle: fill,
// border, corners) standing on a solid hard shadow [PressableStyle.depth]
// below it, in a Figma `Shadow/*` colour. A border that reaches outside the
// box widens the shadow by as much, since Figma casts the shadow from the
// whole layer, outline included.
//
// While held down the box sinks into its shadow: it moves down by the depth
// as the shadow shrinks to nothing, and rises again on release. With a null
// onPressed it's disabled: no sink, no pointer cursor, and screen readers
// hear it as disabled (the caller picks disabled colours).
//
// Local state: whether a pointer is holding it down.
// ─────────────────────────────────────────────────────────────────────────────

/// How an [AppPressable] looks at rest.
@immutable
class PressableStyle {
  const PressableStyle({
    required this.color,
    required this.shadowColor,
    required this.borderRadius,
    this.border,
    this.depth = ThemeConstants.hardShadowOffset,
  });

  /// Fill of the box.
  final Color color;

  /// The hard shadow's colour, a Figma `Shadow/*` token.
  final Color shadowColor;

  final BorderRadiusGeometry borderRadius;

  /// Outline, e.g. [AppBorders.outline]; null for none.
  final BoxBorder? border;

  /// How far below the box the shadow shows, and how far the box sinks when
  /// pressed.
  final double depth;
}

class AppPressable extends StatefulWidget {
  const AppPressable({
    super.key,
    required this.style,
    required this.onPressed,
    required this.child,
    this.semanticLabel,
  });

  final PressableStyle style;

  /// Called on tap; null disables it.
  final VoidCallback? onPressed;

  /// The content, laid out inside the box (the box takes its size).
  final Widget child;

  /// What screen readers announce, for content without text (icon buttons).
  final String? semanticLabel;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool pressed) {
    if (pressed != _pressed) {
      setState(() => _pressed = pressed);
    }
  }

  @override
  void didUpdateWidget(AppPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _pressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          onTapDown: _enabled ? (_) => _setPressed(true) : null,
          onTapUp: _enabled ? (_) => _setPressed(false) : null,
          onTapCancel: _enabled ? () => _setPressed(false) : null,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: _pressed ? 1 : 0),
            duration: AnimationConstants.durationFast,
            curve: AnimationConstants.curveStandard,
            builder: (context, press, child) => _PressableBox(style: widget.style, press: press, child: child),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// The box on its shadow, [press] of the way into it (0 at rest, 1 sunk).
class _PressableBox extends StatelessWidget {
  const _PressableBox({required this.style, required this.press, required this.child});

  final PressableStyle style;
  final double press;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final sink = style.depth * press;
    final border = style.border;
    return Transform.translate(
      offset: Offset(0, sink),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.color,
          border: border,
          borderRadius: style.borderRadius,
          boxShadow: AppShadows.hard(
            style.shadowColor,
            offset: style.depth - sink,
            bordered: border != null && border.top.strokeOutset > 0,
          ),
        ),
        child: child,
      ),
    );
  }
}

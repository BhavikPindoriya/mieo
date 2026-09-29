import 'dart:math' as math;

import 'package:flutter/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SPLASH STAGE
//
// The splash is one composed scene (sky, title, clouds, the Rive mascot) laid
// out in the coordinates of its Figma frame, 375 × 812. SplashStage maps that
// frame onto the screen with a single uniform scale and a centring offset:
//
//   • The frame's centre sits on the screen's centre. On the 375 × 812
//     reference device the mapping is the identity, so every layer lands on its
//     Figma pixel; taller or wider screens show more sky around the frame.
//   • Phones keep the design size (scale 1). The scale drops below 1 only when
//     the character frame (Figma "Mieo Charachter", which also holds the title)
//     would not fit inside the screen width, or between the status bar and the
//     footer: small phones, landscape.
//   • Tablets may scale the frame up until it fills the screen height, never
//     past the frame's own "contain" fit, so the scene keeps its proportions.
//
// Layers are placed in frame coordinates inside a [frameSize] box that sits at
// [frameRect] and is scaled by a FittedBox. [viewport] is the whole screen in
// frame coordinates, for layers that must reach the screen edges (the mascot
// flies in from off-screen).
// ─────────────────────────────────────────────────────────────────────────────
@immutable
class SplashStage {
  const SplashStage._({required this.screen, required this.scale, required this.frameRect});

  /// Fits the frame to [screen]. [topInset] is the status bar height and
  /// [bottomInset] the space the footer takes at the bottom edge; with
  /// [allowUpscale] (tablets) the frame may grow past its design size.
  factory SplashStage.fit({
    required Size screen,
    required double topInset,
    required double bottomInset,
    required bool allowUpscale,
  }) {
    final screenCenter = screen.center(Offset.zero);
    final frameCenter = frameSize.center(Offset.zero);

    // Largest scale that keeps the character frame inside the screen width and
    // between the status bar and the footer, with the two centres aligned.
    final fit = [
      screenCenter.dx / (frameCenter.dx - content.left),
      (screen.width - screenCenter.dx) / (content.right - frameCenter.dx),
      (screenCenter.dy - topInset) / (frameCenter.dy - content.top),
      (screen.height - bottomInset - screenCenter.dy) / (content.bottom - frameCenter.dy),
    ].reduce(math.min);

    final maxScale = allowUpscale
        ? math.max(_designScale, math.min(screen.width / frameSize.width, screen.height / frameSize.height))
        : _designScale;
    final scale = math.max(_minScale, math.min(fit, maxScale));
    final size = frameSize * scale;
    final origin = screenCenter - size.center(Offset.zero);
    return SplashStage._(screen: screen, scale: scale, frameRect: origin & size);
  }

  /// Figma frame "Splash" (Light 22:5 / Dark 2159:12106).
  static const Size frameSize = Size(375, 812);

  /// Figma "Mieo Charachter" (25:1392): the mascot's frame, which also contains
  /// the title. The part of the scene that must always be visible.
  static const Rect content = Rect.fromLTWH(14, 212, 338.818, 372.263);

  /// Frame y where the frame fill's sky gradient ends (812 / 2.36, from the
  /// fill's gradient transform); below it the gradient holds its last colour.
  static const double skyGradientEnd = 344;

  static const double _designScale = 1;

  /// Floor for the scale, so a degenerate screen size can't collapse the scene.
  static const double _minScale = 0.25;

  /// The screen the stage was fitted to.
  final Size screen;

  /// Frame pixels → screen pixels.
  final double scale;

  /// Where the frame lands on the screen. Centred horizontally, so its left
  /// offset is the same measured from either edge.
  final Rect frameRect;

  /// The whole screen in frame coordinates (centred on the frame, like
  /// [frameRect]).
  Rect get viewport =>
      Rect.fromLTWH(-frameRect.left / scale, -frameRect.top / scale, screen.width / scale, screen.height / scale);

  /// Screen y of the frame y [frameY].
  double toScreenY(double frameY) => frameRect.top + frameY * scale;
}

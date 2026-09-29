import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/constants/theme_constants.dart';
import '../../utils/extensions/context_extensions.dart';
import 'highlighted_text.dart';
import 'typewriter/typewriter_text.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SPEECH BUBBLE
//
// Figma "Talk Bubble" (53:1337): what Mieo or a story character says. A
// rounded box (radius 16) in Surface/Background Nuturel with a 1px
// Stroke/Dim/neutral outline inside its edge, the line in body/large between
// 16 side and 12 top/bottom paddings, and a tail pointing at the speaker.
// Accent words are marked `**…**` in the translation (HighlightedText,
// Texts/primary; `__…__` underlines them too).
//
// Two faces ([SpeechBubbleFace]), as in Figma:
//   • bottom — the tail under the middle of the box pointing down, the line
//     centred (the speaker stands below);
//   • start  — Figma face Left: the tail halfway down the box's start edge
//     pointing back, the line aligned to the start (the speaker stands
//     beside it). The tail follows the start edge, so it points right in RTL.
//
// Two widths, as in Figma:
//   • one line (no width) — 129 wide, like the Figma component, and widening
//     with a longer line (another language, larger text);
//   • a set width — the box keeps it and the text wraps inside, like a Figma
//     instance whose text layer has a fixed width.
// The tail reaches [SpeechBubble.tailDepth] out of the box without adding to
// its layout size, like the Figma instance. [SpeechBubble.boxHeight] measures
// the box before layout, for a page that keeps a bubble growing upwards clear
// of its top bar.
//
// Entrances ([SpeechBubbleEntrance]):
//   • none   — the bubble is simply there;
//   • typing — the speaker is talking: after
//     AnimationConstants.bubbleEntranceDelay (the page slides in first) the
//     bubble pops out of its tail (scale from bubblePopScale with a little
//     overshoot, fading in), and as soon as it is open the words type
//     themselves out (TypewriterText). The box keeps its final size
//     throughout, so nothing around it moves.
//
// State: the pop's AnimationController, made only for the typing entrance; a
// bubble switched to it later plays it from the start.
// ─────────────────────────────────────────────────────────────────────────────

/// Where a SpeechBubble's tail points: Figma Talk Bubble faces.
enum SpeechBubbleFace {
  /// Down from the middle of the bottom edge.
  bottom,

  /// Back from the middle of the start edge (Figma face Left).
  start,
}

/// How a SpeechBubble appears.
enum SpeechBubbleEntrance {
  /// Shown as it is.
  none,

  /// Pops up, then types its words out.
  typing,
}

class SpeechBubble extends StatefulWidget {
  const SpeechBubble(
    this.text, {
    super.key,
    this.width,
    this.face = SpeechBubbleFace.bottom,
    this.entrance = SpeechBubbleEntrance.none,
  });

  /// The line, with any accent words between HighlightedText markers.
  final String text;

  /// The box's width when the text wraps inside it; null for a one-line
  /// bubble that widens with its line.
  final double? width;

  final SpeechBubbleFace face;

  final SpeechBubbleEntrance entrance;

  /// How far the tail's tip reaches out of the box.
  static const double tailDepth = 10.5;

  /// Width of the one-line Figma component; a longer line widens the box.
  static const double minWidth = 129;

  /// Space between the box's edge and the text.
  static const EdgeInsetsDirectional _padding = EdgeInsetsDirectional.symmetric(
    horizontal: ThemeConstants.spacing16,
    vertical: ThemeConstants.spacing12,
  );

  /// The box's height (the tail hangs below it) when the bubble is laid out
  /// no wider than [maxWidth] in [context]: the text measured the way
  /// build() lays it out (HighlightedText.textPainter).
  double boxHeight(BuildContext context, {required double maxWidth}) {
    final painter = HighlightedText(
      text,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: _textAlign,
    ).textPainter(context)..layout(maxWidth: (width ?? maxWidth) - _padding.horizontal);
    final height = painter.height + _padding.vertical;
    painter.dispose();
    return height;
  }

  /// Centred over a speaker below, from the start beside one.
  TextAlign get _textAlign => switch (face) {
    SpeechBubbleFace.bottom => TextAlign.center,
    SpeechBubbleFace.start => TextAlign.start,
  };

  @override
  State<SpeechBubble> createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<SpeechBubble> with TickerProviderStateMixin {
  /// The pop, from the start of the entrance delay to full size.
  AnimationController? _pop;

  @override
  void initState() {
    super.initState();
    _startEntrance();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _pop?.value = 1;
  }

  @override
  void didUpdateWidget(SpeechBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entrance == widget.entrance) return;
    _startEntrance();
    if (MediaQuery.disableAnimationsOf(context)) _pop?.value = 1;
  }

  /// Plays the entrance from its start: a new pop for the typing entrance
  /// (its TypewriterText mounts in the same frame, so the two stay in step),
  /// none otherwise.
  void _startEntrance() {
    _pop?.dispose();
    _pop = widget.entrance == SpeechBubbleEntrance.typing
        ? (AnimationController(vsync: this, duration: _popEnd)..forward())
        : null;
  }

  @override
  void dispose() {
    _pop?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = Theme.of(context).textTheme.bodyLarge;
    final textAlign = widget._textAlign;
    final bubble = CustomPaint(
      painter: _BubblePainter(
        fill: colors.surface.backgroundNeutral,
        outline: colors.stroke.dimNeutral,
        face: widget.face,
        textDirection: Directionality.of(context),
      ),
      child: ConstrainedBox(
        constraints: widget.width == null
            ? const BoxConstraints(minWidth: SpeechBubble.minWidth)
            : BoxConstraints.tightFor(width: widget.width),
        child: Padding(
          padding: SpeechBubble._padding,
          child: switch (widget.entrance) {
            SpeechBubbleEntrance.none => HighlightedText(widget.text, textAlign: textAlign, style: style),
            SpeechBubbleEntrance.typing => TypewriterText(
              widget.text,
              textAlign: textAlign,
              style: style,
              delay: _popEnd,
            ),
          },
        ),
      ),
    );
    final pop = _pop;
    if (pop == null) return bubble;
    return _PopIn(
      animation: pop,
      origin: switch (widget.face) {
        SpeechBubbleFace.bottom => AlignmentDirectional.bottomCenter,
        SpeechBubbleFace.start => AlignmentDirectional.centerStart,
      },
      child: bubble,
    );
  }
}

/// The bubble popping out of its tail: waits out the entrance delay, then
/// grows from AnimationConstants.bubblePopScale around [origin] (where the
/// tail opens), fading in over the first half.
class _PopIn extends StatelessWidget {
  const _PopIn({required this.animation, required this.origin, required this.child});

  final Animation<double> animation;
  final AlignmentGeometry origin;
  final Widget child;

  static final double _start = AnimationConstants.bubbleEntranceDelay.inMicroseconds / _popEnd.inMicroseconds;
  static final double _faded = _start + (1 - _start) * _fadeShare;

  @override
  Widget build(BuildContext context) {
    // drive() maps the controller's value through the curves without adding
    // listeners to it, so rebuilding (a theme cross-fade) leaves nothing behind.
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Interval(_start, _faded))),
      // The words stay readable to a screen reader while the bubble fades in.
      alwaysIncludeSemantics: true,
      child: ScaleTransition(
        scale: animation.drive(
          Tween<double>(
            begin: AnimationConstants.bubblePopScale,
            end: _fullSize,
          ).chain(CurveTween(curve: Interval(_start, 1, curve: AnimationConstants.curvePop))),
        ),
        alignment: origin.resolve(Directionality.of(context)),
        child: child,
      ),
    );
  }
}

/// From the start of the entrance delay to the bubble at full size.
final Duration _popEnd = AnimationConstants.bubbleEntranceDelay + AnimationConstants.bubblePop;

/// Share of the pop over which the bubble fades in.
const double _fadeShare = 0.5;

/// The bubble's own size, where the pop ends.
const double _fullSize = 1;

// ── Figma geometry ──
/// Outline width, drawn inside the box.
const double _outlineWidth = 1;

/// The tail's fill: a triangle whose base overlaps the box's edge by the
/// outline width, covering the outline where the tail opens.
const double _tailFillHalfWidth = 12.418;
const double _tailFillTip = 9.5;

/// The tail's outline: two 1px strokes from the box's edge to the tip.
const double _tailOutlineHalfWidth = 12;
const double _tailOutlineTip = 10;

/// Paints the box, its outline and the tail. The tail lies outside the size.
class _BubblePainter extends CustomPainter {
  const _BubblePainter({required this.fill, required this.outline, required this.face, required this.textDirection});

  final Color fill;
  final Color outline;
  final SpeechBubbleFace face;

  /// Which side the start edge is on.
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final box = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(ThemeConstants.radius16));
    final fillPaint = Paint()..color = fill;
    final outlinePaint = Paint()
      ..color = outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ── Box, outline inside its edge ──
    canvas
      ..drawRRect(box, fillPaint)
      ..drawRRect(box.deflate(_outlineWidth / 2), outlinePaint);

    // ── Tail ──
    // Drawn pointing down from the middle of the bottom edge, in coordinates
    // turned so that "down" is out of the edge the face puts it on.
    canvas.save();
    final (edgeLength, edgeAt) = _tailFrame(canvas, size);
    final center = edgeLength / 2;
    final tailFill = Path()
      ..moveTo(center - _tailFillHalfWidth, edgeAt - _outlineWidth)
      ..lineTo(center + _tailFillHalfWidth, edgeAt - _outlineWidth)
      ..lineTo(center, edgeAt + _tailFillTip)
      ..close();
    final tailOutline = Path()
      ..moveTo(center - _tailOutlineHalfWidth, edgeAt)
      ..lineTo(center, edgeAt + _tailOutlineTip)
      ..lineTo(center + _tailOutlineHalfWidth, edgeAt);
    canvas
      ..drawPath(tailFill, fillPaint)
      ..drawPath(tailOutline, outlinePaint)
      ..restore();
  }

  /// Turns the canvas so the tail's edge lies along the x axis with the
  /// outside below it; returns that edge's length and its y.
  (double, double) _tailFrame(Canvas canvas, Size size) {
    switch ((face, textDirection)) {
      case (SpeechBubbleFace.bottom, _):
        return (size.width, size.height);
      case (SpeechBubbleFace.start, TextDirection.ltr): // check-rules: ignore — painters mirror their geometry in RTL
        // Left edge: a quarter turn clockwise maps "down" to "left".
        canvas.rotate(math.pi / 2);
        return (size.height, 0);
      case (SpeechBubbleFace.start, TextDirection.rtl): // check-rules: ignore — painters mirror their geometry in RTL
        // Right edge: from the bottom-right corner, a quarter turn
        // anticlockwise maps "down" to "right".
        canvas
          ..translate(size.width, size.height)
          ..rotate(-math.pi / 2);
        return (size.height, 0);
    }
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) =>
      oldDelegate.fill != fill ||
      oldDelegate.outline != outline ||
      oldDelegate.face != face ||
      oldDelegate.textDirection != textDirection;
}

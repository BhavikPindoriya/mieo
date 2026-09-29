import 'package:flutter/material.dart';

import '../../../commons/widgets/app_button.dart';
import '../../../commons/widgets/meadow/meadow_backdrop.dart';
import '../../../commons/widgets/meadow/meadow_stage.dart';
import '../../../commons/widgets/responsive_content.dart';
import '../../../commons/widgets/sky_backdrop.dart';
import '../../../commons/widgets/speech_bubble.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MEADOW TALK SCAFFOLD
//
// The page every "Mieo talks to you" screen of new-account setup shares ("Hi!
// I’m Mieo", "I just want to ask you some Questions"): only what Mieo says,
// his animation and the button's label change. Top to bottom:
//
//   1. Sky panel — the shared meadow (MeadowBackdrop: sky, clouds, hills and
//      trees, the back button) with the screen's two layers in the Figma
//      "BOdy" frame's coordinates:
//        • Mieo, in his box (the Rive artboard);
//        • the talk bubble over him, centred on its Figma box and sitting on
//          the box's bottom edge, so the tail points at Mieo and a longer text
//          (another language, larger text) grows upwards and evenly both ways.
//          Painted last, so an animation that lifts Mieo never covers it.
//      The bubble's real top, its Figma bottom edge less its measured height
//      (SpeechBubble.boxHeight, in this text scale and language), is the top
//      of the panel's must-see band, so the stage keeps it clear of the top
//      bar however tall the bubble grows.
//   2. Action — Figma "Action": the filled button, 24 below the panel and 24
//      above the bottom edge (lifted above a navigation bar), on the page's
//      sky (SkyBackdrop, no clouds).
//
// No local state: the mascot plays its own animation and the button animates
// its own press.
// ─────────────────────────────────────────────────────────────────────────────
class MeadowTalkScaffold extends StatelessWidget {
  const MeadowTalkScaffold({
    super.key,
    required this.bubble,
    required this.bubbleArea,
    required this.mascot,
    required this.mascotArea,
    required this.actionLabel,
    required this.onAction,
  });

  /// What Mieo says.
  final SpeechBubble bubble;

  /// The Figma "Talk Bubble" box, in the BOdy frame.
  final Rect bubbleArea;

  /// Mieo.
  final Widget mascot;

  /// Mieo's box, in the BOdy frame.
  final Rect mascotArea;

  /// The button's label.
  final String actionLabel;

  /// What the button does.
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkyBackdrop(
        clouds: const [],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Sky panel ──
            Expanded(
              child: _SkyPanel(bubble: bubble, bubbleArea: bubbleArea, mascot: mascot, mascotArea: mascotArea),
            ),

            // ── Action ──
            _Action(label: actionLabel, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}

/// The meadow with the talk bubble and Mieo.
class _SkyPanel extends StatelessWidget {
  const _SkyPanel({required this.bubble, required this.bubbleArea, required this.mascot, required this.mascotArea});

  final SpeechBubble bubble;
  final Rect bubbleArea;
  final Widget mascot;
  final Rect mascotArea;

  @override
  Widget build(BuildContext context) {
    final centerX = bubbleArea.center.dx;
    final frameWidth = MeadowStage.frameSize.width;
    final halfFrameWidth = frameWidth / 2;
    return MeadowBackdrop(
      mustSeeTop: bubbleArea.bottom - bubble.boxHeight(context, maxWidth: frameWidth),
      children: [
        // ── Mieo ──
        Positioned.fromRect(rect: mascotArea, child: mascot),

        // ── Bubble ──
        // A frame-wide slot from the frame's top down to the bubble's bottom
        // edge, centred on the bubble.
        Positioned.fromRect(
          rect: Rect.fromLTRB(centerX - halfFrameWidth, 0, centerX + halfFrameWidth, bubbleArea.bottom),
          child: Align(alignment: AlignmentDirectional.bottomCenter, child: bubble),
        ),
      ],
    );
  }
}

/// The filled button under the panel.
class _Action extends StatelessWidget {
  const _Action({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveContent(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: ThemeConstants.spacing24,
          bottom: ThemeConstants.spacing24 + context.navigationBarInset,
        ),
        child: AppButton(label: label, onPressed: onPressed),
      ),
    );
  }
}

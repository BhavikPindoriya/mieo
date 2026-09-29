import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../app_top_bar.dart';
import '../clouds/cloud_groups.dart';
import '../clouds/clouds_painter.dart';
import 'meadow_painter.dart';
import 'meadow_stage.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MEADOW BACKDROP
//
// The sky panel of the New Account Progress screens (Figma "BOdy", 375 × 716
// on the reference): Mieo on a meadow under the sky, talking in a bubble. Top
// to bottom:
//
//   • Sky     — Surface/Sky/Top → Surface/Sky/Bottom, edge to edge from behind
//               the status bar, bottom corners rounded by 24 and clipped (the
//               top corners are the device's).
//   • Scene   — laid out in the BOdy frame's coordinates and fitted to the
//               panel by MeadowStage, painted in Figma's layer order: the
//               meadow clouds (CloudGroups.meadow, Cloud Color tokens), the
//               meadow (MeadowPainter), then the screen's own [children]
//               (its talk bubble and Mieo), placed in frame coordinates with
//               Positioned.fromRect and friends.
//   • Top bar — the back button under the status bar, over the scene.
//
// Screens give the frame y of their highest must-see layer ([mustSeeTop],
// usually the talk bubble's top as laid out, which a larger text scale or a
// longer translation raises) so the stage keeps it clear of the top bar.
// Where the panel is too short for the scene at its smallest (landscape
// phones), it scrolls. Everything in the scene paints into the panel's layer,
// which Mieo's soft-light shadows need: keep RepaintBoundary out of
// [children]. The scene is artwork and doesn't mirror in RTL; the back button
// does.
// ─────────────────────────────────────────────────────────────────────────────
class MeadowBackdrop extends StatelessWidget {
  const MeadowBackdrop({super.key, required this.mustSeeTop, required this.children, this.onBack});

  /// Frame y of the top of the must-see band (the talk bubble's top edge as
  /// laid out).
  final double mustSeeTop;

  /// The screen's layers over the meadow, in the 375 × 716 frame's
  /// coordinates.
  final List<Widget> children;

  /// Replaces the back button's default of going back a page.
  final VoidCallback? onBack;

  static const BorderRadius _radius = BorderRadius.vertical(bottom: Radius.circular(ThemeConstants.radius24));

  @override
  Widget build(BuildContext context) {
    final surface = context.colors.surface;
    final topInset = MediaQuery.paddingOf(context).top + AppTopBar.height;
    return ClipRRect(
      borderRadius: _radius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
            colors: [surface.skyTop, surface.skyBottom],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, viewport) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: viewport.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── Scene ──
                    _Scene(mustSeeTop: mustSeeTop, topInset: topInset, children: children),

                    // ── Top bar ──
                    PositionedDirectional(
                      top: 0,
                      start: 0,
                      end: 0,
                      child: SafeArea(bottom: false, child: AppTopBar(onBack: onBack)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The frame, fitted into the panel: clouds, meadow, then the screen's layers.
class _Scene extends StatelessWidget {
  const _Scene({required this.mustSeeTop, required this.topInset, required this.children});

  final double mustSeeTop;
  final double topInset;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final maxScale = context.isTabletLayout ? MeadowStage.tabletMaxScale : MeadowStage.designScale;
    return CustomSingleChildLayout(
      delegate: _StageDelegate(mustSeeTop: mustSeeTop, topInset: topInset, maxScale: maxScale),
      child: FittedBox(
        child: SizedBox.fromSize(
          size: MeadowStage.frameSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Clouds ──
              Positioned.fill(
                child: CustomPaint(
                  painter: CloudsPainter(clouds: CloudGroups.meadow, colors: context.colors.cloud),
                ),
              ),

              // ── Meadow ──
              const Positioned.fill(child: CustomPaint(painter: MeadowPainter())),

              // ── The screen's layers ──
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

/// Fills the slot and places the stage frame in it. Reports
/// MeadowStage.minSlotHeight as its intrinsic height, so the IntrinsicHeight
/// above can make room for the scene before it would shrink too far.
class _StageDelegate extends SingleChildLayoutDelegate {
  const _StageDelegate({required this.mustSeeTop, required this.topInset, required this.maxScale});

  final double mustSeeTop;
  final double topInset;
  final double maxScale;

  @override
  Size getSize(BoxConstraints constraints) => constraints.constrain(
    Size(constraints.maxWidth, MeadowStage.minSlotHeight(mustSeeTop: mustSeeTop, topInset: topInset)),
  );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.tight(_fit(getSize(constraints)).frameRect.size);

  @override
  Offset getPositionForChild(Size size, Size childSize) => _fit(size).frameRect.topLeft;

  @override
  bool shouldRelayout(_StageDelegate oldDelegate) =>
      oldDelegate.mustSeeTop != mustSeeTop || oldDelegate.topInset != topInset || oldDelegate.maxScale != maxScale;

  MeadowStage _fit(Size slot) => MeadowStage.fit(slot, mustSeeTop: mustSeeTop, topInset: topInset, maxScale: maxScale);
}

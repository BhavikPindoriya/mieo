import 'package:flutter/widgets.dart';

import '../../../commons/widgets/clouds/cloud_shapes.dart';
import '../../../commons/widgets/clouds/clouds_painter.dart';
import '../../../utils/extensions/context_extensions.dart';
import 'language_pedestals_painter.dart';
import 'onboarding_stage.dart';
import 'welcome_mascot_painter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ONBOARDING SCENE
//
// The picture in the Onboarding sky panel, Figma "Image" (31:141), painted
// bottom to top in Figma's layer order in the Body frame's coordinates:
//
//   1. Pedestals — three columns with oval tops (LanguagePedestalsPainter).
//   2. Clouds    — seven of the shared cloud shapes, in the Cloud Color tokens.
//   3. Mieo      — the code-drawn mascot (WelcomeMascotPainter).
//
// The widget fills its slot (the space under the intro) and places the frame
// in it with OnboardingStage. The frame reaches past the slot, up behind the
// intro and beyond the sides, so the panel around it clips. All three layers
// paint into the panel's layer, which Mieo's soft-light shadows need: keep
// RepaintBoundary out of this subtree.
// ─────────────────────────────────────────────────────────────────────────────

/// "Cloudes" (31:157): the clouds at their Figma positions in the frame.
final List<CloudPlacement> _clouds = [
  CloudPlacement(CloudShapes.cloud1, -9, 196.845),
  CloudPlacement(CloudShapes.cloud2, 267, 193.845),
  CloudPlacement(CloudShapes.cloud3, 261, 296.845),
  CloudPlacement(CloudShapes.cloud4, -43, 330.845),
  CloudPlacement(CloudShapes.cloud5, 291, 407.845),
  CloudPlacement(CloudShapes.cloud6, -12, 523.845),
  CloudPlacement(CloudShapes.cloud8, 297, 498),
];

/// "Mieo Charachter" (31:208): top-left corner of the mascot's artwork box in
/// the frame.
const double _mascotLeft = 56;
const double _mascotTop = 179.399;

class OnboardingScene extends StatelessWidget {
  const OnboardingScene({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxScale = context.isTabletLayout ? OnboardingStage.tabletMaxScale : OnboardingStage.designScale;
    return CustomSingleChildLayout(
      delegate: _StageDelegate(maxScale),
      child: FittedBox(
        child: SizedBox.fromSize(
          size: OnboardingStage.frameSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── 1. Pedestals ──
              Positioned.fill(
                child: CustomPaint(
                  painter: LanguagePedestalsPainter(
                    columnTop: colors.surface.extraDimPrimary,
                    columnBottom: colors.surface.skyTop,
                    top: colors.surface.primary,
                    rim: colors.shadow.primaryLighter,
                  ),
                ),
              ),

              // ── 2. Clouds ──
              Positioned.fill(
                child: CustomPaint(
                  painter: CloudsPainter(clouds: _clouds, colors: colors.cloud),
                ),
              ),

              // ── 3. Mieo ──
              Positioned.fromRect(
                rect: const Offset(_mascotLeft, _mascotTop) & WelcomeMascotPainter.artworkSize,
                child: const CustomPaint(painter: WelcomeMascotPainter()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fills the slot and places the stage frame in it. Reports
/// OnboardingStage.minSlotHeight as its intrinsic height, so an IntrinsicHeight
/// ancestor can make room for the scene before it would shrink too far.
class _StageDelegate extends SingleChildLayoutDelegate {
  const _StageDelegate(this.maxScale);

  final double maxScale;

  @override
  Size getSize(BoxConstraints constraints) =>
      constraints.constrain(Size(constraints.maxWidth, OnboardingStage.minSlotHeight));

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.tight(_fit(getSize(constraints)).frameRect.size);

  @override
  Offset getPositionForChild(Size size, Size childSize) => _fit(size).frameRect.topLeft;

  @override
  bool shouldRelayout(_StageDelegate oldDelegate) => oldDelegate.maxScale != maxScale;

  OnboardingStage _fit(Size slot) => OnboardingStage.fit(slot, maxScale: maxScale);
}

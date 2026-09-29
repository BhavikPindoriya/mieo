import 'package:flutter/rendering.dart';

import '../../../core/theme/colors.dart';
import 'mascot_effects.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NOTEBOOK MASCOT PAINTER
//
// Mieo taking notes, a notebook in one paw and a pencil in the other: Figma
// "Mieo Charachter" (62:8480) in the header of the New Account Progress
// question screens (native language, learning language, level, daily goal).
// Drawn from the vector geometry (0.001px precision) in a 142.656 × 154.736
// box whose origin is the group's top-left corner; left and right in the path
// names are as seen in the picture.
//
// Painted in Figma's layer order: ears, legs, body, belly, eyes, the brows
// over them, the face (muzzle, mouth with the tongue clipped inside it, the
// smile's corners, nose), then the paws and what they hold: the notebook, the
// left arm, the pencil and the right arm over it. The hard Figma effects are
// paths (MascotEffects): the white rims on the body and arms and the
// notebook's inner shadow, the soft-light drop shadows of the body and the
// left leg, and the solid drop shadows of the brows, the muzzle and the arms.
// Soft light blends with what is already on the canvas, so the scene behind
// must paint into the same layer: no RepaintBoundary between the two.
//
// The fur, face and pencil are artwork colours (the same in both themes). Two
// fills are bound to theme tokens in Figma, so the caller passes them: the
// notebook (Surface/Primary) and the pencil's lead (Surface/Nuturel).
// ─────────────────────────────────────────────────────────────────────────────
class NotebookMascotPainter extends CustomPainter {
  const NotebookMascotPainter({required this.notebookColor, required this.leadColor});

  /// The artwork box at design size: the Figma group.
  static const Size artworkSize = Size(142.656, 154.736);

  /// Figma Surface/Primary.
  final Color notebookColor;

  /// Figma Surface/Nuturel.
  final Color leadColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    void fill(Path path, Color color, [BlendMode blendMode = BlendMode.srcOver]) {
      canvas.drawPath(
        path,
        paint
          ..color = color
          ..blendMode = blendMode,
      );
    }

    // ── Ears ──
    fill(_MascotPaths.earLeft, ArtworkColors.mieoFur);
    fill(_MascotPaths.earLeftInner, _black.withValues(alpha: _earInnerOpacity));
    fill(_MascotPaths.earRight, ArtworkColors.mieoFur);
    fill(_MascotPaths.earRightInner, _black.withValues(alpha: _earInnerOpacity));

    // ── Legs, behind the body ──
    fill(_MascotPaths.legRight, ArtworkColors.mieoPaw);
    fill(_MascotPaths.legLeftShadow, _black.withValues(alpha: _legShadowOpacity), BlendMode.softLight);
    fill(_MascotPaths.legLeft, ArtworkColors.mieoPaw);

    // ── Body, with its top rim, and belly ──
    fill(_MascotPaths.bodyShadow, _black.withValues(alpha: _bodyShadowOpacity), BlendMode.softLight);
    fill(_MascotPaths.body, ArtworkColors.mieoFur);
    fill(_MascotPaths.bodyRim, _white.withValues(alpha: _rimOpacity));
    fill(_MascotPaths.belly, _white.withValues(alpha: _bellyOpacity));

    // ── Eyes ──
    fill(_MascotPaths.eyeLeftShade, _black.withValues(alpha: _eyeShadeOpacity));
    fill(_MascotPaths.eyeLeft, _black);
    fill(_MascotPaths.eyeLeftGlint, _white);
    fill(_MascotPaths.eyeRightShade, _black.withValues(alpha: _eyeShadeOpacity));
    fill(_MascotPaths.eyeRight, _black);
    fill(_MascotPaths.eyeRightGlint, _white);

    // ── Brows, half over the eyes ──
    fill(_MascotPaths.browRightShadow, ArtworkColors.mieoCheekShadow);
    fill(_MascotPaths.browRight, ArtworkColors.mieoFur);
    fill(_MascotPaths.browLeftShadow, ArtworkColors.mieoCheekShadow);
    fill(_MascotPaths.browLeft, ArtworkColors.mieoFur);

    // ── Muzzle, mouth and nose ──
    fill(_MascotPaths.muzzleShadow, _black.withValues(alpha: _muzzleShadowOpacity));
    fill(_MascotPaths.muzzle, _white.withValues(alpha: _muzzleOpacity));
    fill(_MascotPaths.mouth, _black);
    fill(_MascotPaths.tongue, ArtworkColors.mieoTongue);
    fill(_MascotPaths.dimpleLeft, _black);
    fill(_MascotPaths.dimpleRight, _black);
    fill(_MascotPaths.nose, _black);

    // ── Notebook, with its inner shadow ──
    fill(_MascotPaths.notebook, notebookColor);
    fill(_MascotPaths.notebookShade, _white.withValues(alpha: _notebookShadeOpacity));

    // ── Left arm, holding the notebook ──
    fill(_MascotPaths.armLeftShadow, ArtworkColors.mieoArmShadow);
    fill(_MascotPaths.armLeft, ArtworkColors.mieoFur);
    fill(_MascotPaths.armLeftRim, _white.withValues(alpha: _rimOpacity));

    // ── Pencil ──
    fill(_MascotPaths.pencilBody, AppColors.secondary700);
    fill(_MascotPaths.pencilBand, AppColors.secondary950);
    fill(_MascotPaths.pencilEraser, AppColors.secondary200);
    fill(_MascotPaths.pencilTip, AppColors.ternary300);
    fill(_MascotPaths.pencilLead, leadColor);

    // ── Right arm, over the pencil ──
    fill(_MascotPaths.armRightShadow, ArtworkColors.mieoArmShadow);
    fill(_MascotPaths.armRight, ArtworkColors.mieoFur);
    fill(_MascotPaths.armRightRim, _white.withValues(alpha: _rimOpacity));
  }

  @override
  bool shouldRepaint(NotebookMascotPainter oldDelegate) =>
      oldDelegate.notebookColor != notebookColor || oldDelegate.leadColor != leadColor;
}

// ── Artwork colours (raw black and white in Figma) ──
const Color _black = MascotEffects.black;
const Color _white = MascotEffects.white;

// ── Figma fill opacities ──
const double _earInnerOpacity = 0.32;
const double _bellyOpacity = 0.39;
const double _eyeShadeOpacity = 0.2;
const double _muzzleOpacity = 0.5;

// ── Figma effects: drop shadows (offset, opacity) and inner shadows ──
const double _legShadowDx = 0.11;
const double _legShadowDy = 1.89;
const double _legShadowOpacity = 0.65;
const double _bodyShadowDy = 2.519;
const double _bodyShadowOpacity = 0.35;
const double _browShadowDy = 1.26;
const double _muzzleShadowDx = 1.523;
const double _muzzleShadowDy = 1.828;
const double _muzzleShadowOpacity = 0.12;
const double _armLeftShadowDy = 1.889;
const double _armRightShadowDy = 1.26;

/// The white inner-shadow rim on the fur shapes: 1.828 deep at 55%.
const double _rimDepth = 1.828;
const double _rimOpacity = MascotEffects.rimOpacity;

/// The notebook's inner shadow: white 47%, cast from (-4, 1), so it lines
/// the notebook's top and far edges.
const double _notebookShadeDx = -4;
const double _notebookShadeDy = 1;
const double _notebookShadeOpacity = 0.47;

/// The notebook: a 35 × 42 rectangle with 4-radius corners.
const double _notebookRadius = 4;

/// The pencil's lead: a 3-wide dot at the tip, clipped by the sharpened wood.
const double _leadRadius = 1.5;
const double _leadX = 76.382;
const double _leadY = 99.992;

/// The artwork's vectors, in the artwork box.
abstract final class _MascotPaths {
  /// Left ear.
  static final Path earLeft = Path()
    ..moveTo(33.668, 19.525)
    ..cubicTo(30.074, 15.931, 30.074, 10.103, 33.668, 6.508)
    ..cubicTo(37.263, 2.914, 43.091, 2.914, 46.685, 6.508)
    ..cubicTo(50.28, 10.103, 47.676, 13.327, 44.082, 16.922)
    ..cubicTo(40.487, 20.516, 37.263, 23.12, 33.668, 19.525)
    ..close();

  /// Inside of the left ear (black, 32%).
  static final Path earLeftInner = Path()
    ..moveTo(37.046, 18.681)
    ..cubicTo(34.617, 16.252, 34.617, 12.315, 37.046, 9.886)
    ..cubicTo(39.474, 7.457, 43.412, 7.457, 45.841, 9.886)
    ..cubicTo(48.269, 12.315, 46.51, 14.493, 44.082, 16.922)
    ..cubicTo(41.653, 19.351, 39.474, 21.11, 37.046, 18.681)
    ..close();

  /// Right ear.
  static final Path earRight = Path()
    ..moveTo(101.438, 19.526)
    ..cubicTo(105.033, 15.931, 105.033, 10.103, 101.438, 6.509)
    ..cubicTo(97.844, 2.914, 92.016, 2.914, 88.421, 6.509)
    ..cubicTo(84.827, 10.103, 87.43, 13.328, 91.025, 16.922)
    ..cubicTo(94.619, 20.517, 97.844, 23.12, 101.438, 19.526)
    ..close();

  /// Inside of the right ear (black, 32%).
  static final Path earRightInner = Path()
    ..moveTo(98.061, 18.681)
    ..cubicTo(100.489, 16.253, 100.489, 12.315, 98.061, 9.886)
    ..cubicTo(95.632, 7.458, 91.694, 7.458, 89.266, 9.886)
    ..cubicTo(86.837, 12.315, 88.596, 14.494, 91.025, 16.922)
    ..cubicTo(93.453, 19.351, 95.632, 21.11, 98.061, 18.681)
    ..close();

  /// Right leg, behind the body.
  static final Path legRight = Path()
    ..moveTo(71.367, 104.272)
    ..cubicTo(80.745, 97.217, 94.181, 99.957, 100.048, 110.119)
    ..cubicTo(105.916, 120.282, 101.57, 133.288, 90.772, 137.882)
    ..lineTo(78.407, 143.142)
    ..cubicTo(70.077, 146.686, 60.412, 143.457, 55.885, 135.617)
    ..cubicTo(51.359, 127.777, 53.395, 117.792, 60.629, 112.35)
    ..lineTo(71.367, 104.272)
    ..close();

  /// Left leg, behind the body.
  static final Path legLeft = Path()
    ..moveTo(40.162, 135.882)
    ..cubicTo(29.364, 131.288, 25.018, 118.282, 30.885, 108.119)
    ..cubicTo(36.753, 97.957, 50.189, 95.217, 59.566, 102.272)
    ..lineTo(70.305, 110.35)
    ..cubicTo(77.539, 115.792, 79.575, 125.777, 75.048, 133.617)
    ..cubicTo(70.522, 141.457, 60.857, 144.686, 52.527, 141.142)
    ..lineTo(40.162, 135.882)
    ..close();

  /// Body.
  static final Path body = Path()
    ..moveTo(125.905, 79.035)
    ..cubicTo(125.905, 108.137, 99.837, 131.73, 67.68, 131.73)
    ..cubicTo(35.523, 131.73, 9.454, 108.137, 9.454, 79.035)
    ..cubicTo(9.454, 49.933, 35.523, 4.977, 67.68, 4.977)
    ..cubicTo(99.837, 4.977, 125.905, 49.933, 125.905, 79.035)
    ..close();

  /// Belly patch (white, 39%).
  static final Path belly = Path()
    ..moveTo(92.675, 107.79)
    ..cubicTo(92.675, 117.593, 81.346, 123.22, 67.37, 123.22)
    ..cubicTo(53.394, 123.22, 42.064, 117.593, 42.064, 107.79)
    ..cubicTo(42.064, 104.947, 53.394, 105.753, 67.37, 105.753)
    ..cubicTo(81.346, 105.753, 92.675, 104.947, 92.675, 107.79)
    ..close();

  /// Muzzle (white, 50%).
  static final Path muzzle = Path()
    ..moveTo(94.019, 62.755)
    ..cubicTo(94.019, 76.855, 82.389, 88.285, 68.042, 88.285)
    ..cubicTo(53.695, 88.285, 42.064, 76.855, 42.064, 62.755)
    ..cubicTo(42.064, 55.374, 53.695, 50.662, 68.042, 50.662)
    ..cubicTo(82.389, 50.662, 94.019, 55.374, 94.019, 62.755)
    ..close();

  /// Open mouth.
  static final Path mouth = Path()
    ..moveTo(83.27, 69.292)
    ..cubicTo(83.27, 70.574, 74.079, 79.861, 68.266, 79.861)
    ..cubicTo(62.453, 79.861, 53.261, 70.574, 53.261, 69.292)
    ..cubicTo(53.261, 70.221, 64.534, 76.5, 70.347, 76.5)
    ..cubicTo(76.16, 76.5, 83.27, 70.221, 83.27, 69.292)
    ..close();

  /// The mouth's opening, which clips the tongue (Figma "Mask group").
  static final Path mouthMask = Path()
    ..moveTo(83.27, 69.276)
    ..cubicTo(83.27, 70.558, 74.079, 79.845, 68.266, 79.845)
    ..cubicTo(62.453, 79.845, 53.261, 70.558, 53.261, 69.276)
    ..cubicTo(53.261, 70.205, 62.453, 68.435, 68.266, 68.435)
    ..cubicTo(74.079, 68.435, 83.27, 70.205, 83.27, 69.276)
    ..close();

  /// Left corner of the smile.
  static final Path dimpleLeft = Path()
    ..moveTo(54.92, 64.867)
    ..cubicTo(55.307, 65.254, 55.739, 67.61, 53.806, 69.543)
    ..cubicTo(51.874, 71.476, 49.518, 71.043, 49.13, 70.656)
    ..cubicTo(49.411, 70.937, 51.348, 70.95, 53.28, 69.017)
    ..cubicTo(55.213, 67.085, 55.2, 65.148, 54.92, 64.867)
    ..close();

  /// Right corner of the smile.
  static final Path dimpleRight = Path()
    ..moveTo(88.339, 70.22)
    ..cubicTo(88.065, 70.694, 85.901, 71.722, 83.534, 70.355)
    ..cubicTo(81.167, 68.989, 80.975, 66.601, 81.249, 66.127)
    ..cubicTo(81.05, 66.47, 81.539, 68.345, 83.906, 69.711)
    ..cubicTo(86.273, 71.078, 88.141, 70.564, 88.339, 70.22)
    ..close();

  /// Nose.
  static final Path nose = Path()
    ..moveTo(81.95, 52.699)
    ..cubicTo(81.95, 59.071, 75.747, 64.237, 68.095, 64.237)
    ..cubicTo(60.443, 64.237, 54.24, 59.071, 54.24, 52.699)
    ..cubicTo(54.24, 49.363, 60.443, 47.233, 68.095, 47.233)
    ..cubicTo(75.747, 47.233, 81.95, 49.363, 81.95, 52.699)
    ..close();

  /// Left arm, holding the notebook.
  static final Path armLeft = Path()
    ..moveTo(39.847, 94.5)
    ..cubicTo(47.847, 88, 38.841, 85.098, 30.054, 77.832)
    ..cubicTo(23.687, 51.935, 0.793, 67.373, 8.692, 86.31)
    ..cubicTo(13.433, 98.88, 30.847, 101.813, 39.847, 94.5)
    ..close();

  /// Right arm, holding the pencil.
  static final Path armRight = Path()
    ..moveTo(85.946, 87.935)
    ..cubicTo(90.418, 77.835, 99.385, 94.27, 112.103, 65.072)
    ..cubicTo(122.553, 46.822, 152.043, 68.05, 123.976, 90.87)
    ..cubicTo(105.164, 103.414, 85.577, 99.95, 85.946, 87.935)
    ..close();

  /// Pencil: the yellow shaft.
  static final Path pencilBody = Path()
    ..moveTo(82.746, 99.991)
    ..lineTo(76.382, 93.627)
    ..lineTo(96.181, 73.828)
    ..lineTo(102.545, 80.192)
    ..lineTo(82.746, 99.991)
    ..close();

  /// Pencil: the metal band.
  static final Path pencilBand = Path()
    ..moveTo(97.595, 85.142)
    ..lineTo(91.231, 78.778)
    ..lineTo(94.06, 75.95)
    ..lineTo(100.424, 82.314)
    ..lineTo(97.595, 85.142)
    ..close();

  /// Pencil: the eraser.
  static final Path pencilEraser = Path()
    ..moveTo(100.424, 82.314)
    ..lineTo(94.06, 75.95)
    ..lineTo(99.01, 71)
    ..lineTo(105.374, 77.364)
    ..lineTo(100.424, 82.314)
    ..close();

  /// Pencil: the sharpened wood.
  static final Path pencilTip = Path()
    ..moveTo(76.029, 100.345)
    ..lineTo(76.382, 93.627)
    ..lineTo(82.746, 99.991)
    ..lineTo(76.029, 100.345)
    ..close();

  /// Left eye: the soft ring, the pupil and its glint.
  static final Path eyeLeftShade = Path()..addOval(const Rect.fromLTRB(43.228, 27.103, 62.487, 46.363));
  static final Path eyeLeft = Path()..addOval(const Rect.fromLTRB(45.468, 31.582, 60.248, 46.363));
  static final Path eyeLeftGlint = Path()..addOval(const Rect.fromLTRB(51.847, 42, 54.847, 45));

  /// Right eye: the soft ring, the pupil and its glint.
  static final Path eyeRightShade = Path()..addOval(const Rect.fromLTRB(73.595, 27.103, 92.854, 46.363));
  static final Path eyeRight = Path()..addOval(const Rect.fromLTRB(75.834, 31.582, 90.615, 46.363));
  static final Path eyeRightGlint = Path()..addOval(const Rect.fromLTRB(81.847, 42, 84.847, 45));

  /// Brows: two fur ovals over the top of the eyes.
  static final Path browLeft = Path()..addOval(const Rect.fromLTRB(39.847, 22, 66.847, 35));
  static final Path browRight = Path()..addOval(const Rect.fromLTRB(68.847, 22, 94.847, 35));

  /// Tongue, clipped by the mouth's opening.
  static final Path tongue = Path.combine(
    PathOperation.intersect,
    Path()..addOval(const Rect.fromLTRB(72.847, 71, 91.111, 84.225)),
    mouthMask,
  );

  /// Notebook.
  static final Path notebook = Path()
    ..addRRect(RRect.fromLTRBR(34.847, 67, 69.847, 109, const Radius.circular(_notebookRadius)));

  /// Pencil: the lead, clipped by the sharpened wood.
  static final Path pencilLead = Path.combine(
    PathOperation.intersect,
    Path()..addOval(Rect.fromCircle(center: const Offset(_leadX, _leadY), radius: _leadRadius)),
    pencilTip,
  );

  // ── Effects ──
  static final Path legLeftShadow = MascotEffects.dropShadow(legLeft, const Offset(_legShadowDx, _legShadowDy));
  static final Path bodyShadow = MascotEffects.dropShadow(body, const Offset(0, _bodyShadowDy));
  static final Path bodyRim = MascotEffects.topRim(body, depth: _rimDepth);
  static final Path browLeftShadow = MascotEffects.dropShadow(browLeft, const Offset(0, _browShadowDy));
  static final Path browRightShadow = MascotEffects.dropShadow(browRight, const Offset(0, _browShadowDy));
  static final Path muzzleShadow = MascotEffects.dropShadow(muzzle, const Offset(_muzzleShadowDx, _muzzleShadowDy));
  static final Path notebookShade = MascotEffects.innerShadow(
    notebook,
    const Offset(_notebookShadeDx, _notebookShadeDy),
  );
  static final Path armLeftShadow = MascotEffects.dropShadow(armLeft, const Offset(0, _armLeftShadowDy));
  static final Path armLeftRim = MascotEffects.topRim(armLeft, depth: _rimDepth);
  static final Path armRightShadow = MascotEffects.dropShadow(armRight, const Offset(0, _armRightShadowDy));
  static final Path armRightRim = MascotEffects.topRim(armRight, depth: _rimDepth);
}

import 'package:flutter/rendering.dart';

import '../../../core/theme/colors.dart';
import 'mascot_effects.dart';

// ─────────────────────────────────────────────────────────────────────────────
// WELCOME MASCOT PAINTER
//
// Mieo standing on the language pedestals: Figma "Mieo Charachter" (31:208) on
// the Onboarding frame, drawn from its vector geometry (0.001px precision) in
// a 271 × 284 box whose origin is the group's top-left corner (the box also
// holds the right sole's shadow). Every colour is an artwork colour, the same
// in both themes; left and right in the path names are as seen in the picture.
//
// The Figma effects are hard (no blur), so each one is a path:
//
//   • Drop shadow  — the shape moved by the shadow offset, minus the shape:
//                    the sliver that shows beside it, filled black. The right
//                    sole and the body use soft light, which deepens what lies
//                    below (pedestal, cloud, sky) instead of greying it. Soft
//                    light blends with what is already on the canvas, so the
//                    scene behind must paint into the same layer: no
//                    RepaintBoundary between the scene and this painter.
//   • Inner shadow — the arms and the body carry a white rim along their top
//                    edge: the shape minus the shape moved down.
// ─────────────────────────────────────────────────────────────────────────────
class WelcomeMascotPainter extends CustomPainter {
  const WelcomeMascotPainter();

  /// The artwork box at design size.
  static const Size artworkSize = Size(271, 284);

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
    fill(_MascotPaths.legLeft, ArtworkColors.mieoPaw);
    fill(_MascotPaths.legRightShadow, _black.withValues(alpha: _soleShadowOpacity), BlendMode.softLight);
    fill(_MascotPaths.legRight, ArtworkColors.mieoPaw);

    // ── Arms and body, each with its top rim ──
    fill(_MascotPaths.armRight, ArtworkColors.mieoFur);
    fill(_MascotPaths.armRightRim, _white.withValues(alpha: _rimOpacity));
    fill(_MascotPaths.armLeft, ArtworkColors.mieoFur);
    fill(_MascotPaths.armLeftRim, _white.withValues(alpha: _rimOpacity));
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

    // ── Muzzle, mouth and nose ──
    fill(_MascotPaths.muzzleShadow, _black.withValues(alpha: _muzzleShadowOpacity));
    fill(_MascotPaths.muzzle, _white.withValues(alpha: _muzzleOpacity));
    fill(_MascotPaths.mouth, _black);
    fill(_MascotPaths.nose, _black);

    // ── Brow ──
    fill(_MascotPaths.browRidgeShadow, _black.withValues(alpha: _browShadowOpacity));
    fill(_MascotPaths.browRidge, ArtworkColors.mieoFur);
    fill(_MascotPaths.browCenterShadow, _black.withValues(alpha: _browShadowOpacity));
    fill(_MascotPaths.browCenter, ArtworkColors.mieoFur);
    fill(_MascotPaths.browTopShadow, _black.withValues(alpha: _browShadowOpacity));
    fill(_MascotPaths.browTop, ArtworkColors.mieoFur);
  }

  @override
  bool shouldRepaint(WelcomeMascotPainter oldDelegate) => false;
}

// ── Artwork colours (raw black and white in Figma) ──
const Color _black = MascotEffects.black;
const Color _white = MascotEffects.white;

// ── Figma fill opacities ──
const double _earInnerOpacity = 0.32;
const double _bellyOpacity = 0.39;
const double _eyeShadeOpacity = 0.2;
const double _muzzleOpacity = 0.5;

// ── Figma effects: drop shadows (offset, opacity) and the inner-shadow rim ──
const double _soleShadowDx = -3;
const double _soleShadowDy = 3;
const double _soleShadowOpacity = 0.65;
const double _bodyShadowDy = 4;
const double _bodyShadowOpacity = 0.35;
const double _muzzleShadowDx = 2.418;
const double _muzzleShadowDy = 2.902;
const double _muzzleShadowOpacity = 0.12;
const double _browRidgeShadowDy = 5.31;
const double _browFoldShadowDy = 1.328;
const double _browShadowOpacity = 0.25;
const double _rimOpacity = MascotEffects.rimOpacity;

/// The artwork's vectors, in the artwork box.
abstract final class _MascotPaths {
  /// Left ear.
  static final Path earLeft = Path()
    ..moveTo(91.194, 59.74)
    ..cubicTo(87.254, 47.356, 91.692, 36.388, 101.109, 35.241)
    ..cubicTo(110.525, 34.094, 121.353, 43.204, 125.294, 55.587)
    ..cubicTo(129.235, 67.971, 121.942, 69.97, 112.525, 71.117)
    ..cubicTo(103.109, 72.263, 95.135, 72.123, 91.194, 59.74)
    ..close();

  /// Inside of the left ear (black, 32%).
  static final Path earLeftInner = Path()
    ..moveTo(97.564, 62.474)
    ..cubicTo(94.902, 54.107, 97.901, 46.696, 104.263, 45.922)
    ..cubicTo(110.625, 45.147, 117.941, 51.302, 120.604, 59.669)
    ..cubicTo(123.267, 68.036, 118.339, 69.387, 111.977, 70.162)
    ..cubicTo(105.615, 70.936, 100.227, 70.841, 97.564, 62.474)
    ..close();

  /// Right ear.
  static final Path earRight = Path()
    ..moveTo(190.241, 59.739)
    ..cubicTo(194.182, 47.356, 189.743, 36.388, 180.327, 35.241)
    ..cubicTo(170.911, 34.094, 160.083, 43.203, 156.142, 55.587)
    ..cubicTo(152.201, 67.971, 159.494, 69.97, 168.91, 71.117)
    ..cubicTo(178.326, 72.263, 186.3, 72.123, 190.241, 59.739)
    ..close();

  /// Inside of the right ear (black, 32%).
  static final Path earRightInner = Path()
    ..moveTo(183.871, 62.474)
    ..cubicTo(186.534, 54.107, 183.535, 46.696, 177.173, 45.922)
    ..cubicTo(170.81, 45.147, 163.494, 51.302, 160.832, 59.669)
    ..cubicTo(158.169, 68.036, 163.097, 69.387, 169.459, 70.162)
    ..cubicTo(175.821, 70.936, 181.209, 70.841, 183.871, 62.474)
    ..close();

  /// Left leg, behind the body.
  static final Path legLeft = Path()
    ..moveTo(81.319, 223.859)
    ..cubicTo(79.604, 209.854, 90.532, 197.505, 104.642, 197.505)
    ..cubicTo(118.752, 197.505, 129.68, 209.854, 127.964, 223.859)
    ..lineTo(126.031, 239.641)
    ..cubicTo(124.708, 250.449, 115.53, 258.571, 104.642, 258.571)
    ..cubicTo(93.753, 258.571, 84.576, 250.449, 83.252, 239.641)
    ..lineTo(81.319, 223.859)
    ..close();

  /// Right leg, behind the body; casts the soft-light sole shadow.
  static final Path legRight = Path()
    ..moveTo(132.685, 234.785)
    ..cubicTo(130.429, 216.288, 144.864, 199.987, 163.497, 199.987)
    ..cubicTo(182.13, 199.987, 196.564, 216.288, 194.308, 234.785)
    ..lineTo(191.726, 255.965)
    ..cubicTo(189.985, 270.233, 177.871, 280.96, 163.497, 280.96)
    ..cubicTo(149.122, 280.96, 137.008, 270.233, 135.268, 255.965)
    ..lineTo(132.685, 234.785)
    ..close();

  /// Right arm, raised.
  static final Path armRight = Path()
    ..moveTo(185.825, 140.909)
    ..cubicTo(200.479, 113.16, 226.197, 116.305, 238.445, 137.705)
    ..cubicTo(256.951, 170.04, 251.891, 224.091, 242.598, 227.172)
    ..cubicTo(211.891, 237.351, 196.312, 163.599, 185.825, 140.909)
    ..close();

  /// Left arm, stretched out.
  static final Path armLeft = Path()
    ..moveTo(96.952, 150.896)
    ..cubicTo(125.758, 132.852, 70.305, 97.268, 56.723, 113.775)
    ..cubicTo(46.779, 125.859, -3.837, 184.444, 2.261, 192.103)
    ..cubicTo(22.411, 217.41, 75.769, 164.164, 96.952, 150.896)
    ..close();

  /// Head and body in one shape.
  static final Path body = Path()
    ..moveTo(233.369, 161.74)
    ..cubicTo(233.369, 207.951, 191.976, 245.413, 140.915, 245.413)
    ..cubicTo(89.854, 245.413, 48.46, 207.951, 48.46, 161.74)
    ..cubicTo(48.46, 115.529, 89.854, 44.147, 140.915, 44.147)
    ..cubicTo(191.976, 44.147, 233.369, 115.529, 233.369, 161.74)
    ..close();

  /// Belly patch (white, 39%).
  static final Path belly = Path()
    ..moveTo(180.03, 207.398)
    ..cubicTo(180.03, 222.965, 162.04, 231.9, 139.848, 231.9)
    ..cubicTo(117.656, 231.9, 99.666, 222.965, 99.666, 207.398)
    ..cubicTo(99.666, 202.885, 117.656, 204.164, 139.848, 204.164)
    ..cubicTo(162.04, 204.164, 180.03, 202.885, 180.03, 207.398)
    ..close();

  /// Shade around the left eye (black, 20%).
  static final Path eyeLeftShade = Path()..addOval(const Rect.fromLTRB(101.515, 79.279, 132.096, 109.86));

  /// Left eye.
  static final Path eyeLeft = Path()..addOval(const Rect.fromLTRB(105.07, 86.391, 128.54, 109.86));

  /// Glint in the left eye.
  static final Path eyeLeftGlint = Path()..addOval(const Rect.fromLTRB(118.584, 95.495, 124.984, 101.896));

  /// Shade around the right eye (black, 20%).
  static final Path eyeRightShade = Path()..addOval(const Rect.fromLTRB(149.734, 79.279, 180.315, 109.86));

  /// Right eye.
  static final Path eyeRight = Path()..addOval(const Rect.fromLTRB(153.29, 86.391, 176.759, 109.861));

  /// Glint in the right eye.
  static final Path eyeRightGlint = Path()..addOval(const Rect.fromLTRB(155.423, 95.495, 161.824, 101.895));

  /// Muzzle (white, 50%).
  static final Path muzzle = Path()
    ..moveTo(182.164, 135.89)
    ..cubicTo(182.164, 158.278, 163.696, 176.427, 140.915, 176.427)
    ..cubicTo(118.134, 176.427, 99.666, 158.278, 99.666, 135.89)
    ..cubicTo(99.666, 124.169, 118.134, 116.688, 140.915, 116.688)
    ..cubicTo(163.696, 116.688, 182.164, 124.169, 182.164, 135.89)
    ..close();

  /// Smile.
  static final Path mouth = Path()
    ..moveTo(165.095, 147.269)
    ..cubicTo(165.095, 149.305, 150.501, 160.639, 141.27, 160.639)
    ..cubicTo(132.04, 160.639, 117.446, 149.305, 117.446, 147.269)
    ..cubicTo(117.446, 148.744, 132.04, 155.873, 141.27, 155.873)
    ..cubicTo(150.501, 155.873, 165.095, 148.744, 165.095, 147.269)
    ..close();

  /// Nose.
  static final Path nose = Path()
    ..moveTo(162.962, 121.996)
    ..cubicTo(162.962, 133.99, 153.091, 143.713, 140.915, 143.713)
    ..cubicTo(128.739, 143.713, 118.868, 133.99, 118.868, 121.996)
    ..cubicTo(118.868, 115.717, 128.739, 111.709, 140.915, 111.709)
    ..cubicTo(153.091, 111.709, 162.962, 115.717, 162.962, 121.996)
    ..close();

  /// Brow ridge over both eyes.
  static final Path browRidge = Path()..addOval(const Rect.fromLTRB(99.236, 71.219, 181.542, 97.769));

  /// Small fold between the brows.
  static final Path browCenter = Path()..addOval(const Rect.fromLTRB(126, 77.601, 153, 85.601));

  /// Fold above the brow ridge.
  static final Path browTop = Path()..addOval(const Rect.fromLTRB(119.149, 65.908, 160.301, 79.184));

  // ── Effects ──
  static final Path legRightShadow = MascotEffects.dropShadow(legRight, const Offset(_soleShadowDx, _soleShadowDy));
  static final Path armRightRim = MascotEffects.topRim(armRight);
  static final Path armLeftRim = MascotEffects.topRim(armLeft);
  static final Path bodyShadow = MascotEffects.dropShadow(body, const Offset(0, _bodyShadowDy));
  static final Path bodyRim = MascotEffects.topRim(body);
  static final Path muzzleShadow = MascotEffects.dropShadow(muzzle, const Offset(_muzzleShadowDx, _muzzleShadowDy));
  static final Path browRidgeShadow = MascotEffects.dropShadow(browRidge, const Offset(0, _browRidgeShadowDy));
  static final Path browCenterShadow = MascotEffects.dropShadow(browCenter, const Offset(0, _browFoldShadowDy));
  static final Path browTopShadow = MascotEffects.dropShadow(browTop, const Offset(0, _browFoldShadowDy));
}

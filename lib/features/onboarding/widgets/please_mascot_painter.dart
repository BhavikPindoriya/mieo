import 'package:flutter/rendering.dart';

import '../../../core/theme/colors.dart';
import 'mascot_effects.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PLEASE MASCOT PAINTER
//
// Mieo asking nicely, paws pressed to his cheeks: Figma "Mieo Charachter"
// (62:12012) on the "I just want to ask you some Questions" frame, the still
// pose PleaseMascot shows until its Rive animation plays (or when it can't).
// Drawn from the vector geometry (0.001px precision) in a 227 × 236 box whose
// origin is the group's top-left corner. Every colour is an artwork colour,
// the same in both themes; left and right in the path names are as seen in
// the picture.
//
// Painted in Figma's layer order: ears, legs, body, belly, eyes, the cheeks
// his paws push up, the face (muzzle, mouth with the tongue clipped inside
// it, the smile's corners, nose), then the arms over everything. The hard
// Figma effects are paths (MascotEffects): the white rim on the body and the
// arms, the soft-light drop shadow of the body, and the solid drop shadows of
// the cheeks (upwards), the muzzle and the arms. Soft light blends with what
// is already on the canvas, so the scene behind must paint into the same
// layer: no RepaintBoundary between the scene and this painter.
// ─────────────────────────────────────────────────────────────────────────────
class PleaseMascotPainter extends CustomPainter {
  const PleaseMascotPainter();

  /// The artwork box at design size: the Figma group.
  static const Size artworkSize = Size(227.026, 235.973);

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
    fill(_MascotPaths.eyeLeftSpark, _white);
    fill(_MascotPaths.eyeRightShade, _black.withValues(alpha: _eyeShadeOpacity));
    fill(_MascotPaths.eyeRight, _black);
    fill(_MascotPaths.eyeRightGlint, _white);
    fill(_MascotPaths.eyeRightSpark, _white);

    // ── Cheeks, pushed up under the eyes ──
    fill(_MascotPaths.cheekRightShadow, ArtworkColors.mieoCheekShadow);
    fill(_MascotPaths.cheekRight, ArtworkColors.mieoFur);
    fill(_MascotPaths.cheekLeftShadow, ArtworkColors.mieoCheekShadow);
    fill(_MascotPaths.cheekLeft, ArtworkColors.mieoFur);

    // ── Muzzle, mouth and nose ──
    fill(_MascotPaths.muzzleShadow, _black.withValues(alpha: _muzzleShadowOpacity));
    fill(_MascotPaths.muzzle, _white.withValues(alpha: _muzzleOpacity));
    fill(_MascotPaths.mouth, _black);
    fill(_MascotPaths.tongue, ArtworkColors.mieoTongue);
    fill(_MascotPaths.dimpleLeft, _black);
    fill(_MascotPaths.dimpleRight, _black);
    fill(_MascotPaths.nose, _black);

    // ── Arms, each with its shadow and top rim ──
    fill(_MascotPaths.armLeftShadow, ArtworkColors.mieoArmShadow);
    fill(_MascotPaths.armLeft, ArtworkColors.mieoFur);
    fill(_MascotPaths.armLeftRim, _white.withValues(alpha: _rimOpacity));
    fill(_MascotPaths.armRightShadow, ArtworkColors.mieoArmShadow);
    fill(_MascotPaths.armRight, ArtworkColors.mieoFur);
    fill(_MascotPaths.armRightRim, _white.withValues(alpha: _rimOpacity));
  }

  @override
  bool shouldRepaint(PleaseMascotPainter oldDelegate) => false;
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
const double _bodyShadowDy = 4;
const double _bodyShadowOpacity = 0.35;
const double _cheekShadowDy = -2;
const double _muzzleShadowDx = 2.418;
const double _muzzleShadowDy = 2.902;
const double _muzzleShadowOpacity = 0.12;
const double _armLeftShadowDy = 3;
const double _armRightShadowDy = 2;
const double _rimOpacity = MascotEffects.rimOpacity;

/// The artwork's vectors, in the artwork box.
abstract final class _MascotPaths {
  /// Left ear.
  static final Path earLeft = Path()
    ..moveTo(58.448, 31.004)
    ..cubicTo(52.741, 25.296, 52.741, 16.042, 58.448, 10.335)
    ..cubicTo(64.156, 4.627, 73.41, 4.627, 79.117, 10.335)
    ..cubicTo(84.825, 16.042, 80.691, 21.162, 74.984, 26.87)
    ..cubicTo(69.276, 32.577, 64.156, 36.711, 58.448, 31.004)
    ..close();

  /// Inside of the left ear (black, 32%).
  static final Path earLeftInner = Path()
    ..moveTo(63.811, 29.663)
    ..cubicTo(59.955, 25.806, 59.955, 19.554, 63.811, 15.698)
    ..cubicTo(67.668, 11.841, 73.92, 11.841, 77.777, 15.698)
    ..cubicTo(81.633, 19.554, 78.84, 23.013, 74.983, 26.87)
    ..cubicTo(71.127, 30.726, 67.668, 33.519, 63.811, 29.663)
    ..close();

  /// Right ear.
  static final Path earRight = Path()
    ..moveTo(166.057, 31.004)
    ..cubicTo(171.765, 25.297, 171.765, 16.043, 166.057, 10.335)
    ..cubicTo(160.35, 4.628, 151.096, 4.628, 145.388, 10.335)
    ..cubicTo(139.681, 16.043, 143.815, 21.163, 149.522, 26.87)
    ..cubicTo(155.23, 32.578, 160.35, 36.712, 166.057, 31.004)
    ..close();

  /// Inside of the right ear (black, 32%).
  static final Path earRightInner = Path()
    ..moveTo(160.695, 29.664)
    ..cubicTo(164.551, 25.807, 164.551, 19.555, 160.695, 15.698)
    ..cubicTo(156.838, 11.842, 150.586, 11.842, 146.729, 15.698)
    ..cubicTo(142.873, 19.555, 145.666, 23.014, 149.522, 26.87)
    ..cubicTo(153.379, 30.727, 156.838, 33.52, 160.695, 29.664)
    ..close();

  /// Right leg, behind the body.
  static final Path legRight = Path()
    ..moveTo(108.799, 189.798)
    ..cubicTo(106.543, 171.302, 120.977, 155, 139.611, 155)
    ..cubicTo(158.244, 155, 172.678, 171.302, 170.422, 189.798)
    ..lineTo(167.839, 210.978)
    ..cubicTo(166.099, 225.246, 153.985, 235.973, 139.611, 235.973)
    ..cubicTo(125.236, 235.973, 113.122, 225.246, 111.382, 210.978)
    ..lineTo(108.799, 189.798)
    ..close();

  /// Left leg, behind the body.
  static final Path legLeft = Path()
    ..moveTo(44.357, 189.798)
    ..cubicTo(42.102, 171.302, 56.536, 155, 75.169, 155)
    ..cubicTo(93.802, 155, 108.237, 171.302, 105.981, 189.798)
    ..lineTo(103.398, 210.978)
    ..cubicTo(101.658, 225.246, 89.544, 235.973, 75.169, 235.973)
    ..cubicTo(60.795, 235.973, 48.68, 225.246, 46.94, 210.978)
    ..lineTo(44.357, 189.798)
    ..close();

  /// Head and body in one shape.
  static final Path body = Path()
    ..moveTo(204.909, 125.497)
    ..cubicTo(204.909, 171.708, 163.515, 209.169, 112.454, 209.169)
    ..cubicTo(61.393, 209.169, 20, 171.708, 20, 125.497)
    ..cubicTo(20, 79.286, 61.393, 7.903, 112.454, 7.903)
    ..cubicTo(163.515, 7.903, 204.909, 79.286, 204.909, 125.497)
    ..close();

  /// Belly patch (white, 39%).
  static final Path belly = Path()
    ..moveTo(152.144, 171.155)
    ..cubicTo(152.144, 186.722, 134.154, 195.657, 111.962, 195.657)
    ..cubicTo(89.77, 195.657, 71.78, 186.722, 71.78, 171.155)
    ..cubicTo(71.78, 166.642, 89.77, 167.92, 111.962, 167.92)
    ..cubicTo(134.154, 167.92, 152.144, 166.642, 152.144, 171.155)
    ..close();

  /// Muzzle (white, 50%).
  static final Path muzzle = Path()
    ..moveTo(154.277, 99.647)
    ..cubicTo(154.277, 122.035, 135.81, 140.184, 113.029, 140.184)
    ..cubicTo(90.247, 140.184, 71.78, 122.035, 71.78, 99.647)
    ..cubicTo(71.78, 87.926, 90.247, 80.444, 113.029, 80.444)
    ..cubicTo(135.81, 80.444, 154.277, 87.926, 154.277, 99.647)
    ..close();

  /// Open smile.
  static final Path mouth = Path()
    ..moveTo(137.209, 110.025)
    ..cubicTo(137.209, 112.062, 122.615, 128.396, 113.384, 128.396)
    ..cubicTo(104.154, 128.396, 89.56, 112.062, 89.56, 110.025)
    ..cubicTo(89.56, 111.501, 104.154, 116.63, 113.384, 116.63)
    ..cubicTo(122.615, 116.63, 137.209, 111.501, 137.209, 110.025)
    ..close();

  /// The smile's mask (Figma "Mask group"), a hair above the smile: the tongue shows only inside it.
  static final Path mouthMask = Path()
    ..moveTo(137.209, 110)
    ..cubicTo(137.209, 112.037, 122.615, 128.37, 113.384, 128.37)
    ..cubicTo(104.154, 128.37, 89.56, 112.037, 89.56, 110)
    ..cubicTo(89.56, 111.475, 104.154, 116.604, 113.384, 116.604)
    ..cubicTo(122.615, 116.604, 137.209, 111.475, 137.209, 110)
    ..close();

  /// Left corner of the smile.
  static final Path dimpleLeft = Path()
    ..moveTo(92.192, 103)
    ..cubicTo(92.807, 103.615, 93.493, 107.356, 90.425, 110.425)
    ..cubicTo(87.356, 113.493, 83.615, 112.807, 83, 112.192)
    ..cubicTo(83.445, 112.638, 86.521, 112.658, 89.59, 109.59)
    ..cubicTo(92.658, 106.521, 92.638, 103.445, 92.192, 103)
    ..close();

  /// Right corner of the smile.
  static final Path dimpleRight = Path()
    ..moveTo(145.258, 111.5)
    ..cubicTo(144.824, 112.253, 141.388, 113.884, 137.629, 111.714)
    ..cubicTo(133.871, 109.544, 133.565, 105.753, 134, 105)
    ..cubicTo(133.685, 105.545, 134.461, 108.522, 138.22, 110.692)
    ..cubicTo(141.978, 112.861, 144.943, 112.045, 145.258, 111.5)
    ..close();

  /// Nose.
  static final Path nose = Path()
    ..moveTo(135.114, 83.679)
    ..cubicTo(135.114, 93.797, 125.264, 102, 113.114, 102)
    ..cubicTo(100.964, 102, 91.114, 93.797, 91.114, 83.679)
    ..cubicTo(91.114, 78.381, 100.964, 75, 113.114, 75)
    ..cubicTo(125.264, 75, 135.114, 78.381, 135.114, 83.679)
    ..close();

  /// Left arm, the paw pressed to his cheek.
  static final Path armLeft = Path()
    ..moveTo(61.034, 111.389)
    ..cubicTo(92.935, 99.655, 69.629, 68.835, 43.23, 78.496)
    ..cubicTo(25.619, 84.25, -7.22, 122.037, 21.89, 143.743)
    ..cubicTo(40.804, 150.581, 37.575, 120.017, 61.034, 111.389)
    ..close();

  /// Right arm, the paw pressed to his cheek.
  static final Path armRight = Path()
    ..moveTo(162.97, 112.543)
    ..cubicTo(129.119, 109.466, 143.653, 73.664, 171.654, 76.164)
    ..cubicTo(190.153, 77.164, 231.654, 105.164, 209.153, 133.664)
    ..cubicTo(192.653, 145.164, 187.862, 114.806, 162.97, 112.543)
    ..close();

  /// Shade around the left eye (black, 20%).
  static final Path eyeLeftShade = Path()..addOval(const Rect.fromLTRB(73.629, 43.036, 104.21, 73.617));

  /// Left eye.
  static final Path eyeLeft = Path()..addOval(const Rect.fromLTRB(77.185, 50.148, 100.654, 73.617));

  /// Glint in the left eye.
  static final Path eyeLeftGlint = Path()..addOval(const Rect.fromLTRB(83, 55, 92, 64));

  /// Small spark in the left eye.
  static final Path eyeLeftSpark = Path()..addOval(const Rect.fromLTRB(94, 64, 97, 67));

  /// Shade around the right eye (black, 20%).
  static final Path eyeRightShade = Path()..addOval(const Rect.fromLTRB(121.847, 43.036, 152.428, 73.617));

  /// Right eye.
  static final Path eyeRight = Path()..addOval(const Rect.fromLTRB(125.403, 50.148, 148.873, 73.617));

  /// Glint in the right eye.
  static final Path eyeRightGlint = Path()..addOval(const Rect.fromLTRB(134, 55, 143, 64));

  /// Small spark in the right eye.
  static final Path eyeRightSpark = Path()..addOval(const Rect.fromLTRB(129, 63, 132, 66));

  /// Left cheek, pushed up by the paw.
  static final Path cheekLeft = Path()..addOval(const Rect.fromLTRB(69, 69, 105, 89));

  /// Right cheek, pushed up by the paw.
  static final Path cheekRight = Path()..addOval(const Rect.fromLTRB(120, 69, 156, 89));

  /// Tongue: an oval showing only inside the smile's mask.
  static final Path tongue = Path.combine(
    PathOperation.intersect,
    Path()..addOval(const Rect.fromLTRB(98, 122.975, 127, 143.975)),
    mouthMask,
  );

  // ── Effects ──
  static final Path bodyShadow = MascotEffects.dropShadow(body, const Offset(0, _bodyShadowDy));
  static final Path bodyRim = MascotEffects.topRim(body);
  static final Path cheekLeftShadow = MascotEffects.dropShadow(cheekLeft, const Offset(0, _cheekShadowDy));
  static final Path cheekRightShadow = MascotEffects.dropShadow(cheekRight, const Offset(0, _cheekShadowDy));
  static final Path muzzleShadow = MascotEffects.dropShadow(muzzle, const Offset(_muzzleShadowDx, _muzzleShadowDy));
  static final Path armLeftShadow = MascotEffects.dropShadow(armLeft, const Offset(0, _armLeftShadowDy));
  static final Path armLeftRim = MascotEffects.topRim(armLeft);
  static final Path armRightShadow = MascotEffects.dropShadow(armRight, const Offset(0, _armRightShadowDy));
  static final Path armRightRim = MascotEffects.topRim(armRight);
}

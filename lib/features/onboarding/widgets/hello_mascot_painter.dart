import 'package:flutter/rendering.dart';

import '../../../core/theme/colors.dart';
import 'mascot_effects.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HELLO MASCOT PAINTER
//
// Mieo waving hello, standing still: Figma "Mieo Charachter" (62:3842) on the
// "Hi! I’m Mieo" frame, the static pose HelloMascot shows until its Rive
// animation plays (or when it can't). Drawn from the vector geometry (0.001px precision) in a 289 × 239
// box whose origin is the group's top-left corner (the box also holds the
// soles' shadows). Every colour is an artwork colour, the same in both
// themes; left and right in the path names are as seen in the picture.
//
// Painted in Figma's layer order: ears, legs, arms, body, belly, eyes, then
// the face (muzzle, mouth with the tongue clipped inside it, nose). The hard
// Figma effects are paths (MascotEffects): the white rim on the arms and the
// body, the muzzle's drop shadow, and the soft-light drop shadows of the soles
// and the body. Soft light blends with what is already on the canvas, so the
// scene behind must paint into the same layer: no RepaintBoundary between the
// scene and this painter.
// ─────────────────────────────────────────────────────────────────────────────
class HelloMascotPainter extends CustomPainter {
  const HelloMascotPainter();

  /// The artwork box at design size.
  static const Size artworkSize = Size(289, 239);

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
    fill(_MascotPaths.legRightShadow, _black.withValues(alpha: _soleShadowOpacity), BlendMode.softLight);
    fill(_MascotPaths.legRight, ArtworkColors.mieoPaw);
    fill(_MascotPaths.legLeftShadow, _black.withValues(alpha: _soleShadowOpacity), BlendMode.softLight);
    fill(_MascotPaths.legLeft, ArtworkColors.mieoPaw);

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
    fill(_MascotPaths.tongue, ArtworkColors.mieoTongue);
    fill(_MascotPaths.nose, _black);
  }

  @override
  bool shouldRepaint(HelloMascotPainter oldDelegate) => false;
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
const double _rimOpacity = MascotEffects.rimOpacity;

/// The artwork's vectors, in the artwork box.
abstract final class _MascotPaths {
  /// Left ear.
  static final Path earLeft = Path()
    ..moveTo(104.335, 31.004)
    ..cubicTo(98.627, 25.296, 98.627, 16.042, 104.335, 10.335)
    ..cubicTo(110.042, 4.627, 119.296, 4.627, 125.004, 10.335)
    ..cubicTo(130.711, 16.042, 126.577, 21.162, 120.87, 26.87)
    ..cubicTo(115.162, 32.577, 110.042, 36.711, 104.335, 31.004)
    ..close();

  /// Inside of the left ear (black, 32%).
  static final Path earLeftInner = Path()
    ..moveTo(109.698, 29.663)
    ..cubicTo(105.841, 25.806, 105.841, 19.554, 109.698, 15.698)
    ..cubicTo(113.554, 11.841, 119.806, 11.841, 123.663, 15.698)
    ..cubicTo(127.519, 19.554, 124.726, 23.013, 120.87, 26.87)
    ..cubicTo(117.013, 30.726, 113.554, 33.519, 109.698, 29.663)
    ..close();

  /// Right ear.
  static final Path earRight = Path()
    ..moveTo(211.944, 31.004)
    ..cubicTo(217.651, 25.297, 217.651, 16.043, 211.944, 10.335)
    ..cubicTo(206.236, 4.628, 196.982, 4.628, 191.275, 10.335)
    ..cubicTo(185.567, 16.043, 189.701, 21.163, 195.408, 26.87)
    ..cubicTo(201.116, 32.578, 206.236, 36.712, 211.944, 31.004)
    ..close();

  /// Inside of the right ear (black, 32%).
  static final Path earRightInner = Path()
    ..moveTo(206.581, 29.664)
    ..cubicTo(210.437, 25.807, 210.437, 19.555, 206.581, 15.698)
    ..cubicTo(202.724, 11.842, 196.472, 11.842, 192.616, 15.698)
    ..cubicTo(188.759, 19.555, 191.552, 23.014, 195.409, 26.87)
    ..cubicTo(199.265, 30.727, 202.724, 33.52, 206.581, 29.664)
    ..close();

  /// Right leg, behind the body; casts a soft-light sole shadow.
  static final Path legRight = Path()
    ..moveTo(159.685, 189.798)
    ..cubicTo(157.429, 171.302, 171.864, 155, 190.497, 155)
    ..cubicTo(209.13, 155, 223.564, 171.302, 221.309, 189.798)
    ..lineTo(218.726, 210.978)
    ..cubicTo(216.986, 225.246, 204.871, 235.973, 190.497, 235.973)
    ..cubicTo(176.122, 235.973, 164.008, 225.246, 162.268, 210.978)
    ..lineTo(159.685, 189.798)
    ..close();

  /// Left leg, behind the body; casts a soft-light sole shadow.
  static final Path legLeft = Path()
    ..moveTo(95.244, 189.798)
    ..cubicTo(92.988, 171.302, 107.422, 155, 126.055, 155)
    ..cubicTo(144.689, 155, 159.123, 171.302, 156.867, 189.798)
    ..lineTo(154.284, 210.978)
    ..cubicTo(152.544, 225.246, 140.43, 235.973, 126.055, 235.973)
    ..cubicTo(111.681, 235.973, 99.567, 225.246, 97.827, 210.978)
    ..lineTo(95.244, 189.798)
    ..close();

  /// Right arm, hanging down beside the body.
  static final Path armRight = Path()
    ..moveTo(203.621, 87.936)
    ..cubicTo(219.507, 60.874, 245.058, 65.172, 256.331, 87.101)
    ..cubicTo(273.365, 120.235, 265.879, 174.005, 256.457, 176.664)
    ..cubicTo(225.324, 185.453, 213.077, 111.074, 203.621, 87.936)
    ..close();

  /// Left arm, raised to wave.
  static final Path armLeft = Path()
    ..moveTo(60.694, 124.609)
    ..cubicTo(69.137, 157.534, 119.881, 115.507, 108.278, 97.553)
    ..cubicTo(99.784, 84.409, 59.338, 18.392, 50.188, 21.876)
    ..cubicTo(19.957, 33.39, 54.484, 100.397, 60.694, 124.609)
    ..close();

  /// Head and body in one shape.
  static final Path body = Path()
    ..moveTo(250.909, 125.497)
    ..cubicTo(250.909, 171.708, 209.515, 209.169, 158.454, 209.169)
    ..cubicTo(107.393, 209.169, 66, 171.708, 66, 125.497)
    ..cubicTo(66, 79.286, 107.393, 7.903, 158.454, 7.903)
    ..cubicTo(209.515, 7.903, 250.909, 79.286, 250.909, 125.497)
    ..close();

  /// Belly patch (white, 39%).
  static final Path belly = Path()
    ..moveTo(198.364, 171.155)
    ..cubicTo(198.364, 186.722, 180.374, 195.657, 158.182, 195.657)
    ..cubicTo(135.99, 195.657, 118, 186.722, 118, 171.155)
    ..cubicTo(118, 166.642, 135.99, 167.92, 158.182, 167.92)
    ..cubicTo(180.374, 167.92, 198.364, 166.642, 198.364, 171.155)
    ..close();

  /// Shade around the left eye (black, 20%).
  static final Path eyeLeftShade = Path()..addOval(const Rect.fromLTRB(118.849, 43.036, 149.43, 73.617));

  /// Left eye.
  static final Path eyeLeft = Path()..addOval(const Rect.fromLTRB(122.405, 50.148, 145.874, 73.617));

  /// Glint in the left eye.
  static final Path eyeLeftGlint = Path()..addOval(const Rect.fromLTRB(131.917, 59.252, 138.318, 65.653));

  /// Shade around the right eye (black, 20%).
  static final Path eyeRightShade = Path()..addOval(const Rect.fromLTRB(167.068, 43.036, 197.649, 73.617));

  /// Right eye.
  static final Path eyeRight = Path()..addOval(const Rect.fromLTRB(170.624, 50.148, 194.093, 73.617));

  /// Glint in the right eye.
  static final Path eyeRightGlint = Path()..addOval(const Rect.fromLTRB(177.757, 59.252, 184.158, 65.653));

  /// Muzzle (white, 50%).
  static final Path muzzle = Path()
    ..moveTo(199.498, 99.647)
    ..cubicTo(199.498, 122.035, 181.03, 140.184, 158.249, 140.184)
    ..cubicTo(135.468, 140.184, 117, 122.035, 117, 99.647)
    ..cubicTo(117, 87.926, 135.468, 80.444, 158.249, 80.444)
    ..cubicTo(181.03, 80.444, 199.498, 87.926, 199.498, 99.647)
    ..close();

  /// Open smile.
  static final Path mouth = Path()
    ..moveTo(182.429, 111.025)
    ..cubicTo(182.429, 113.062, 167.835, 127.396, 158.605, 127.396)
    ..cubicTo(149.374, 127.396, 134.78, 113.062, 134.78, 111.025)
    ..cubicTo(134.78, 112.501, 149.374, 117.63, 158.605, 117.63)
    ..cubicTo(167.835, 117.63, 182.429, 112.501, 182.429, 111.025)
    ..close();

  /// Nose.
  static final Path nose = Path()
    ..moveTo(180.334, 83.679)
    ..cubicTo(180.334, 93.797, 170.484, 102, 158.334, 102)
    ..cubicTo(146.184, 102, 136.334, 93.797, 136.334, 83.679)
    ..cubicTo(136.334, 78.381, 146.184, 75, 158.334, 75)
    ..cubicTo(170.484, 75, 180.334, 78.381, 180.334, 83.679)
    ..close();

  /// Tongue: an oval showing only inside the mouth (Figma "Mask group").
  static final Path tongue = Path.combine(
    PathOperation.intersect,
    Path()..addOval(const Rect.fromLTRB(144.22, 124, 173.22, 145)),
    mouth,
  );

  // ── Effects ──
  static final Path legRightShadow = MascotEffects.dropShadow(legRight, const Offset(_soleShadowDx, _soleShadowDy));
  static final Path legLeftShadow = MascotEffects.dropShadow(legLeft, const Offset(_soleShadowDx, _soleShadowDy));
  static final Path armRightRim = MascotEffects.topRim(armRight);
  static final Path armLeftRim = MascotEffects.topRim(armLeft);
  static final Path bodyShadow = MascotEffects.dropShadow(body, const Offset(0, _bodyShadowDy));
  static final Path bodyRim = MascotEffects.topRim(body);
  static final Path muzzleShadow = MascotEffects.dropShadow(muzzle, const Offset(_muzzleShadowDx, _muzzleShadowDy));
}

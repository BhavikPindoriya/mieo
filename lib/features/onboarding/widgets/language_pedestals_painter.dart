import 'package:flutter/rendering.dart';

import '../../../core/theme/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LANGUAGE PEDESTALS PAINTER
//
// The three columns Mieo stands among: Figma "Steps Path" (31:142) on the
// Onboarding frame, painted in the coordinates of its "Body" frame (375 × 593).
// They run past the frame's bottom edge, where the panel clips them. Back to
// front:
//
//   1. a thin column (31:143)
//   2. the "Aa" pedestal Mieo stands on (31:147)
//   3. the "ગુજ" pedestal (31:152)
//
// Each is a column shaded Surface/Extra Dim/Primary → Surface/Sky/Top (top to
// bottom) under an oval top in Surface/Primary, which rests on a solid rim:
// its hard drop shadow in Shadow/Primary/Lighter. The two front tops carry a
// language sample lettered in Shades/primary/300 and /200 with a 16% black
// drop shadow. The lettering is artwork: drawn from the Figma vectors and not
// mirrored in RTL.
// ─────────────────────────────────────────────────────────────────────────────
class LanguagePedestalsPainter extends CustomPainter {
  const LanguagePedestalsPainter({
    required this.columnTop,
    required this.columnBottom,
    required this.top,
    required this.rim,
  });

  /// Column colour at its top edge. Figma `Surface/Extra Dim/Primary`.
  final Color columnTop;

  /// Column colour at its bottom edge. Figma `Surface/Sky/Top`.
  final Color columnBottom;

  /// Oval tops. Figma `Surface/Primary`.
  final Color top;

  /// The rim under each top. Figma `Shadow/Primary/Lighter`.
  final Color rim;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final pedestal in _pedestals) {
      // ── Column ──
      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [columnTop, columnBottom],
      ).createShader(pedestal.column);
      canvas.drawRect(pedestal.column, paint);
      paint.shader = null;

      // ── Top, on its rim ──
      canvas
        ..drawOval(pedestal.top.shift(Offset(0, pedestal.rimDepth)), paint..color = rim)
        ..drawOval(pedestal.top, paint..color = top);

      // ── Language sample ──
      if (pedestal.sample case final sample?) {
        canvas
          ..drawPath(sample.shadow, paint..color = _sampleShadow)
          ..drawPath(sample.lettering, paint..color = sample.color);
      }
    }
  }

  @override
  bool shouldRepaint(LanguagePedestalsPainter oldDelegate) =>
      oldDelegate.columnTop != columnTop ||
      oldDelegate.columnBottom != columnBottom ||
      oldDelegate.top != top ||
      oldDelegate.rim != rim;
}

/// Drop shadow of the lettering: black at 16%, hard light (the same as normal
/// blending for black).
final Color _sampleShadow = AppColors.neutral950.withValues(alpha: _sampleShadowOpacity);
const double _sampleShadowOpacity = 0.16;

/// One pedestal, in Body frame coordinates.
class _Pedestal {
  const _Pedestal({required this.column, required this.top, required this.rimDepth, this.sample});

  /// The column under the top.
  final Rect column;

  /// The oval top.
  final Rect top;

  /// How far the rim shows below the top (the drop shadow's offset).
  final double rimDepth;

  final _LanguageSample? sample;
}

/// Lettering on a pedestal top, with its drop shadow.
class _LanguageSample {
  _LanguageSample(this.lettering, this.color, {required double shadowDepth})
    : shadow = lettering.shift(Offset(0, shadowDepth));

  final Path lettering;
  final Color color;
  final Path shadow;
}

/// Back to front, as in Figma.
final List<_Pedestal> _pedestals = [
  // Thin column, 31:143.
  const _Pedestal(
    column: Rect.fromLTWH(109, 438.845, 30, 184),
    top: Rect.fromLTWH(109, 432.845, 30.525, 11.705),
    rimDepth: 2,
  ),
  // "Aa", 31:147.
  _Pedestal(
    column: const Rect.fromLTWH(156, 476, 133, 234),
    top: const Rect.fromLTWH(156, 449.845, 133, 51),
    rimDepth: 8,
    sample: _LanguageSample(_Lettering.latin, AppColors.primary300, shadowDepth: 1),
  ),
  // "ગુજ", 31:152.
  _Pedestal(
    column: const Rect.fromLTWH(74, 482.845, 65, 184),
    top: const Rect.fromLTWH(74, 470.845, 65.504, 25.118),
    rimDepth: 5,
    sample: _LanguageSample(_Lettering.gujarati, AppColors.primary200, shadowDepth: 0.5),
  ),
];

/// The sample lettering, outlined in Figma (vectors "Aa" 31:151 and "ગુજ"
/// 31:156), in Body frame coordinates.
abstract final class _Lettering {
  /// "Aa", on the pedestal Mieo stands on.
  static final Path latin = Path()
    ..moveTo(215.985, 475.811)
    ..lineTo(210.842, 467.67)
    ..lineTo(205.698, 475.811)
    ..lineTo(215.985, 475.811)
    ..close()
    ..moveTo(219.319, 481.108)
    ..lineTo(217.554, 478.315)
    ..lineTo(204.129, 478.315)
    ..lineTo(202.364, 481.108)
    ..cubicTo(202.088, 481.578, 201.659, 481.93, 201.078, 482.165)
    ..cubicTo(200.511, 482.4, 199.887, 482.517, 199.204, 482.517)
    ..cubicTo(198.346, 482.517, 197.598, 482.354, 196.959, 482.026)
    ..cubicTo(196.32, 481.699, 196, 481.28, 196, 480.768)
    ..cubicTo(196, 480.517, 196.087, 480.257, 196.262, 479.988)
    ..lineTo(205.175, 466.815)
    ..cubicTo(205.858, 465.741, 206.65, 465.015, 207.551, 464.638)
    ..cubicTo(208.466, 464.252, 209.563, 464.059, 210.842, 464.059)
    ..cubicTo(212.12, 464.059, 213.21, 464.252, 214.111, 464.638)
    ..cubicTo(215.026, 465.015, 215.832, 465.741, 216.53, 466.815)
    ..lineTo(225.443, 479.988)
    ..cubicTo(225.603, 480.257, 225.683, 480.512, 225.683, 480.756)
    ..cubicTo(225.683, 481.276, 225.364, 481.699, 224.724, 482.026)
    ..cubicTo(224.085, 482.354, 223.344, 482.517, 222.501, 482.517)
    ..cubicTo(222.254, 482.517, 222, 482.5, 221.738, 482.467)
    ..cubicTo(220.576, 482.307, 219.77, 481.855, 219.319, 481.108)
    ..close()
    ..moveTo(228.407, 479.032)
    ..cubicTo(228.407, 478.462, 228.516, 477.971, 228.734, 477.56)
    ..cubicTo(228.952, 477.14, 229.315, 476.784, 229.824, 476.49)
    ..cubicTo(230.332, 476.188, 230.928, 475.945, 231.611, 475.761)
    ..cubicTo(232.308, 475.576, 233.202, 475.429, 234.292, 475.32)
    ..cubicTo(235.396, 475.211, 236.558, 475.14, 237.779, 475.106)
    ..cubicTo(238.999, 475.064, 240.481, 475.043, 242.225, 475.043)
    ..lineTo(242.225, 474.137)
    ..cubicTo(242.225, 472.695, 240.99, 471.973, 238.52, 471.973)
    ..cubicTo(237.721, 471.973, 236.871, 472.032, 235.97, 472.149)
    ..cubicTo(235.069, 472.267, 234.401, 472.372, 233.965, 472.464)
    ..cubicTo(233.529, 472.548, 232.94, 472.678, 232.199, 472.854)
    ..cubicTo(232.127, 472.871, 232.047, 472.888, 231.96, 472.904)
    ..cubicTo(231.887, 472.913, 231.814, 472.921, 231.742, 472.929)
    ..cubicTo(231.669, 472.929, 231.597, 472.929, 231.524, 472.929)
    ..cubicTo(230.986, 472.929, 230.529, 472.795, 230.151, 472.527)
    ..cubicTo(229.773, 472.258, 229.584, 471.961, 229.584, 471.634)
    ..cubicTo(229.584, 471.424, 229.671, 471.235, 229.846, 471.067)
    ..cubicTo(230.02, 470.891, 230.289, 470.753, 230.652, 470.652)
    ..cubicTo(233.064, 469.989, 235.788, 469.658, 238.825, 469.658)
    ..cubicTo(240.205, 469.658, 241.433, 469.75, 242.508, 469.935)
    ..cubicTo(243.598, 470.111, 244.557, 470.392, 245.385, 470.778)
    ..cubicTo(246.227, 471.164, 246.874, 471.688, 247.324, 472.351)
    ..cubicTo(247.775, 473.005, 248, 473.785, 248, 474.691)
    ..lineTo(248, 480.743)
    ..cubicTo(248, 481.297, 247.724, 481.729, 247.172, 482.039)
    ..cubicTo(246.62, 482.341, 245.973, 482.492, 245.232, 482.492)
    ..cubicTo(244.753, 482.492, 244.295, 482.425, 243.859, 482.291)
    ..cubicTo(242.9, 481.989, 242.421, 481.469, 242.421, 480.731)
    ..lineTo(242.421, 480.378)
    ..cubicTo(241.927, 481.108, 241.099, 481.666, 239.936, 482.052)
    ..cubicTo(238.788, 482.438, 237.43, 482.63, 235.861, 482.63)
    ..cubicTo(233.696, 482.63, 231.909, 482.307, 230.5, 481.662)
    ..cubicTo(229.105, 481.016, 228.407, 480.139, 228.407, 479.032)
    ..close()
    ..moveTo(236.863, 480.554)
    ..cubicTo(237.517, 480.554, 238.156, 480.475, 238.781, 480.315)
    ..cubicTo(239.421, 480.148, 239.994, 479.921, 240.503, 479.636)
    ..cubicTo(241.011, 479.342, 241.418, 478.982, 241.723, 478.554)
    ..cubicTo(242.043, 478.118, 242.203, 477.656, 242.203, 477.17)
    ..lineTo(242.203, 476.755)
    ..cubicTo(241.258, 476.755, 240.467, 476.759, 239.827, 476.767)
    ..cubicTo(239.203, 476.775, 238.563, 476.796, 237.909, 476.83)
    ..cubicTo(237.27, 476.864, 236.747, 476.91, 236.34, 476.968)
    ..cubicTo(235.948, 477.027, 235.57, 477.107, 235.207, 477.207)
    ..cubicTo(234.844, 477.3, 234.56, 477.417, 234.357, 477.56)
    ..cubicTo(234.168, 477.702, 234.016, 477.874, 233.899, 478.076)
    ..cubicTo(233.798, 478.269, 233.747, 478.495, 233.747, 478.755)
    ..cubicTo(233.747, 479.317, 234.023, 479.757, 234.575, 480.076)
    ..cubicTo(235.142, 480.395, 235.904, 480.554, 236.863, 480.554)
    ..close();

  /// "ગુજ" (Gujarati), on the front-left pedestal.
  static final Path gujarati = Path()
    ..moveTo(95.925, 483.265)
    ..cubicTo(95.439, 483.265, 94.965, 483.233, 94.505, 483.168)
    ..cubicTo(94.058, 483.099, 93.624, 482.992, 93.203, 482.847)
    ..cubicTo(92.796, 482.697, 92.394, 482.502, 92, 482.261)
    ..lineTo(93.243, 481.916)
    ..cubicTo(93.69, 482.189, 94.11, 482.384, 94.505, 482.502)
    ..cubicTo(94.899, 482.62, 95.346, 482.679, 95.846, 482.679)
    ..cubicTo(96.385, 482.679, 96.826, 482.596, 97.168, 482.43)
    ..cubicTo(97.51, 482.264, 97.68, 481.991, 97.68, 481.611)
    ..cubicTo(97.68, 481.199, 97.483, 480.902, 97.089, 480.72)
    ..cubicTo(96.707, 480.533, 96.175, 480.439, 95.491, 480.439)
    ..cubicTo(95.084, 480.439, 94.696, 480.46, 94.327, 480.503)
    ..cubicTo(93.959, 480.541, 93.631, 480.592, 93.341, 480.656)
    ..lineTo(92.848, 480.118)
    ..cubicTo(93.282, 480.027, 93.736, 479.96, 94.209, 479.917)
    ..cubicTo(94.696, 479.874, 95.149, 479.853, 95.57, 479.853)
    ..cubicTo(96.306, 479.853, 96.951, 479.917, 97.503, 480.046)
    ..cubicTo(98.055, 480.169, 98.489, 480.361, 98.805, 480.624)
    ..cubicTo(99.12, 480.881, 99.278, 481.212, 99.278, 481.619)
    ..cubicTo(99.278, 481.962, 99.173, 482.24, 98.963, 482.454)
    ..cubicTo(98.765, 482.668, 98.502, 482.834, 98.174, 482.952)
    ..cubicTo(97.845, 483.069, 97.483, 483.152, 97.089, 483.201)
    ..cubicTo(96.694, 483.243, 96.306, 483.265, 95.925, 483.265)
    ..close()
    ..moveTo(101.231, 485.039)
    ..lineTo(101.231, 479.853)
    ..lineTo(102.809, 479.941)
    ..lineTo(102.809, 485.039)
    ..lineTo(101.231, 485.039)
    ..close()
    ..moveTo(101.493, 486.845)
    ..cubicTo(100.638, 486.845, 99.863, 486.789, 99.166, 486.676)
    ..cubicTo(98.469, 486.569, 97.831, 486.414, 97.252, 486.211)
    ..cubicTo(96.674, 486.007, 96.122, 485.769, 95.596, 485.496)
    ..lineTo(96.818, 485.151)
    ..cubicTo(97.331, 485.408, 97.824, 485.619, 98.298, 485.785)
    ..cubicTo(98.758, 485.951, 99.245, 486.072, 99.757, 486.147)
    ..cubicTo(100.27, 486.227, 100.849, 486.267, 101.493, 486.267)
    ..cubicTo(102.229, 486.267, 102.762, 486.219, 103.091, 486.123)
    ..cubicTo(103.406, 486.032, 103.564, 485.895, 103.564, 485.713)
    ..cubicTo(103.564, 485.553, 103.419, 485.432, 103.13, 485.352)
    ..cubicTo(102.828, 485.277, 102.446, 485.239, 101.986, 485.239)
    ..cubicTo(101.631, 485.239, 101.316, 485.253, 101.039, 485.28)
    ..cubicTo(100.763, 485.312, 100.487, 485.357, 100.211, 485.416)
    ..lineTo(99.698, 484.878)
    ..cubicTo(100.04, 484.819, 100.402, 484.774, 100.783, 484.742)
    ..cubicTo(101.151, 484.71, 101.519, 484.694, 101.888, 484.694)
    ..cubicTo(102.9, 484.694, 103.676, 484.793, 104.215, 484.991)
    ..cubicTo(104.754, 485.189, 105.024, 485.451, 105.024, 485.777)
    ..cubicTo(105.024, 486.088, 104.728, 486.342, 104.136, 486.54)
    ..cubicTo(103.544, 486.743, 102.663, 486.845, 101.493, 486.845)
    ..close()
    ..moveTo(115.517, 484.774)
    ..cubicTo(114.675, 484.774, 113.998, 484.71, 113.485, 484.581)
    ..cubicTo(112.972, 484.447, 112.598, 484.276, 112.361, 484.067)
    ..cubicTo(112.137, 483.859, 112.026, 483.639, 112.026, 483.409)
    ..cubicTo(112.026, 483.126, 112.151, 482.861, 112.4, 482.614)
    ..cubicTo(112.663, 482.368, 113.051, 482.13, 113.564, 481.9)
    ..cubicTo(114.09, 481.665, 114.741, 481.426, 115.517, 481.186)
    ..cubicTo(115.99, 481.036, 116.457, 480.894, 116.917, 480.76)
    ..cubicTo(117.377, 480.621, 117.864, 480.476, 118.377, 480.327)
    ..cubicTo(118.903, 480.177, 119.481, 480.016, 120.112, 479.845)
    ..lineTo(121, 480.367)
    ..cubicTo(120.369, 480.533, 119.784, 480.688, 119.245, 480.832)
    ..cubicTo(118.705, 480.977, 118.186, 481.119, 117.686, 481.258)
    ..cubicTo(117.2, 481.397, 116.713, 481.541, 116.227, 481.691)
    ..cubicTo(115.49, 481.911, 114.938, 482.119, 114.57, 482.317)
    ..cubicTo(114.202, 482.515, 113.952, 482.703, 113.82, 482.879)
    ..cubicTo(113.702, 483.056, 113.643, 483.23, 113.643, 483.401)
    ..cubicTo(113.643, 483.647, 113.788, 483.84, 114.077, 483.979)
    ..cubicTo(114.366, 484.118, 114.833, 484.188, 115.477, 484.188)
    ..cubicTo(116.03, 484.188, 116.47, 484.121, 116.799, 483.987)
    ..cubicTo(117.128, 483.848, 117.292, 483.629, 117.292, 483.329)
    ..cubicTo(117.292, 482.992, 117.141, 482.681, 116.838, 482.398)
    ..cubicTo(116.549, 482.114, 116.128, 481.849, 115.576, 481.603)
    ..cubicTo(115.05, 481.351, 114.471, 481.137, 113.84, 480.961)
    ..cubicTo(113.209, 480.784, 112.519, 480.65, 111.769, 480.559)
    ..cubicTo(111.02, 480.463, 110.198, 480.415, 109.304, 480.415)
    ..cubicTo(108.449, 480.415, 107.838, 480.501, 107.469, 480.672)
    ..cubicTo(107.101, 480.838, 106.917, 481.03, 106.917, 481.25)
    ..cubicTo(106.917, 481.48, 107.062, 481.654, 107.351, 481.772)
    ..cubicTo(107.64, 481.884, 108.009, 481.94, 108.456, 481.94)
    ..cubicTo(109.06, 481.94, 109.488, 481.876, 109.738, 481.748)
    ..cubicTo(110.001, 481.619, 110.132, 481.44, 110.132, 481.21)
    ..cubicTo(110.132, 481.038, 110.06, 480.878, 109.915, 480.728)
    ..cubicTo(109.784, 480.578, 109.593, 480.444, 109.343, 480.327)
    ..lineTo(110.744, 480.238)
    ..cubicTo(110.993, 480.356, 111.217, 480.498, 111.414, 480.664)
    ..cubicTo(111.611, 480.83, 111.71, 481.028, 111.71, 481.258)
    ..cubicTo(111.71, 481.408, 111.651, 481.56, 111.533, 481.715)
    ..cubicTo(111.427, 481.865, 111.25, 482.002, 111, 482.125)
    ..cubicTo(110.75, 482.243, 110.415, 482.339, 109.994, 482.414)
    ..cubicTo(109.586, 482.489, 109.074, 482.526, 108.456, 482.526)
    ..cubicTo(107.785, 482.526, 107.22, 482.47, 106.759, 482.358)
    ..cubicTo(106.299, 482.24, 105.944, 482.085, 105.694, 481.892)
    ..cubicTo(105.458, 481.694, 105.339, 481.477, 105.339, 481.242)
    ..cubicTo(105.339, 480.99, 105.497, 480.76, 105.813, 480.551)
    ..cubicTo(106.128, 480.337, 106.588, 480.169, 107.193, 480.046)
    ..cubicTo(107.798, 479.917, 108.541, 479.853, 109.422, 479.853)
    ..cubicTo(110.908, 479.853, 112.236, 479.971, 113.406, 480.206)
    ..cubicTo(114.59, 480.436, 115.661, 480.765, 116.621, 481.194)
    ..cubicTo(117.318, 481.509, 117.87, 481.847, 118.278, 482.205)
    ..cubicTo(118.699, 482.564, 118.909, 482.941, 118.909, 483.337)
    ..cubicTo(118.909, 483.792, 118.6, 484.145, 117.982, 484.397)
    ..cubicTo(117.377, 484.648, 116.556, 484.774, 115.517, 484.774)
    ..close();
}

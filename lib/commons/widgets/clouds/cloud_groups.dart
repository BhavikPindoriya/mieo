import 'dart:math' as math;

import 'cloud_shapes.dart';
import 'clouds_painter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CLOUD GROUPS
//
// Cloud arrangements several screens share, as CloudPlacements in the Figma
// frame's coordinates (375 wide), ready for SkyBackdrop.
// ─────────────────────────────────────────────────────────────────────────────
class CloudGroups {
  CloudGroups._();

  /// Figma "Cloudes" over the form screens — Login (364:14962), Create
  /// Profile (366:15264), Continue with Email — with the group's top-left
  /// corner at (-85, -140). Of its six clouds only three reach into the
  /// frame there; Save your journey shows more of them by placing the same
  /// group at (-85, -60).
  static final List<CloudPlacement> formHeader = _header(-85, -140);

  /// Figma "Cloudes" over the New Account Progress meadow ("Hi! I’m Mieo"
  /// 62:3664, "Ask you some Questions" 62:8084…), in the coordinates of the
  /// scenes' 375 × 716 "BOdy" frame. The small cloud is cloud 5 at 83 of its
  /// 172.713 width.
  static final List<CloudPlacement> meadow = [
    CloudPlacement(CloudShapes.cloud1, -100, 178),
    CloudPlacement(CloudShapes.cloud2, 272, 302),
    CloudPlacement(CloudShapes.cloud4, -82, 312),
    CloudPlacement(CloudShapes.cloud5, 272, 206),
    CloudPlacement(CloudShapes.cloud5, 66, 289, scale: _meadowSmallCloudScale),
    CloudPlacement(CloudShapes.cloud6, 146, 151),
  ];

  static const double _meadowSmallCloudScale = 83 / 172.713;

  /// Figma "Cloudes" behind the New Account Progress question screens
  /// (native language 62:8746, learning language, level, daily goal), in the
  /// coordinates of their "Heading View": its top is the top bar's, just
  /// under the status bar.
  static final List<CloudPlacement> setupHeader = [
    CloudPlacement(CloudShapes.cloud1, -101, 87),
    CloudPlacement(CloudShapes.cloud2, 231, 221),
    CloudPlacement(CloudShapes.cloud5, 271, 115),
    CloudPlacement(CloudShapes.cloud6, 145, 60),
  ];

  /// The two tilted clouds Mieo perches on in the question screens' header,
  /// relative to the top-left corner of his artwork: the "Upper Cloud"
  /// (cloud 4, 62:8824) behind him and the "Lover Cloud" (cloud 9, 62:8816)
  /// over his feet. Figma turns them 10.348° and 4.6° anticlockwise.
  static final CloudPlacement perchBack = CloudPlacement(CloudShapes.cloud4, -9, 83, rotation: -10.348 * _degree);
  static final CloudPlacement perchFront = CloudPlacement(CloudShapes.cloud9, 16, 129.474, rotation: -4.6 * _degree);

  /// One degree, in radians.
  static const double _degree = math.pi / 180;

  /// The six clouds, in Figma paint order, relative to the group's corner.
  static List<CloudPlacement> _header(double x, double y) => [
    CloudPlacement(CloudShapes.cloud1, x, y + 27),
    CloudPlacement(CloudShapes.cloud1, x + 240, y + 117),
    CloudPlacement(CloudShapes.cloud2, x + 12, y + 161),
    CloudPlacement(CloudShapes.cloud5, x + 372, y + 55),
    CloudPlacement(CloudShapes.cloud6, x + 246, y),
    CloudPlacement(CloudShapes.cloud6, x + 366, y + 250),
  ];
}

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../../core/theme/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CLOUDS PAINTER
//
// Draws the flat three-tone clouds of the Figma sky scenes. A cloud
// (CloudShape, see cloud_shapes.dart) is a stack of filled vector layers,
// painted in order:
//
//   body  — the whole silhouette                  Cloud Color/1 → cloud.layer1
//   shade — the lower half of the body            Cloud Color/2 → cloud.layer2
//   base  — the rim along the bottom, small curls Cloud Color/3 → cloud.layer3
//
// A scene lists its clouds as CloudPlacements: which shape, where its box's
// top-left corner sits in the painter's coordinates (clouds may reach past the
// painter's size), and optionally a smaller scale and a tilt. The shapes are
// artwork: the same in both themes and not mirrored in RTL. Only the three
// colours follow the theme (and cross-fade with it).
// ─────────────────────────────────────────────────────────────────────────────

/// Which Figma cloud colour a [CloudLayer] is filled with.
enum CloudTone {
  body,
  shade,
  base;

  Color resolve(AppCloudColors colors) => switch (this) {
    CloudTone.body => colors.layer1,
    CloudTone.shade => colors.layer2,
    CloudTone.base => colors.layer3,
  };
}

/// One filled vector of a cloud, in the cloud's own coordinates.
@immutable
class CloudLayer {
  const CloudLayer(this.tone, this.path);

  final CloudTone tone;
  final Path path;
}

/// A cloud design: its layers in paint order.
@immutable
class CloudShape {
  const CloudShape(this.layers);

  final List<CloudLayer> layers;
}

/// A cloud in a scene: [shape] with its box's top-left corner at ([x], [y]),
/// drawn at [scale] times its design size (a smaller copy of a shape) and
/// turned by [rotation] radians (clockwise) around that corner, like a
/// rotated Figma group whose x and y are its own corner.
@immutable
class CloudPlacement {
  const CloudPlacement(this.shape, this.x, this.y, {this.scale = 1, this.rotation = 0});

  final CloudShape shape;
  final double x;
  final double y;
  final double scale;
  final double rotation;
}

/// Paints [clouds] in order, each layer filled with its tone from [colors].
class CloudsPainter extends CustomPainter {
  const CloudsPainter({required this.clouds, required this.colors});

  final List<CloudPlacement> clouds;
  final AppCloudColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final cloud in clouds) {
      canvas
        ..save()
        ..translate(cloud.x, cloud.y)
        ..rotate(cloud.rotation)
        ..scale(cloud.scale);
      for (final layer in cloud.shape.layers) {
        paint.color = layer.tone.resolve(colors);
        canvas.drawPath(layer.path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CloudsPainter oldDelegate) =>
      oldDelegate.clouds != clouds ||
      oldDelegate.colors.layer1 != colors.layer1 ||
      oldDelegate.colors.layer2 != colors.layer2 ||
      oldDelegate.colors.layer3 != colors.layer3;
}

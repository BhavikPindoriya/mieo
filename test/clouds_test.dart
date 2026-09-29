import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mieo_ui8/commons/widgets/clouds/cloud_shapes.dart';
import 'package:mieo_ui8/commons/widgets/clouds/clouds_painter.dart';
import 'package:mieo_ui8/core/theme/colors.dart';

// The shared cloud library: the nine Figma cloud designs (used by the Splash,
// Onboarding and setup question skies) and the painter that places, tilts and
// fills them with the Cloud Color tokens.
void main() {
  final shapes = [
    CloudShapes.cloud1,
    CloudShapes.cloud2,
    CloudShapes.cloud3,
    CloudShapes.cloud4,
    CloudShapes.cloud5,
    CloudShapes.cloud6,
    CloudShapes.cloud7,
    CloudShapes.cloud8,
    CloudShapes.cloud9,
  ];

  // The Figma group size of each design, in the same order.
  const boxes = [
    Size(200.388, 96.511),
    Size(205.784, 72.252),
    Size(185.568, 67.113),
    Size(146.182, 96.617),
    Size(172.713, 53.273),
    Size(143.853, 54.754),
    Size(88.989, 68.766),
    Size(118.67, 73.102),
    Size(117.546, 35.659),
  ];

  test('are the 46 Figma vectors of the nine clouds, each body first, then its shade', () {
    expect(shapes.expand((shape) => shape.layers), hasLength(46));
    for (final shape in shapes) {
      expect(shape.layers[0].tone, CloudTone.body);
      expect(shape.layers[1].tone, CloudTone.shade);
    }
  });

  test('each design is drawn in its own box, origin at the top-left corner', () {
    // Path bounds may include Bézier control points, which reach up to ~7px
    // past the drawn outline.
    const overshoot = 8.0;
    const rounding = 0.01;
    for (final (index, shape) in shapes.indexed) {
      final box = boxes[index];
      final bounds = shape.layers.map((layer) => layer.path.getBounds()).reduce((a, b) => a.expandToInclude(b));
      final reason = 'cloud${index + 1}';
      expect(bounds.left, inInclusiveRange(-overshoot, rounding), reason: reason);
      expect(bounds.top, inInclusiveRange(-overshoot, rounding), reason: reason);
      expect(bounds.right, inInclusiveRange(box.width - rounding, box.width + overshoot), reason: reason);
      expect(bounds.bottom, inInclusiveRange(box.height - rounding, box.height + overshoot), reason: reason);
    }
  });

  test('the painter repaints only when the placements or a cloud colour change', () {
    final clouds = [CloudPlacement(CloudShapes.cloud1, 0, 0)];
    final light = CloudsPainter(clouds: clouds, colors: AppColorTokens.light.cloud);
    expect(light.shouldRepaint(CloudsPainter(clouds: clouds, colors: AppColorTokens.light.cloud)), isFalse);
    expect(light.shouldRepaint(CloudsPainter(clouds: clouds, colors: AppColorTokens.dark.cloud)), isTrue);
    expect(light.shouldRepaint(CloudsPainter(clouds: [...clouds], colors: AppColorTokens.light.cloud)), isTrue);
  });

  test('tones resolve to their Figma Cloud Color tokens', () {
    const colors = AppCloudColors(layer1: Color(0xFF000001), layer2: Color(0xFF000002), layer3: Color(0xFF000003));
    expect(CloudTone.body.resolve(colors), colors.layer1);
    expect(CloudTone.shade.resolve(colors), colors.layer2);
    expect(CloudTone.base.resolve(colors), colors.layer3);
  });
}

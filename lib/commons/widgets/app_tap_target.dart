import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../core/constants/theme_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP TAP TARGET
//
// Makes a small tappable child (an inline text link, a 24 icon inside a
// field) easy to hit without moving anything. The child is laid out at its
// own size and placed at [alignment] like Align does, and taps anywhere in a
// [minSize] square centred on it reach it too: a tap in that margin lands on
// the child's centre, the way Material pads small buttons — except that here
// the margin takes no layout space, so the Figma spacing stays exact.
//
// The margin only receives taps that reach this widget, so it should sit
// directly in a Row, Column or Stack (they hand every position inside
// themselves to each child), not inside a box that tests its own bounds
// first. Semantics keep the child's own bounds.
// ─────────────────────────────────────────────────────────────────────────────
class AppTapTarget extends SingleChildRenderObjectWidget {
  const AppTapTarget({
    super.key,
    required Widget super.child,
    this.alignment = AlignmentDirectional.center,
    this.minSize = ThemeConstants.minTapTarget,
  });

  final AlignmentGeometry alignment;

  /// Side of the square, centred on the child, that accepts its taps.
  final double minSize;

  @override
  RenderTapTarget createRenderObject(BuildContext context) =>
      RenderTapTarget(alignment: alignment, textDirection: Directionality.maybeOf(context), minSize: minSize);

  @override
  void updateRenderObject(BuildContext context, RenderTapTarget renderObject) {
    renderObject
      ..alignment = alignment
      ..textDirection = Directionality.maybeOf(context)
      ..minSize = minSize;
  }
}

/// The render object of [AppTapTarget]: an aligning box whose child also
/// takes taps in a [minSize] square around it.
class RenderTapTarget extends RenderPositionedBox {
  RenderTapTarget({required super.alignment, required super.textDirection, required this.minSize});

  /// Only changes hit testing, so setting it needs no layout or paint.
  double minSize;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null) {
      return false;
    }
    final offset = (child.parentData! as BoxParentData).offset;
    final bounds = offset & child.size;
    if (bounds.contains(position)) {
      return result.addWithPaintOffset(
        offset: offset,
        position: position,
        hitTest: (result, transformed) => child.hitTest(result, position: transformed),
      );
    }
    final area = Rect.fromCenter(
      center: bounds.center,
      width: math.max(bounds.width, minSize),
      height: math.max(bounds.height, minSize),
    );
    if (!area.contains(position)) {
      return false;
    }
    // Every position in the margin maps to the child's centre, so the child's
    // gesture detector accepts the tap.
    final center = child.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) => child.hitTest(result, position: position),
    );
  }
}

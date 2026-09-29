import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../core/theme/colors.dart';
import '../../utils/extensions/context_extensions.dart';
import 'clouds/clouds_painter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SKY BACKDROP
//
// The full-bleed sky behind a screen (the form screens' frame fill): the
// Surface/Sky gradient over Surface/Body, fading from Sky/Top at the top edge
// to Sky/Bottom 42.4% of the way down the screen (Figma y 344 of 812), with
// Sky/Bottom below that. In dark mode the sky is a faint white glow over the
// dark page. [clouds] are painted over it in the Figma frame's coordinates,
// moved down by [cloudsTop] (a group laid out from under the status bar);
// on a screen wider or narrower than the 375 frame they stay centred with
// it, at their design size, and they don't mirror in RTL (artwork).
//
// The gradient follows the screen height, not the backdrop's, so it stays
// put when the keyboard shortens the page.
// ─────────────────────────────────────────────────────────────────────────────
class SkyBackdrop extends StatelessWidget {
  const SkyBackdrop({super.key, required this.clouds, this.cloudsTop = 0, required this.child});

  final List<CloudPlacement> clouds;

  /// Screen y of the clouds' y 0.
  final double cloudsTop;

  /// The page content, drawn over the sky.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CustomPaint(
      painter: _SkyPainter(
        surface: colors.surface,
        cloudColors: colors.cloud,
        clouds: clouds,
        cloudsTop: cloudsTop,
        skyHeight: MediaQuery.sizeOf(context).height * _skyExtent,
      ),
      child: child,
    );
  }
}

/// Where the fade ends, as a fraction of the screen height: Figma's gradient
/// transform scales the frame height by 2.36, so the fade ends at 1 / 2.36.
const double _skyExtent = 1 / 2.36;

/// Width of the Figma frame the cloud positions are measured in.
const double _frameWidth = 375;

class _SkyPainter extends CustomPainter {
  const _SkyPainter({
    required this.surface,
    required this.cloudColors,
    required this.clouds,
    required this.cloudsTop,
    required this.skyHeight,
  });

  final AppSurfaceColors surface;
  final AppCloudColors cloudColors;
  final List<CloudPlacement> clouds;
  final double cloudsTop;
  final double skyHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final page = Offset.zero & size;
    canvas
      ..drawRect(page, Paint()..color = surface.body)
      ..drawRect(
        page,
        Paint()..shader = ui.Gradient.linear(Offset.zero, Offset(0, skyHeight), [surface.skyTop, surface.skyBottom]),
      )
      ..save()
      ..clipRect(page)
      ..translate((size.width - _frameWidth) / 2, cloudsTop);
    CloudsPainter(clouds: clouds, colors: cloudColors).paint(canvas, size);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SkyPainter oldDelegate) =>
      oldDelegate.skyHeight != skyHeight ||
      oldDelegate.clouds != clouds ||
      oldDelegate.cloudsTop != cloudsTop ||
      oldDelegate.surface.body != surface.body ||
      oldDelegate.surface.skyTop != surface.skyTop ||
      oldDelegate.surface.skyBottom != surface.skyBottom ||
      oldDelegate.cloudColors.layer1 != cloudColors.layer1 ||
      oldDelegate.cloudColors.layer2 != cloudColors.layer2 ||
      oldDelegate.cloudColors.layer3 != cloudColors.layer3;
}

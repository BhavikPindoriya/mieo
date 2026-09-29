import 'package:flutter/widgets.dart';

import '../../../commons/widgets/clouds/cloud_groups.dart';
import '../../../commons/widgets/clouds/clouds_painter.dart';
import '../../../core/theme/colors.dart';
import '../../../utils/extensions/context_extensions.dart';
import 'notebook_mascot_painter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PERCHED MIEO
//
// Mieo taking notes on a cloud, the picture beside the question in the header
// of the setup question screens (Figma "Mieo Charachter" with its "Upper
// Cloud" and "Lover Cloud"). Painted in Figma's order: the tilted cloud
// behind him, Mieo (NotebookMascotPainter), then the low cloud over his feet.
//
// The box is Mieo's artwork at design size; the clouds reach past it on every
// side but the top, as they do in Figma, so the box stays the size the header
// lays out. One painter draws the three layers into the same picture, so
// Mieo's soft-light shadows blend with the cloud behind him. Artwork: the same
// in both themes except the cloud tones and the two Figma-bound fills of the
// notebook and pencil lead, and not mirrored in RTL.
// ─────────────────────────────────────────────────────────────────────────────
class PerchedMieo extends StatelessWidget {
  const PerchedMieo({super.key});

  /// The box Mieo is laid out in.
  static const Size size = NotebookMascotPainter.artworkSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CustomPaint(
      size: size,
      painter: _PerchedMieoPainter(
        clouds: colors.cloud,
        notebook: colors.surface.primary,
        lead: colors.surface.neutral,
      ),
    );
  }
}

/// The back cloud, Mieo and the front cloud, in the artwork's coordinates.
class _PerchedMieoPainter extends CustomPainter {
  const _PerchedMieoPainter({required this.clouds, required this.notebook, required this.lead});

  final AppCloudColors clouds;
  final Color notebook;
  final Color lead;

  static final List<CloudPlacement> _back = [CloudGroups.perchBack];
  static final List<CloudPlacement> _front = [CloudGroups.perchFront];

  @override
  void paint(Canvas canvas, Size size) {
    CloudsPainter(clouds: _back, colors: clouds).paint(canvas, size);
    NotebookMascotPainter(notebookColor: notebook, leadColor: lead).paint(canvas, size);
    CloudsPainter(clouds: _front, colors: clouds).paint(canvas, size);
  }

  @override
  bool shouldRepaint(_PerchedMieoPainter oldDelegate) =>
      oldDelegate.notebook != notebook ||
      oldDelegate.lead != lead ||
      oldDelegate.clouds.layer1 != clouds.layer1 ||
      oldDelegate.clouds.layer2 != clouds.layer2 ||
      oldDelegate.clouds.layer3 != clouds.layer3;
}

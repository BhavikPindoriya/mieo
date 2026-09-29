import 'package:flutter/widgets.dart';

import '../../../core/constants/assets_constants.dart';
import 'please_mascot_painter.dart';
import 'rive_mascot.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PLEASE MASCOT
//
// Mieo asking nicely on the "I just want to ask you some Questions" screen:
// the Rive file AssetsConstants.mascotPlease (artboard "MieoPlease", state
// machine "PleaseSM": he sways from side to side with his paws on his cheeks
// and blinks, on a loop), played by RiveMascot. The artboard (artboardSize)
// holds the Figma "Mieo Charachter" group (227 × 236) at (stillLeft,
// stillTop), with room around it for the animation, so a box placed that far
// above and before the Figma group puts every part of him on its Figma pixel.
// The still pose (PleaseMascotPainter) takes the Figma group's spot inside the
// box.
// ─────────────────────────────────────────────────────────────────────────────
class PleaseMascot extends StatelessWidget {
  const PleaseMascot({super.key});

  /// The Rive artboard.
  static const Size artboardSize = Size(250, 288);

  /// Where the Figma group (the still pose) sits inside the artboard.
  static const double stillLeft = 12;
  static const double stillTop = 44;

  static const String _artboard = 'MieoPlease';
  static const String _stateMachine = 'PleaseSM';

  @override
  Widget build(BuildContext context) {
    return RiveMascot(
      asset: AssetsConstants.mascotPlease,
      artboard: _artboard,
      stateMachine: _stateMachine,
      still: const PleaseMascotPainter(),
      stillRect: const Offset(stillLeft, stillTop) & PleaseMascotPainter.artworkSize,
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../../core/constants/assets_constants.dart';
import 'hello_mascot_painter.dart';
import 'rive_mascot.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HELLO MASCOT
//
// Mieo saying hello on the "Hi! I’m Mieo" screen: the Rive file
// AssetsConstants.mascotHi (artboard "Mieo", state machine "MieoSM": he waves
// once, then breathes and blinks on a loop), played by RiveMascot. Give it the
// artboard's box (artboardSize): the Figma "Mieo Charachter" group (289 × 239)
// with [headroom] above his ears for the wave, so a box placed [headroom]
// above the Figma group puts every part of him on its Figma pixel. The still
// pose (HelloMascotPainter) takes the Figma group's spot inside the box.
// ─────────────────────────────────────────────────────────────────────────────
class HelloMascot extends StatelessWidget {
  const HelloMascot({super.key});

  /// The Rive artboard: the Figma group's width, and its height plus the
  /// headroom above his ears.
  static const Size artboardSize = Size(289, 256);

  /// The room above the Figma group (the still pose) inside the artboard.
  static const double headroom = 20;

  static const String _artboard = 'Mieo';
  static const String _stateMachine = 'MieoSM';

  @override
  Widget build(BuildContext context) {
    return RiveMascot(
      asset: AssetsConstants.mascotHi,
      artboard: _artboard,
      stateMachine: _stateMachine,
      still: const HelloMascotPainter(),
      stillRect: const Offset(0, headroom) & HelloMascotPainter.artworkSize,
    );
  }
}

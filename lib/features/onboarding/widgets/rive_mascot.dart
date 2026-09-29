import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart' as rive;

// ─────────────────────────────────────────────────────────────────────────────
// RIVE MASCOT
//
// Plays one of Mieo's Rive animations (an artboard of a .riv asset and its
// state machine) in the box it is given, which is the artboard at design size,
// so the artboard fills the box 1:1 and every part of Mieo lands where the
// artboard puts him.
//
// The file is decoded for Rive's Flutter renderer (Factory.flutter), which
// paints through Flutter's own canvas, so the animation scales with the stage
// around it. Until it is ready, and whenever the Rive runtime isn't running
// (RiveNative.init() failed, or a test environment) or the file can't be
// decoded, the still pose stands in: [still] painted in [stillRect], the spot
// the same pose takes inside the artboard. The screen is never missing its
// mascot.
//
// Local state: the decoded file and its controller, disposed with the widget.
// ─────────────────────────────────────────────────────────────────────────────
class RiveMascot extends StatefulWidget {
  const RiveMascot({
    super.key,
    required this.asset,
    required this.artboard,
    required this.stateMachine,
    required this.still,
    required this.stillRect,
  });

  /// The .riv file (AssetsConstants).
  final String asset;

  /// The artboard to play.
  final String artboard;

  /// The state machine to play.
  final String stateMachine;

  /// The code-drawn still pose, shown until the animation plays or when it
  /// can't.
  final CustomPainter still;

  /// Where [still] sits inside the artboard box.
  final Rect stillRect;

  @override
  State<RiveMascot> createState() => _RiveMascotState();
}

typedef _LoadedRive = ({rive.File file, rive.RiveWidgetController controller});

class _RiveMascotState extends State<RiveMascot> {
  _LoadedRive? _rive;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final loaded = await _loadRive(widget.asset, widget.artboard, widget.stateMachine);
    if (!mounted) {
      loaded?.controller.dispose();
      loaded?.file.dispose();
      return;
    }
    if (loaded != null) setState(() => _rive = loaded);
  }

  /// Decodes the file and creates its controller, or returns null when either
  /// fails. Errors from the native runtime surface as Errors rather than
  /// Exceptions, so everything is caught: the still pose stays.
  static Future<_LoadedRive?> _loadRive(String asset, String artboard, String stateMachine) async {
    if (!rive.RiveNative.isInitialized) return null;
    rive.File? file;
    try {
      file = await rive.File.asset(asset, riveFactory: rive.Factory.flutter);
      if (file == null) return null;
      final controller = rive.RiveWidgetController(
        file,
        artboardSelector: rive.ArtboardNamed(artboard),
        stateMachineSelector: rive.StateMachineNamed(stateMachine),
      );
      return (file: file, controller: controller);
    } on Object {
      file?.dispose();
      return null;
    }
  }

  @override
  void dispose() {
    final loaded = _rive;
    if (loaded != null) {
      loaded.controller.dispose();
      loaded.file.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _rive?.controller;
    if (controller == null) return _StillPose(painter: widget.still, rect: widget.stillRect);
    return rive.RiveWidget(controller: controller, hitTestBehavior: rive.RiveHitTestBehavior.none);
  }
}

/// The code-drawn pose at its spot inside the artboard box. Its effects (a
/// sole shadow, say) may reach past the box, as they do in Figma.
class _StillPose extends StatelessWidget {
  const _StillPose({required this.painter, required this.rect});

  final CustomPainter painter;
  final Rect rect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fromRect(
          rect: rect,
          child: CustomPaint(painter: painter),
        ),
      ],
    );
  }
}

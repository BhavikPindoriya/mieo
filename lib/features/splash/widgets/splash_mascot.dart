import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart' as rive;

import '../../../core/constants/assets_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SPLASH MASCOT
//
// Mieo on his plane, played from the Rive file AssetsConstants.mascotSplash.
// Its artboard is the 375 × 812 splash frame with the character at his Figma
// position, so it is drawn unscaled (Fit.none) and centred: give this widget
// the screen in frame coordinates (SplashStage.viewport) and the artboard sits
// exactly on the frame, while the plane can still fly in from past its edge.
//
// State machine "SplashSM" runs three layers at once:
//   1. FlyIn (1.5 s) → Hello (2 s, waves three times) → ComeForward (0.8 s,
//      zooms towards the camera and fades out). The last one fires the
//      "splashDone" event → [onFinished].
//   2. Propeller — spins the whole time.
//   3. Blink — every 3 s.
//
// The file is decoded for Rive's Flutter renderer (Factory.flutter), which
// paints through Flutter's own canvas on every platform. When the Rive runtime
// isn't running (RiveNative.init() failed, or a test environment) or the file
// can't be decoded, nothing is drawn and [onFailed] is called instead.
//
// Local state: the decoded file and its controller, disposed with the widget.
// ─────────────────────────────────────────────────────────────────────────────
class SplashMascot extends StatefulWidget {
  const SplashMascot({super.key, required this.onFinished, required this.onFailed});

  /// The animation reached its end ("splashDone").
  final VoidCallback onFinished;

  /// The animation can't play.
  final VoidCallback onFailed;

  @override
  State<SplashMascot> createState() => _SplashMascotState();
}

typedef _LoadedRive = ({rive.File file, rive.RiveWidgetController controller});

class _SplashMascotState extends State<SplashMascot> {
  static const String _stateMachineName = 'SplashSM';
  static const String _finishedEventName = 'splashDone';

  _LoadedRive? _rive;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final loaded = await _loadRive();
    if (!mounted) {
      loaded?.controller.dispose();
      loaded?.file.dispose();
      return;
    }
    if (loaded == null) {
      widget.onFailed();
      return;
    }
    loaded.controller.stateMachine.addEventListener(_onRiveEvent);
    setState(() => _rive = loaded);
  }

  /// Decodes the file and creates its controller, or returns null when either
  /// fails. Errors from the native runtime surface as Errors rather than
  /// Exceptions, so everything is caught: the splash simply plays without the
  /// mascot.
  static Future<_LoadedRive?> _loadRive() async {
    if (!rive.RiveNative.isInitialized) return null;
    rive.File? file;
    try {
      file = await rive.File.asset(AssetsConstants.mascotSplash, riveFactory: rive.Factory.flutter);
      if (file == null) return null;
      final controller = rive.RiveWidgetController(
        file,
        stateMachineSelector: const rive.StateMachineNamed(_stateMachineName),
      );
      return (file: file, controller: controller);
    } on Object {
      file?.dispose();
      return null;
    }
  }

  // State machine events are reported while the artboard advances, inside a
  // frame; the callback runs after that frame, where navigation is safe.
  void _onRiveEvent(rive.Event event) {
    if (event.name != _finishedEventName) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    final loaded = _rive;
    if (loaded != null) {
      loaded.controller.stateMachine.removeEventListener(_onRiveEvent);
      loaded.controller.dispose();
      loaded.file.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _rive?.controller;
    if (controller == null) return const SizedBox.shrink();
    return rive.RiveWidget(controller: controller, fit: rive.Fit.none, hitTestBehavior: rive.RiveHitTestBehavior.none);
  }
}

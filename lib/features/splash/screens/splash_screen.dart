import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/clouds/cloud_shapes.dart';
import '../../../commons/widgets/clouds/clouds_painter.dart';
import '../../../core/constants/animation_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/routes/routes.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../widgets/splash_mascot.dart';
import '../widgets/splash_stage.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SPLASH SCREEN
//
// Figma "Splash": Light 22:5, Dark 2159:12106 (the same frame with the Colors
// variables in Dark mode, so every colour here is a theme token). One composed
// scene, laid out in the frame's own coordinates by SplashStage and painted
// bottom to top in Figma's layer order:
//
//   1. Sky     — Surface/Body under the Surface/Sky/Top → Surface/Sky/Bottom
//                gradient, full-bleed behind the status bar.
//   2. Title   — "Learning  with" over the "Mieo" wordmark (App Name group).
//   3. Clouds  — eight code-drawn clouds in the Cloud Color tokens.
//   4. Mascot  — Mieo on his plane (Rive): flies in, waves, zooms away.
//   5. Footer  — the credit line, pinned to the bottom edge and never scaled.
//
// Local state: the exit timer. The screen hands over to the first screen
// (Onboarding, cross-fading) when the mascot reports the end of its animation; if
// the animation can't play, after a short static hold; and at the latest after
// AnimationConstants.splashTimeout.
// ─────────────────────────────────────────────────────────────────────────────

// ── Figma geometry (frame coordinates) ──
/// "Learning  with" (25:1306): left edge and top of its text box.
const double _taglineStart = 122;
const double _taglineTop = 222;

/// "Mieo" (25:1305): top of its text box; centred on the frame.
const double _wordmarkTop = 238;

/// "Footer" (25:1315): height of the bottom-pinned credit frame.
const double _footerHeight = 58;

/// "Cloudes" (25:1200): the eight clouds at their Figma positions.
final List<CloudPlacement> _clouds = [
  CloudPlacement(CloudShapes.cloud1, 21, 107),
  CloudPlacement(CloudShapes.cloud2, 243, 75),
  CloudPlacement(CloudShapes.cloud3, 230, 201),
  CloudPlacement(CloudShapes.cloud4, -17, 226),
  CloudPlacement(CloudShapes.cloud5, 283, 322),
  CloudPlacement(CloudShapes.cloud6, 0, 449),
  CloudPlacement(CloudShapes.cloud7, 165, 362),
  CloudPlacement(CloudShapes.cloud8, 332, 437),
];

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _exitTimer;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _exitTimer = Timer(AnimationConstants.splashTimeout, _leave);
  }

  /// Nothing will report the end of the animation: hold the static scene
  /// briefly, then move on.
  void _onMascotFailed() {
    _exitTimer.cancel();
    _exitTimer = Timer(AnimationConstants.splashStaticHold, _leave);
  }

  void _leave() {
    // A route opened on top of the splash (a web deep link such as
    // #/style-guide) keeps its place.
    if (_leaving || !mounted || ModalRoute.isCurrentOf(context) == false) return;
    _leaving = true;
    _exitTimer.cancel();
    unawaited(Get.offAllNamed<void>(Routes.onboarding));
  }

  @override
  void dispose() {
    _exitTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _SplashScene(onMascotFinished: _leave, onMascotFailed: _onMascotFailed),
    );
  }
}

class _SplashScene extends StatelessWidget {
  const _SplashScene({required this.onMascotFinished, required this.onMascotFailed});

  final VoidCallback onMascotFinished;
  final VoidCallback onMascotFailed;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final footerSpace = _footerHeight + context.navigationBarInset;
    final allowUpscale = context.isTabletLayout;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stage = SplashStage.fit(
          screen: constraints.biggest,
          topInset: topInset,
          bottomInset: footerSpace,
          allowUpscale: allowUpscale,
        );
        return Stack(
          children: [
            // ── 1. Sky ──
            Positioned.fill(child: _SplashSky(stage: stage)),

            // ── 2–4. The Figma frame: title, clouds, mascot ──
            // frameRect and viewport are centred on the screen, so their
            // left/top offsets hold in either text direction; the title texts
            // inside position themselves directionally.
            Positioned.fromRect(
              rect: stage.frameRect,
              child: FittedBox(
                child: SizedBox.fromSize(
                  size: SplashStage.frameSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const _SplashWordmark(),
                      const _SplashTagline(),
                      const _SplashClouds(),
                      Positioned.fromRect(
                        rect: stage.viewport,
                        child: RepaintBoundary(
                          child: SplashMascot(onFinished: onMascotFinished, onFailed: onMascotFailed),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── 5. Footer ──
            const _SplashFooter(),
          ],
        );
      },
    );
  }
}

/// The frame fill: the sky gradient runs from the top of the frame down to
/// SplashStage.skyGradientEnd, over the Scaffold's Surface/Body. It covers the
/// whole screen, holding its end colours above and below that span.
class _SplashSky extends StatelessWidget {
  const _SplashSky({required this.stage});

  final SplashStage stage;

  @override
  Widget build(BuildContext context) {
    final surface = context.colors.surface;
    // Gradient ends are fractions of the screen height: -1 top, 1 bottom.
    Alignment atFrameY(double frameY) => Alignment(0, stage.toScreenY(frameY) / stage.screen.height * 2 - 1);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: atFrameY(0),
          end: atFrameY(SplashStage.skyGradientEnd),
          colors: [surface.skyTop, surface.skyBottom],
        ),
      ),
    );
  }
}

/// "Mieo" — Figma 25:1305: display/large in Texts/Heading, centred.
class _SplashWordmark extends StatelessWidget {
  const _SplashWordmark();

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: 0,
      end: 0,
      top: _wordmarkTop,
      child: Text(LangKeys.appName.tr, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayLarge),
    );
  }
}

/// "Learning  with" — Figma 25:1306: body/large in Texts/Body Text, aligned
/// to the start edge (mirrored in RTL).
class _SplashTagline extends StatelessWidget {
  const _SplashTagline();

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: _taglineStart,
      top: _taglineTop,
      child: Text(
        LangKeys.splashTagline.tr,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: context.colors.text.body),
      ),
    );
  }
}

class _SplashClouds extends StatelessWidget {
  const _SplashClouds();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: CloudsPainter(clouds: _clouds, colors: context.colors.cloud),
        ),
      ),
    );
  }
}

/// "Designed with ❤️ by WRTeam Design" — Figma "Footer" (25:1315): a frame
/// 58 high pinned to the bottom edge (lifted above a navigation bar), its
/// label/large text in Texts/Body Text centred 16 below the frame's top and 16
/// in from the sides. The frame grows (keeping 16 below the text) when larger
/// text sizes wrap the line.
class _SplashFooter extends StatelessWidget {
  const _SplashFooter();

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: 0,
      end: 0,
      bottom: context.navigationBarInset,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _footerHeight),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(ThemeConstants.spacing16),
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: Text(
              LangKeys.splashCredit.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: context.colors.text.body),
            ),
          ),
        ),
      ),
    );
  }
}

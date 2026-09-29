import 'package:flutter/animation.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATION CONSTANTS
//
// Motion tokens for page transitions and micro-animations. Every Duration and
// Curve used in a widget comes from here, so the app's motion feel can be
// tuned in one place.
//
//   • Page transitions — the GetX Transition applied app-wide by
//     GetMaterialApp (main.dart); a single GetPage may override it in
//     routes.dart (the splash → first screen cross-fade).
//   • Micro-animations — press feedback, toggles, list/item entrances.
//     Keep them subtle: short durations and small scale/offset changes.
//   • Text typing — the typewriter of TypewriterText, and the talk bubble
//     that pops in around it.
// ─────────────────────────────────────────────────────────────────────────────
class AnimationConstants {
  AnimationConstants._();

  // ── Page transitions ──
  /// Cupertino slide — follows the ambient Directionality, so in RTL pages
  /// enter from the left edge, and it supports the iOS swipe-back gesture.
  static const Transition pageTransition = Transition.cupertino;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // ── Micro-animation durations ──
  /// Press/tap feedback, checkbox/switch toggles.
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Expand/collapse, tab indicator moves, fade-ins.
  static const Duration durationMedium = Duration(milliseconds: 250);

  /// Larger entrance animations (sheets, staggered list items).
  static const Duration durationSlow = Duration(milliseconds: 400);

  // ── Curves ──
  static const Curve curveStandard = Curves.easeOutCubic;
  static const Curve curveEmphasized = Curves.easeInOutCubicEmphasized;

  // ── Micro-animation values ──
  /// Scale a tappable card/button shrinks to while pressed.
  static const double pressedScale = 0.97;

  // ── Text typing ──
  /// Time to type one character (TypewriterText). After a punctuation mark
  /// that ends a phrase, the next character waits
  /// TypewriterSchedule.pauseSteps of these.
  static const Duration typewriterCharacter = Duration(milliseconds: 40);

  // ── Talk bubble ──
  /// Wait before a talk bubble pops in, so it starts once its page has slid
  /// into place.
  static const Duration bubbleEntranceDelay = pageTransitionDuration;

  /// A talk bubble popping up from its tail, from [bubblePopScale] to full
  /// size with a little overshoot; it fades in over the first half.
  static const Duration bubblePop = durationSlow;
  static const Curve curvePop = Curves.easeOutBack;
  static const double bubblePopScale = 0.6;

  // ── Splash ──
  /// Longest the splash waits for the mascot animation (about 4.3 s) to report
  /// that it has finished before moving on anyway.
  static const Duration splashTimeout = Duration(seconds: 6);

  /// How long the static splash stays up when the mascot animation can't play.
  static const Duration splashStaticHold = Duration(seconds: 2);

  /// Splash → first screen: a cross-fade that carries on the mascot's own
  /// fade-out.
  static const Transition splashExitTransition = Transition.fadeIn;
  static const Duration splashExitDuration = durationSlow;
}

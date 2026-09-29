import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/speech_bubble.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/routes/routes.dart';
import '../widgets/hello_mascot.dart';
import '../widgets/meadow_talk_scaffold.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HELLO SCREEN
//
// Figma "Onboarding": Light 62:3649, Dark 2159:37580 (the same frame with the
// Colors variables in Dark mode, so every colour here is a theme token or
// artwork). The first screen of new-account setup, where Mieo introduces
// himself, on the shared talk page (MeadowTalkScaffold):
//
//   • the one-line talk bubble "Hi! I’m Mieo";
//   • Mieo waving hello (HelloMascot: the Rive animation, or its still pose);
//   • "Say “Hi” to Mieo" (filled) opens the setup questions.
// ─────────────────────────────────────────────────────────────────────────────

// ── Figma geometry, in the BOdy frame ──
/// "Talk Bubble" (62:3841).
const Rect _bubbleArea = Rect.fromLTWH(120, 382, 129, 44);

/// "Mieo Charachter" (62:3842): the top-left corner of his box. The Rive
/// artboard reaches HelloMascot.headroom above it, for the wave.
const double _mascotLeft = 27;
const double _mascotTop = 451;

class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MeadowTalkScaffold(
      bubble: SpeechBubble(LangKeys.helloGreeting.tr, entrance: SpeechBubbleEntrance.typing),
      bubbleArea: _bubbleArea,
      mascot: const HelloMascot(),
      mascotArea: const Offset(_mascotLeft, _mascotTop - HelloMascot.headroom) & HelloMascot.artboardSize,
      actionLabel: LangKeys.helloSayHi.tr,
      onAction: () => unawaited(Get.toNamed<void>(Routes.setupQuestions)),
    );
  }
}

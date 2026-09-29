import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/speech_bubble.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/routes/routes.dart';
import '../widgets/meadow_talk_scaffold.dart';
import '../widgets/please_mascot.dart';

// ─────────────────────────────────────────────────────────────────────────────
// QUESTIONS INTRO SCREEN
//
// Figma "Onboarding": Light 62:8081, Dark 2159:37689 (the same frame with the
// Colors variables in Dark mode, so every colour here is a theme token or
// artwork). The second screen of new-account setup, where Mieo asks if he may
// ask some questions, on the shared talk page (MeadowTalkScaffold):
//
//   • the talk bubble "Yey..! I just want to Ask you some Questions.
//     Please...!", 283 wide, its text wrapping inside;
//   • Mieo asking nicely (PleaseMascot: the Rive animation, or its still pose);
//   • "Sure.! Continue" (filled) opens the first question.
// ─────────────────────────────────────────────────────────────────────────────

// ── Figma geometry, in the BOdy frame ──
/// "Talk Bubble" (62:12053).
const Rect _bubbleArea = Rect.fromLTWH(43, 366, 283, 64);

/// "Mieo Charachter" (62:12012): the top-left corner of the still pose.
const double _mascotLeft = 73;
const double _mascotTop = 450;

class QuestionsIntroScreen extends StatelessWidget {
  const QuestionsIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MeadowTalkScaffold(
      bubble: SpeechBubble(
        LangKeys.questionsIntroMessage.tr,
        width: _bubbleArea.width,
        entrance: SpeechBubbleEntrance.typing,
      ),
      bubbleArea: _bubbleArea,
      mascot: const PleaseMascot(),
      mascotArea:
          const Offset(_mascotLeft - PleaseMascot.stillLeft, _mascotTop - PleaseMascot.stillTop) &
          PleaseMascot.artboardSize,
      actionLabel: LangKeys.questionsIntroContinue.tr,
      onAction: () => unawaited(Get.toNamed<void>(Routes.setupNativeLanguage)),
    );
  }
}

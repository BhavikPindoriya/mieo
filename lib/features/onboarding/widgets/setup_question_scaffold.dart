import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/app_button.dart';
import '../../../commons/widgets/app_top_bar.dart';
import '../../../commons/widgets/clouds/cloud_groups.dart';
import '../../../commons/widgets/glossy_progress_bar.dart';
import '../../../commons/widgets/responsive_content.dart';
import '../../../commons/widgets/sky_backdrop.dart';
import '../../../commons/widgets/speech_bubble.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../models/models.dart';
import 'perched_mieo.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SETUP QUESTION SCAFFOLD
//
// The page every setup question shares (Figma "Survey" frames of New Account
// Progress: native language, learning language, level, daily goal). Only the
// step, Mieo's question and the answers change. Top to bottom:
//
//   • Sky — the full-bleed sky (SkyBackdrop) with the Figma "Cloudes" group
//     (CloudGroups.setupHeader), fixed behind the page from the top bar down.
//   • Top bar — pinned under the status bar: the back button and a
//     GlossyProgressBar filled to the question's step, growing from the
//     step before as the page opens.
//   • Header — Mieo taking notes on his cloud (PerchedMieo), 16 in from the
//     start and 16 below the bar, and 12 after him the talk bubble with his
//     question, filling the rest of the row, its tail pointing back at him
//     (SpeechBubbleFace.start) and centred on him. It pops up and types the
//     question out as the page opens.
//   • Answers — [answers], 32 below Mieo (the header's 16 and the list's
//     own 16) and 16 in from both sides.
//   • Next — the filled button pinned 24 above the bottom edge (lifted above a
//     navigation bar). Like Figma, it floats over the page: the header and
//     answers scroll under it, with room at the end for the last answer to
//     clear it.
//
// The header and answers sit in the content column (ResponsiveContent), so
// on tablets they are capped and centred; the header row mirrors in RTL
// (Mieo moves to the end and the tail follows him). No local state.
// ─────────────────────────────────────────────────────────────────────────────
class SetupQuestionScaffold extends StatelessWidget {
  const SetupQuestionScaffold({
    super.key,
    required this.step,
    required this.question,
    required this.answers,
    required this.onNext,
  });

  /// Which question this is: sets the progress bar.
  final SetupStep step;

  /// What Mieo asks, with any accent words between HighlightedText markers.
  final String question;

  /// The answers to pick from.
  final Widget answers;

  /// What Next does.
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkyBackdrop(
        clouds: CloudGroups.setupHeader,
        cloudsTop: MediaQuery.paddingOf(context).top,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top bar ──
              AppTopBar(
                center: GlossyProgressBar(value: step.progress, from: step.previousProgress),
              ),

              // ── Header, answers and Next ──
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _QuestionScroll(question: question, answers: answers),
                    ),
                    PositionedDirectional(start: 0, end: 0, bottom: 0, child: _NextAction(onPressed: onNext)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Height of the Next area: the button with 24 above and below it.
const double _nextAreaHeight = ThemeConstants.buttonHeight + ThemeConstants.spacing24 * 2;

/// The header and the answers, scrolling, with room under the last answer for
/// the Next button.
class _QuestionScroll extends StatelessWidget {
  const _QuestionScroll({required this.question, required this.answers});

  final String question;
  final Widget answers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(bottom: _nextAreaHeight + context.navigationBarInset),
      child: ResponsiveContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ThemeConstants.spacing16,
          children: [
            _Header(question: question),
            answers,
          ],
        ),
      ),
    );
  }
}

/// Mieo on his cloud with the talk bubble beside him, 16 above and below.
class _Header extends StatelessWidget {
  const _Header({required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: ThemeConstants.spacing16),
      child: Row(
        spacing: ThemeConstants.spacing12,
        children: [
          const PerchedMieo(),
          Expanded(
            // The bubble keeps the row's remaining width and wraps its text
            // inside, like the fixed-width Figma instance.
            child: LayoutBuilder(
              builder: (context, constraints) => SpeechBubble(
                question,
                width: constraints.maxWidth,
                face: SpeechBubbleFace.start,
                entrance: SpeechBubbleEntrance.typing,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The filled Next button, 24 above and below it (plus any navigation bar).
class _NextAction extends StatelessWidget {
  const _NextAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // A Column hands the content column an unbounded height, so it takes the
    // button's height rather than the page's.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResponsiveContent(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: ThemeConstants.spacing24,
              bottom: ThemeConstants.spacing24 + context.navigationBarInset,
            ),
            child: AppButton(label: LangKeys.setupNext.tr, onPressed: onPressed),
          ),
        ),
      ],
    );
  }
}

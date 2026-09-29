import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/app_button.dart';
import '../../../commons/widgets/app_tag.dart';
import '../../../commons/widgets/highlighted_text.dart';
import '../../../commons/widgets/responsive_content.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/routes/routes.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../widgets/onboarding_scene.dart';
import '../widgets/shield_check_icon.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ONBOARDING SCREEN
//
// Figma "Onboarding": Light 25:1919, Dark 2159:12444 (the same frame with the
// Colors variables in Dark mode, so every colour here is a theme token or
// artwork). The first screen after the splash: it greets a new learner and
// offers the two ways in. Top to bottom:
//
//   1. Status bar inset — the page background, Surface/Body.
//   2. Sky panel — Figma "Body": Surface/Sky/Bottom → Surface/Sky/Top over
//      Surface/Body, clipped, holding
//        • the intro: the "100% Kids Safe" tag over the heading, whose
//          highlighted word is marked in its translation;
//        • the scene: pedestals, clouds and Mieo (OnboardingScene), anchored
//          to the panel's bottom edge and painted behind the intro.
//      Where the space is too short for the intro plus the scene at its
//      smallest (landscape phones, large text), the panel scrolls.
//   3. Actions — "Let’s Get a Fresh Start" (filled) opens account setup and
//      "Resume Journey" (outlined) opens login. Pinned to the bottom edge,
//      lifted above a navigation bar.
//
// No local state: the buttons animate their own press.
// ─────────────────────────────────────────────────────────────────────────────

// ── Figma geometry ──
/// Gap between the sky panel and the actions (Body ends at 643, the actions
/// frame starts at 652).
const double _panelActionsGap = 9;

/// The intro ("Container" 31:95): 54 below the panel's top, 340 wide on the
/// reference, so 18 from the start edge and 17 from the end.
const double _introTop = 54;
const double _introStart = 18;
const double _introEnd = 17;

/// The sky gradient runs from 12.816% to 111.05% of the panel's height (Figma
/// "Body" fill), as Alignment y = 2 × fraction − 1.
const Alignment _skyGradientBegin = Alignment(0, 2 * 0.12816 - 1);
const Alignment _skyGradientEnd = Alignment(0, 2 * 1.1105 - 1);

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsDirectional.only(top: MediaQuery.paddingOf(context).top),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Sky panel ──
            Expanded(child: _SkyPanel()),
            SizedBox(height: _panelActionsGap),

            // ── Actions ──
            _Actions(),
          ],
        ),
      ),
    );
  }
}

/// Figma "Body" (31:139): the sky with the intro over the scene. Fills the
/// space above the actions; when that is shorter than the intro plus the
/// scene's minimum slot, the panel takes the height it needs and scrolls.
class _SkyPanel extends StatelessWidget {
  const _SkyPanel();

  @override
  Widget build(BuildContext context) {
    final surface = context.colors.surface;
    return LayoutBuilder(
      builder: (context, viewport) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewport.maxHeight),
          child: IntrinsicHeight(
            child: ColoredBox(
              color: surface.body,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: _skyGradientBegin,
                    end: _skyGradientEnd,
                    colors: [surface.skyBottom, surface.skyTop],
                  ),
                ),
                // Laid out bottom-up, so the scene paints first and the intro
                // on top of it, while the intro still sits at the top.
                child: const ClipRect(
                  child: Column(
                    verticalDirection: VerticalDirection.up,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: OnboardingScene()),
                      _Intro(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma "Container" (31:95): the kids-safe tag, then the heading 8 below.
class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return ResponsiveContent(
      horizontalPadding: 0,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: _introStart, top: _introTop, end: _introEnd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: ThemeConstants.spacing8,
          children: [
            AppTag(icon: const ShieldCheckIcon(), label: LangKeys.onboardingKidsSafe.tr),
            HighlightedText(LangKeys.onboardingTitle.tr, style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
      ),
    );
  }
}

/// Figma "Container" (31:6622): the two buttons 16 apart, 24 below the panel
/// and 24 above the bottom edge.
class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return ResponsiveContent(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: ThemeConstants.spacing24,
          bottom: ThemeConstants.spacing24 + context.navigationBarInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: ThemeConstants.spacing16,
          children: [
            AppButton(
              label: LangKeys.onboardingFreshStart.tr,
              onPressed: () => unawaited(Get.toNamed<void>(Routes.accountSetup)),
            ),
            AppButton(
              label: LangKeys.onboardingResumeJourney.tr,
              variant: AppButtonVariant.outlined,
              onPressed: () => unawaited(Get.toNamed<void>(Routes.login)),
            ),
          ],
        ),
      ),
    );
  }
}

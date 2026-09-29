import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';
import '../../utils/extensions/context_extensions.dart';
import 'app_icon_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP TOP BAR
//
// Figma "TopAppBar" (441:7763), variant General: an 80-high bar under the
// status bar with 16 padding, holding the back button (AppBackButton), then
// 16 after it the title in title/large filling the rest (or, in its place, a
// widget such as the New Account Progress bar), then any side actions (12
// apart). Laid out Row-wise, so it mirrors in RTL.
//
// [background]: none leaves the page showing through (Create Profile, the
// onboarding questions); card fills it with Surface/Background Nuturel and
// rounds its bottom corners by 24 (Explore Levels, Stories).
// ─────────────────────────────────────────────────────────────────────────────

/// The Figma TopAppBar fills: none, or a card under the status bar.
enum AppTopBarBackground { none, card }

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.center,
    this.actions = const [],
    this.background = AppTopBarBackground.none,
    this.onBack,
  });

  /// 16 above and below the 48 back button.
  static const double height = AppIconButton.size + ThemeConstants.spacing16 * 2;

  final String? title;

  /// Takes the title's place when there is no [title], centred on the back
  /// button's line: a progress bar, say.
  final Widget? center;

  /// Widgets at the end, e.g. stat chips.
  final List<Widget> actions;

  final AppTopBarBackground background;

  /// Replaces the back button's default of going back a page.
  final VoidCallback? onBack;

  static const BorderRadius _cardRadius = BorderRadius.vertical(bottom: Radius.circular(ThemeConstants.radius24));

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final center = this.center;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: switch (background) {
          AppTopBarBackground.none => null,
          AppTopBarBackground.card => context.colors.surface.backgroundNeutral,
        },
        borderRadius: _cardRadius,
      ),
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(ThemeConstants.spacing16),
          child: Row(
            spacing: ThemeConstants.spacing16,
            children: [
              AppBackButton(onPressed: onBack),
              Expanded(
                child: title == null
                    ? (center ?? const SizedBox.shrink())
                    : Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
              ),
              if (actions.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, spacing: ThemeConstants.spacing12, children: actions),
            ],
          ),
        ),
      ),
    );
  }
}

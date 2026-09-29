import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';
import 'app_top_bar.dart';
import 'clouds/cloud_groups.dart';
import 'responsive_content.dart';
import 'sky_backdrop.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SKY FORM SCAFFOLD
//
// The page of the sign-in and profile forms (Login, Create Profile, and the
// Create Account form): the full-bleed sky with the form-screen clouds
// (SkyBackdrop, CloudGroups.formHeader), an optional top bar under the status
// bar, and the form, centred in a content column that is capped on tablets
// (ResponsiveContent).
//
// As in Figma, whose "Container" frames sit 113 from the top and the bottom
// of the 812 frame, the form is centred on the screen itself rather than on
// the space under the top bar: it gets the same inset above and below, the
// larger of the status bar plus top bar and the bottom system inset. When it
// doesn't fit, or the keyboard is up, it scrolls; dragging it or tapping the
// page outside the fields puts the keyboard away. Landscape notches are kept
// clear on both sides.
// ─────────────────────────────────────────────────────────────────────────────
class SkyFormScaffold extends StatelessWidget {
  const SkyFormScaffold({super.key, required this.child, this.topBar});

  /// The form, laid out top to bottom.
  final Widget child;

  final AppTopBar? topBar;

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final topBar = this.topBar;
    final top = insets.top + (topBar == null ? 0 : AppTopBar.height);
    // The equal inset above and below the centred form, measured from the
    // screen edges; the scroll view below the top bar starts `top` down.
    final inset = math.max(top, insets.bottom);
    return Scaffold(
      body: SkyBackdrop(
        clouds: CloudGroups.formHeader,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: FocusScope.of(context).unfocus,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: insets.top),
                ?topBar,
                Expanded(
                  child: _CenteredScroll(
                    top: inset - top,
                    // Over the keyboard (which the Scaffold already lifts the
                    // page above) only a small margin is kept.
                    bottom: math.max(inset - keyboard, ThemeConstants.spacing24),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Scrolls [child] with [top] and [bottom] padding, centred vertically while
/// it's shorter than the space.
class _CenteredScroll extends StatelessWidget {
  const _CenteredScroll({required this.top, required this.bottom, required this.child});

  final double top;
  final double bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewport) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsetsDirectional.only(top: top, bottom: bottom),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: math.max(0, viewport.maxHeight - top - bottom)),
          child: Center(child: ResponsiveContent(child: child)),
        ),
      ),
    );
  }
}

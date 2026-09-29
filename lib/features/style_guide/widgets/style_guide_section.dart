import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STYLE GUIDE SECTION
//
// The two heading levels of the style guide:
//   StyleGuideSection — a top-level section (Colors, Typography…): headline
//                       plus its content, 24 apart.
//   StyleGuideGroup   — a titled group inside a section (e.g. the Figma
//                       `Surface/*` variables), in Texts/Body Text.
// ─────────────────────────────────────────────────────────────────────────────
class StyleGuideSection extends StatelessWidget {
  const StyleGuideSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ThemeConstants.spacing24,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ...children,
      ],
    );
  }
}

class StyleGuideGroup extends StatelessWidget {
  const StyleGuideGroup({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ThemeConstants.spacing12,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: context.colors.text.body)),
        child,
      ],
    );
  }
}

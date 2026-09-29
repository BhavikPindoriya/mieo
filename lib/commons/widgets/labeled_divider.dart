import 'package:flutter/material.dart';

import '../../core/constants/theme_constants.dart';
import '../../core/theme/fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LABELED DIVIDER
//
// A hairline across the width with a label in the middle, like Login's "Or
// Continue With" (366:15192): two 1px lines in Stroke/Extra Dim/Nuturel (the
// theme's divider colour) share the width 16 either side of a
// label/large - prominent label in Texts/Heading.
// ─────────────────────────────────────────────────────────────────────────────
class LabeledDivider extends StatelessWidget {
  const LabeledDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: ThemeConstants.spacing16,
      children: [
        const Expanded(child: Divider()),
        Text(label, style: Theme.of(context).textTheme.labelLargeProminent),
        const Expanded(child: Divider()),
      ],
    );
  }
}

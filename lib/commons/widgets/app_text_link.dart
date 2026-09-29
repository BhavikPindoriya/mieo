import 'package:flutter/material.dart';

import '../../core/theme/fonts.dart';
import 'app_tap_target.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP TEXT LINK
//
// A tappable line of underlined text, like Login's "Forgot Password .?"
// (366:15173): label/large - prominent in Texts/Heading, underlined in the
// same colour. It sits at [alignment] in the width it's given, and takes
// taps in a full tap target around the text without taking more room than
// the text (AppTapTarget) — so place it directly in a Column or Row.
// ─────────────────────────────────────────────────────────────────────────────
class AppTextLink extends StatelessWidget {
  const AppTextLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.alignment = AlignmentDirectional.centerStart,
  });

  final String label;
  final VoidCallback onPressed;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return AppTapTarget(
      alignment: alignment,
      child: Semantics(
        container: true,
        link: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLargeProminent?.copyWith(decoration: TextDecoration.underline),
            ),
          ),
        ),
      ),
    );
  }
}

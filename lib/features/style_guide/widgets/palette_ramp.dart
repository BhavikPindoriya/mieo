import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/fonts.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PALETTE RAMP
//
// One primitive family (`Shades/<family>`) as a strip of eleven equal cells,
// 50 → 950, with the step numbers underneath. Primitives are identical in
// both themes, so the strip never changes with the theme.
// ─────────────────────────────────────────────────────────────────────────────
class PaletteRamp extends StatelessWidget {
  const PaletteRamp({super.key, required this.ramp});

  final ColorRamp ramp;

  static const double _cellHeight = 40;

  static const BorderRadiusGeometry _radius = BorderRadiusDirectional.all(Radius.circular(ThemeConstants.radius8));

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final stepStyle = textTheme.labelSmall?.copyWith(color: context.colors.text.body);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ThemeConstants.spacing8,
      children: [
        Text(ramp.figmaName, style: textTheme.labelLargeProminent),
        ClipRRect(
          borderRadius: _radius,
          child: Row(
            children: [
              for (final color in ramp.colors)
                Expanded(
                  child: ColoredBox(
                    color: color,
                    child: const SizedBox(height: _cellHeight),
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            for (final step in ColorRamp.steps)
              Expanded(
                child: Text(step.toString(), style: stepStyle, textAlign: TextAlign.center),
              ),
          ],
        ),
      ],
    );
  }
}

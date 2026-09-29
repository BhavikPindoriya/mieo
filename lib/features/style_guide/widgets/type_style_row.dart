import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/fonts.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TYPE STYLE ROW
//
// One Figma text style: the sample text rendered in the resolved theme style,
// then its Figma name, and its Flutter role with the family, weight, size and
// letter spacing. The sample wraps rather than truncates, so the largest
// display styles show at their real size.
// ─────────────────────────────────────────────────────────────────────────────
class TypeStyleRow extends StatelessWidget {
  const TypeStyleRow({super.key, required this.token, required this.sampleText});

  final TypeStyleToken token;

  /// Localised sample copy, so RTL languages preview in their own script.
  final String sampleText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final style = token.resolve(textTheme);
    final metaStyle = textTheme.bodySmall?.copyWith(color: colors.text.body);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ThemeConstants.spacing4,
      children: [
        Text(sampleText, style: style),
        Text(token.figmaName, style: textTheme.labelMediumProminent?.copyWith(color: colors.text.primary)),
        Text(token.describe(style), style: metaStyle),
      ],
    );
  }
}

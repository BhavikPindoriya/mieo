import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/fonts.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../models/models.dart';
import 'token_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// COLOR SWATCH TILE
//
// One Figma colour variable on a TokenCard, top to bottom:
//   • a swatch filled with the token's value in the active theme (translucent
//     dark-mode tokens show over the card surface, as they would in the UI);
//   • the Figma variable name, the `context.colors` accessor and the hex value.
// While the theme animates, the swatch and hex follow the interpolated colour.
// ─────────────────────────────────────────────────────────────────────────────
class ColorSwatchTile extends StatelessWidget {
  const ColorSwatchTile({super.key, required this.token});

  final ColorToken token;

  static const double _swatchHeight = 56;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final color = token.resolve(colors);
    return TokenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _swatchHeight,
            child: ColoredBox(color: color),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(ThemeConstants.spacing12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: ThemeConstants.spacing4,
              children: [
                Text(token.figmaName, style: textTheme.labelMediumProminent),
                Text(
                  token.dartName,
                  style: textTheme.bodySmall?.copyWith(color: colors.text.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(ColorToken.hexOf(color), style: textTheme.bodySmall?.copyWith(color: colors.text.body)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

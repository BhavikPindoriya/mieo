import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/fonts.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TOKEN SAMPLES
//
// Visual samples for the dimension tokens:
//   SpacingSample — token and Figma names, a Surface/Primary bar exactly as
//                   long as the value, then the value.
//   RadiusSample  — a square with the radius, outlined like a selected tile.
//   ShadowSample  — a component-sized block with the look's fill, outline and
//                   hard shadow, then the Figma shadow name and offset.
// ─────────────────────────────────────────────────────────────────────────────
class SpacingSample extends StatelessWidget {
  const SpacingSample({super.key, required this.token});

  final SizeToken token;

  static const double _labelWidth = 104;
  static const double _barHeight = 16;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      spacing: ThemeConstants.spacing12,
      children: [
        SizedBox(
          width: _labelWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(token.name, style: textTheme.labelLargeProminent),
              if (token.figmaName case final figmaName?)
                Text(figmaName, style: textTheme.bodySmall?.copyWith(color: colors.text.body)),
            ],
          ),
        ),
        SizedBox(
          width: token.value,
          height: _barHeight,
          child: ColoredBox(color: colors.surface.primary),
        ),
        Text(token.valueLabel, style: textTheme.labelMedium),
      ],
    );
  }
}

class RadiusSample extends StatelessWidget {
  const RadiusSample({super.key, required this.token});

  final SizeToken token;

  static const double _size = 72;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: ThemeConstants.spacing8,
      children: [
        SizedBox.square(
          dimension: _size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface.dimPrimary,
              borderRadius: BorderRadiusDirectional.circular(token.value),
              border: AppBorders.outline(colors.stroke.primary),
            ),
          ),
        ),
        Text(token.name, style: textTheme.labelMediumProminent),
        Text(token.valueLabel, style: textTheme.bodySmall?.copyWith(color: colors.text.body)),
      ],
    );
  }
}

class ShadowSample extends StatelessWidget {
  const ShadowSample({super.key, required this.token});

  final ShadowToken token;

  static const double _blockHeight = 56;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final border = token.border;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ThemeConstants.spacing12,
      children: [
        SizedBox(
          height: _blockHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: token.fill(colors),
              borderRadius: BorderRadiusDirectional.circular(ThemeConstants.radius16),
              border: border == null ? null : AppBorders.outline(border(colors)),
              boxShadow: AppShadows.hard(token.shadow(colors), offset: token.offset, bordered: border != null),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(token.figmaName, style: textTheme.labelMediumProminent),
            Text(
              LangKeys.styleGuideShadowOffset.trParams({'value': SizeToken.format(token.offset)}),
              style: textTheme.bodySmall?.copyWith(color: colors.text.body),
            ),
          ],
        ),
      ],
    );
  }
}

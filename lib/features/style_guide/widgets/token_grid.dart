import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TOKEN GRID
//
// Lays samples out in equal columns — [mobileColumns] on phones,
// [tabletColumns] on tablets — separated by the Figma layout-grid gutter.
// Each child keeps its own height, so tiles grow with their text instead of
// being clipped to a fixed aspect ratio.
// ─────────────────────────────────────────────────────────────────────────────
class TokenGrid extends StatelessWidget {
  const TokenGrid({super.key, required this.children, this.mobileColumns = 2, this.tabletColumns = 4});

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive(mobile: mobileColumns, tablet: tabletColumns);
    return LayoutBuilder(
      builder: (context, constraints) {
        // Floored so rounding never pushes the last tile of a row onto the next.
        final itemWidth = ((constraints.maxWidth - ThemeConstants.gridGutter * (columns - 1)) / columns)
            .floorToDouble();
        return Wrap(
          spacing: ThemeConstants.gridGutter,
          runSpacing: ThemeConstants.gridGutter,
          children: [for (final child in children) SizedBox(width: itemWidth, child: child)],
        );
      },
    );
  }
}

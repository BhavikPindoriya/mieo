import 'package:flutter/material.dart';

import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/fonts.dart';
import '../../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP FIELD LAYOUT
//
// Places an input's box (AppFieldBox) with its optional inline label and its
// validation message:
//
//   Row   — the label (label/large - prominent, Texts/Heading) 16 before the
//           box, which takes the rest of the width, like Create Profile's
//           "Gender" and "Age" (366:15467). Without a label, just the box.
//   Error — the message under the row, 8 below the box, in label/medium and
//           Texts/Red. It spans the label too, so short fields keep room for
//           it.
// ─────────────────────────────────────────────────────────────────────────────
class AppFieldLayout extends StatelessWidget {
  const AppFieldLayout({super.key, required this.box, this.label, this.errorText});

  /// The field's box, usually an AppFieldBox.
  final Widget box;

  final String? label;

  /// The validation message; null while the field is valid.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final label = this.label;
    final errorText = this.errorText;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label == null)
          box
        else
          Row(
            spacing: ThemeConstants.spacing16,
            children: [
              Text(label, style: textTheme.labelLargeProminent),
              Expanded(child: box),
            ],
          ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: ThemeConstants.spacing8),
            child: Text(errorText, style: textTheme.labelMedium?.copyWith(color: context.colors.text.red)),
          ),
      ],
    );
  }
}

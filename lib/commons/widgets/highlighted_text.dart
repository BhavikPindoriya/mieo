import 'package:flutter/material.dart';

import '../../utils/extensions/context_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HIGHLIGHTED TEXT
//
// Text with accent-coloured words, marked in the (translated) string with
// double asterisks: 'Learn any **Language** Faster then ever.' draws
// "Language" in [HighlightedText.highlightColor] (default Texts/primary) and
// the rest in [HighlightedText.style]. Double underscores underline the words
// between them, so '**__Native__**' is an underlined accent. The markers
// travel with the words, so every translation puts the accent where its own
// word order needs it. An unpaired marker runs to the end of the text.
//
// [HighlightedText.visibleLength] draws only the start of the text, for a
// typewriter reveal: the rest is laid out but transparent, so the lines never
// reflow as letters appear and a screen reader still reads the whole text.
// [HighlightedText.textPainter] lays the text out the way build() does, for
// widgets that measure it before layout (SpeechBubble.boxHeight).
// ─────────────────────────────────────────────────────────────────────────────
class HighlightedText extends StatelessWidget {
  const HighlightedText(this.text, {super.key, this.style, this.highlightColor, this.textAlign, this.visibleLength});

  /// Opens and closes a highlighted run.
  static const String marker = '**';

  /// Opens and closes an underlined run.
  static const String underlineMarker = '__';

  /// The text, with each highlighted run between two [marker]s and each
  /// underlined run between two [underlineMarker]s.
  final String text;

  final TextStyle? style;

  /// Colour of the highlighted runs; defaults to Figma `Texts/primary`.
  final Color? highlightColor;

  final TextAlign? textAlign;

  /// How many UTF-16 code units of [plainText] are drawn; null draws all.
  final int? visibleLength;

  /// The text as it reads on screen, without the markers.
  String get plainText => text.replaceAll(marker, '').replaceAll(underlineMarker, '');

  /// The runs as spans, without the markers: what build() draws.
  TextSpan span(BuildContext context) {
    final highlight = highlightColor ?? context.colors.text.primary;
    final visible = visibleLength;
    final children = <TextSpan>[];
    var start = 0;
    var highlighted = false;
    var underlined = false;
    // Each marker switches its look on or off for the run that follows it.
    for (final part in _parts) {
      if (part == marker) {
        highlighted = !highlighted;
        continue;
      }
      if (part == underlineMarker) {
        underlined = !underlined;
        continue;
      }
      if (part.isEmpty) continue;
      final style = highlighted || underlined
          ? TextStyle(color: highlighted ? highlight : null, decoration: underlined ? TextDecoration.underline : null)
          : null;
      final shown = visible == null ? part.length : (visible - start).clamp(0, part.length);
      if (shown > 0) children.add(TextSpan(text: part.substring(0, shown), style: style));
      if (shown < part.length) children.add(TextSpan(text: part.substring(shown), style: _hidden));
      start += part.length;
    }
    return TextSpan(children: children);
  }

  /// The text split into runs and markers, in order: 'a **b** c' gives
  /// 'a ', '**', 'b', '**', ' c'.
  Iterable<String> get _parts sync* {
    var runStart = 0;
    for (final match in _markers.allMatches(text)) {
      yield text.substring(runStart, match.start);
      yield match[0]!;
      runStart = match.end;
    }
    yield text.substring(runStart);
  }

  static final RegExp _markers = RegExp('${RegExp.escape(marker)}|${RegExp.escape(underlineMarker)}');

  /// A painter holding the text laid out as build() lays it out in [context]:
  /// the same spans, style, alignment, text scale, bold-text and text-spacing
  /// settings, direction, locale, line limit and ellipsis. Lay it out with the
  /// paragraph's width, and dispose of it after use.
  TextPainter textPainter(BuildContext context) {
    final defaults = DefaultTextStyle.of(context);
    final own = style;
    var effectiveStyle = own == null || own.inherit ? defaults.style.merge(own) : own;
    if (MediaQuery.boldTextOf(context)) {
      // Text draws bold when the platform asks for bold text.
      effectiveStyle = effectiveStyle.merge(_bold);
    }
    // Text applies the platform's text-spacing settings (line height, letter
    // and word spacing) to every run; the runs here differ only in colour and
    // underline, so the root style carries them for all.
    final letterSpacing = MediaQuery.maybeLetterSpacingOverrideOf(context);
    effectiveStyle = effectiveStyle.merge(
      TextStyle(
        height: MediaQuery.maybeLineHeightScaleFactorOverrideOf(context),
        letterSpacing: letterSpacing, // check-rules: ignore — Text's spacing settings
        wordSpacing: MediaQuery.maybeWordSpacingOverrideOf(context),
      ),
    );
    final overflow = effectiveStyle.overflow ?? defaults.overflow;
    return TextPainter(
      text: TextSpan(style: effectiveStyle, children: [span(context)]),
      textAlign: textAlign ?? defaults.textAlign ?? TextAlign.start,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: defaults.maxLines,
      ellipsis: overflow == TextOverflow.ellipsis ? _ellipsis : null,
      locale: Localizations.maybeLocaleOf(context),
      textWidthBasis: defaults.textWidthBasis,
      textHeightBehavior: defaults.textHeightBehavior ?? DefaultTextHeightBehavior.maybeOf(context),
    );
  }

  @override
  Widget build(BuildContext context) => Text.rich(span(context), style: style, textAlign: textAlign);
}

/// The part of the text not drawn yet: laid out, but transparent.
const TextStyle _hidden = TextStyle(color: Colors.transparent);

/// What a paragraph ends with when TextOverflow.ellipsis cuts it short.
const String _ellipsis = '\u2026';

/// What Text adds for the platform's bold-text setting.
const TextStyle _bold = TextStyle(fontWeight: FontWeight.bold); // check-rules: ignore — Text's bold-text setting

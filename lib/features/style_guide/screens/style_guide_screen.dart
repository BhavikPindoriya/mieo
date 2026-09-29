import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/app_icon_button.dart';
import '../../../commons/widgets/responsive_content.dart';
import '../../../core/constants/localization_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/localization/language_cubit.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../models/models.dart';
import '../repositories/style_guide_repository.dart';
import '../widgets/color_swatch_tile.dart';
import '../widgets/palette_ramp.dart';
import '../widgets/style_guide_section.dart';
import '../widgets/token_grid.dart';
import '../widgets/token_samples.dart';
import '../widgets/type_style_row.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STYLE GUIDE SCREEN
//
// Renders every design token from the Figma Style Guide page (Colors and
// Typography) plus the spacing, radius and hard-shadow values the components
// use, through the app's real theme — so the build can be compared with Figma
// in both themes and both text directions. One scrolling column:
//
//   _Header            — title, subtitle and two actions: switch light/dark
//                        (ThemeCubit) and switch language (LanguageCubit).
//   _ColorsSection     — a swatch grid per Figma variable group, then the
//                        Shades palette.
//   _TypographySection — the 17 Mieo text styles with localised sample copy.
//   _SpacingSection, _RadiusSection, _ShadowSection — the dimension tokens.
//
// No state of its own: theme and language live in the app-wide cubits, so a
// switch here restyles the whole app, with the theme cross-fade and RTL flip.
// On tablets the grids gain columns instead of the content being capped.
// ─────────────────────────────────────────────────────────────────────────────
class StyleGuideScreen extends StatelessWidget {
  const StyleGuideScreen({super.key});

  static const StyleGuideRepository _repository = StyleGuideRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(vertical: ThemeConstants.spacing24),
          child: ResponsiveContent(
            maxWidth: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: ThemeConstants.spacing48,
              children: [
                const _Header(),
                _ColorsSection(groups: _repository.getColorGroups(), palette: _repository.getPalette()),
                _TypographySection(styles: _repository.getTypeStyles()),
                _SpacingSection(tokens: _repository.getSpacing()),
                _RadiusSection(tokens: _repository.getRadii()),
                _ShadowSection(tokens: _repository.getShadows()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Header ──
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeIcon = switch (Theme.of(context).brightness) {
      Brightness.light => Icons.dark_mode_rounded,
      Brightness.dark => Icons.light_mode_rounded,
    };
    final iconColor = context.colors.icon.neutral;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ThemeConstants.spacing12,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: ThemeConstants.spacing4,
            children: [
              Text(LangKeys.styleGuideTitle.tr, style: textTheme.headlineMedium),
              Text(
                LangKeys.styleGuideSubtitle.tr,
                style: textTheme.bodyMedium?.copyWith(color: context.colors.text.body),
              ),
            ],
          ),
        ),
        AppIconButton(
          icon: Icon(themeIcon, color: iconColor, size: ThemeConstants.iconSize24),
          semanticLabel: LangKeys.styleGuideSwitchTheme.tr,
          onPressed: () => _switchTheme(context),
        ),
        AppIconButton(
          icon: Icon(Icons.translate_rounded, color: iconColor, size: ThemeConstants.iconSize24),
          semanticLabel: LangKeys.styleGuideSwitchLanguage.tr,
          onPressed: () => _switchLanguage(context),
        ),
      ],
    );
  }

  void _switchTheme(BuildContext context) {
    final next = switch (Theme.of(context).brightness) {
      Brightness.light => ThemeMode.dark,
      Brightness.dark => ThemeMode.light,
    };
    context.read<ThemeCubit>().changeThemeMode(next);
  }

  /// Cycles through the supported languages; Directionality follows.
  void _switchLanguage(BuildContext context) {
    final cubit = context.read<LanguageCubit>();
    const locales = LocalizationConstants.supportedLocales;
    cubit.changeLocale(locales[(locales.indexOf(cubit.state) + 1) % locales.length]);
  }
}

// ── Colors ──
class _ColorsSection extends StatelessWidget {
  const _ColorsSection({required this.groups, required this.palette});

  final List<ColorTokenGroup> groups;
  final ColorRampGroup palette;

  @override
  Widget build(BuildContext context) {
    return StyleGuideSection(
      title: LangKeys.styleGuideColors.tr,
      children: [
        for (final group in groups)
          StyleGuideGroup(
            title: group.figmaName,
            child: TokenGrid(children: [for (final token in group.tokens) ColorSwatchTile(token: token)]),
          ),
        StyleGuideGroup(
          title: palette.figmaName,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: ThemeConstants.spacing16,
            children: [for (final ramp in palette.ramps) PaletteRamp(ramp: ramp)],
          ),
        ),
      ],
    );
  }
}

// ── Typography ──
class _TypographySection extends StatelessWidget {
  const _TypographySection({required this.styles});

  final List<TypeStyleToken> styles;

  @override
  Widget build(BuildContext context) {
    final sampleText = LangKeys.styleGuideSampleText.tr;
    return StyleGuideSection(
      title: LangKeys.styleGuideTypography.tr,
      children: [for (final style in styles) TypeStyleRow(token: style, sampleText: sampleText)],
    );
  }
}

// ── Spacing ──
class _SpacingSection extends StatelessWidget {
  const _SpacingSection({required this.tokens});

  final List<SizeToken> tokens;

  @override
  Widget build(BuildContext context) {
    return StyleGuideSection(
      title: LangKeys.styleGuideSpacing.tr,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ThemeConstants.spacing12,
          children: [for (final token in tokens) SpacingSample(token: token)],
        ),
      ],
    );
  }
}

// ── Radius ──
class _RadiusSection extends StatelessWidget {
  const _RadiusSection({required this.tokens});

  final List<SizeToken> tokens;

  @override
  Widget build(BuildContext context) {
    return StyleGuideSection(
      title: LangKeys.styleGuideRadius.tr,
      children: [
        Wrap(
          spacing: ThemeConstants.spacing24,
          runSpacing: ThemeConstants.spacing24,
          children: [for (final token in tokens) RadiusSample(token: token)],
        ),
      ],
    );
  }
}

// ── Hard shadows ──
class _ShadowSection extends StatelessWidget {
  const _ShadowSection({required this.tokens});

  final List<ShadowToken> tokens;

  @override
  Widget build(BuildContext context) {
    return StyleGuideSection(
      title: LangKeys.styleGuideShadows.tr,
      children: [
        TokenGrid(children: [for (final token in tokens) ShadowSample(token: token)]),
      ],
    );
  }
}

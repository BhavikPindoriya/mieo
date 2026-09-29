import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/fonts.dart';
import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STYLE GUIDE REPOSITORY
//
// The design tokens the style guide renders, in Figma order: the "Colors"
// variable groups (read from the active theme, so the screen shows the light or
// dark value), the Shades palette, the "Mieo/<role>/<size>" text styles, the
// spacing and radius scales and the hard-shadow looks of the components.
// Token names are Figma and Dart identifiers, not UI copy, so they are shown
// untranslated.
// ─────────────────────────────────────────────────────────────────────────────
class StyleGuideRepository {
  const StyleGuideRepository();

  /// Figma semantic colour variables, one group per variable path prefix.
  List<ColorTokenGroup> getColorGroups() => [
    ColorTokenGroup(
      figmaName: 'Surface',
      tokens: [
        ColorToken(figmaName: 'Surface/Body', dartName: 'surface.body', resolve: (colors) => colors.surface.body),
        ColorToken(
          figmaName: 'Surface/Background Nuturel',
          dartName: 'surface.backgroundNeutral',
          resolve: (colors) => colors.surface.backgroundNeutral,
        ),
        ColorToken(
          figmaName: 'Surface/Background Primacy',
          dartName: 'surface.backgroundPrimary',
          resolve: (colors) => colors.surface.backgroundPrimary,
        ),
        ColorToken(
          figmaName: 'Surface/Background Secondary',
          dartName: 'surface.backgroundSecondary',
          resolve: (colors) => colors.surface.backgroundSecondary,
        ),
        ColorToken(
          figmaName: 'Surface/Primary',
          dartName: 'surface.primary',
          resolve: (colors) => colors.surface.primary,
        ),
        ColorToken(
          figmaName: 'Surface/Secondary',
          dartName: 'surface.secondary',
          resolve: (colors) => colors.surface.secondary,
        ),
        ColorToken(figmaName: 'Surface/Green', dartName: 'surface.green', resolve: (colors) => colors.surface.green),
        ColorToken(figmaName: 'Surface/Red', dartName: 'surface.red', resolve: (colors) => colors.surface.red),
        ColorToken(
          figmaName: 'Surface/Nuturel',
          dartName: 'surface.neutral',
          resolve: (colors) => colors.surface.neutral,
        ),
        ColorToken(
          figmaName: 'Surface/Dim/primary',
          dartName: 'surface.dimPrimary',
          resolve: (colors) => colors.surface.dimPrimary,
        ),
        ColorToken(
          figmaName: 'Surface/Dim/secondary',
          dartName: 'surface.dimSecondary',
          resolve: (colors) => colors.surface.dimSecondary,
        ),
        ColorToken(
          figmaName: 'Surface/Dim/neutral',
          dartName: 'surface.dimNeutral',
          resolve: (colors) => colors.surface.dimNeutral,
        ),
        ColorToken(
          figmaName: 'Surface/Dim/success',
          dartName: 'surface.dimSuccess',
          resolve: (colors) => colors.surface.dimSuccess,
        ),
        ColorToken(
          figmaName: 'Surface/Dim/error',
          dartName: 'surface.dimError',
          resolve: (colors) => colors.surface.dimError,
        ),
        ColorToken(
          figmaName: 'Surface/Extra Dim/Primary',
          dartName: 'surface.extraDimPrimary',
          resolve: (colors) => colors.surface.extraDimPrimary,
        ),
        ColorToken(
          figmaName: 'Surface/Extra Dim/Secondary',
          dartName: 'surface.extraDimSecondary',
          resolve: (colors) => colors.surface.extraDimSecondary,
        ),
        ColorToken(
          figmaName: 'Surface/Extra Dim/Nuturel',
          dartName: 'surface.extraDimNeutral',
          resolve: (colors) => colors.surface.extraDimNeutral,
        ),
        ColorToken(
          figmaName: 'Surface/Sky/Top',
          dartName: 'surface.skyTop',
          resolve: (colors) => colors.surface.skyTop,
        ),
        ColorToken(
          figmaName: 'Surface/Sky/Bottom',
          dartName: 'surface.skyBottom',
          resolve: (colors) => colors.surface.skyBottom,
        ),
      ],
    ),
    ColorTokenGroup(
      figmaName: 'Texts',
      tokens: [
        ColorToken(figmaName: 'Texts/Heading', dartName: 'text.heading', resolve: (colors) => colors.text.heading),
        ColorToken(figmaName: 'Texts/Body Text', dartName: 'text.body', resolve: (colors) => colors.text.body),
        ColorToken(figmaName: 'Texts/primary', dartName: 'text.primary', resolve: (colors) => colors.text.primary),
        ColorToken(
          figmaName: 'Texts/Secondary',
          dartName: 'text.secondary',
          resolve: (colors) => colors.text.secondary,
        ),
        ColorToken(figmaName: 'Texts/Green', dartName: 'text.green', resolve: (colors) => colors.text.green),
        ColorToken(figmaName: 'Texts/Red', dartName: 'text.red', resolve: (colors) => colors.text.red),
        ColorToken(
          figmaName: 'Texts/On Surface/primary',
          dartName: 'text.onPrimary',
          resolve: (colors) => colors.text.onPrimary,
        ),
        ColorToken(
          figmaName: 'Texts/On Surface/secondary',
          dartName: 'text.onSecondary',
          resolve: (colors) => colors.text.onSecondary,
        ),
        ColorToken(
          figmaName: 'Texts/On Surface/secondary Green',
          dartName: 'text.onGreen',
          resolve: (colors) => colors.text.onGreen,
        ),
        ColorToken(
          figmaName: 'Texts/On Surface/secondary Red',
          dartName: 'text.onRed',
          resolve: (colors) => colors.text.onRed,
        ),
        ColorToken(
          figmaName: 'Texts/On Surface/Nuturel',
          dartName: 'text.onNeutral',
          resolve: (colors) => colors.text.onNeutral,
        ),
      ],
    ),
    ColorTokenGroup(
      figmaName: 'Icons',
      tokens: [
        ColorToken(figmaName: 'Icons/primary', dartName: 'icon.primary', resolve: (colors) => colors.icon.primary),
        ColorToken(figmaName: 'Icons/Nuturel', dartName: 'icon.neutral', resolve: (colors) => colors.icon.neutral),
        ColorToken(
          figmaName: 'Icons/On Surface/primary',
          dartName: 'icon.onPrimary',
          resolve: (colors) => colors.icon.onPrimary,
        ),
        ColorToken(
          figmaName: 'Icons/On Surface/Nuturel',
          dartName: 'icon.onNeutral',
          resolve: (colors) => colors.icon.onNeutral,
        ),
      ],
    ),
    ColorTokenGroup(
      figmaName: 'Stroke',
      tokens: [
        ColorToken(figmaName: 'Stroke/Primary', dartName: 'stroke.primary', resolve: (colors) => colors.stroke.primary),
        ColorToken(
          figmaName: 'Stroke/Secondary',
          dartName: 'stroke.secondary',
          resolve: (colors) => colors.stroke.secondary,
        ),
        ColorToken(figmaName: 'Stroke/Green', dartName: 'stroke.green', resolve: (colors) => colors.stroke.green),
        ColorToken(figmaName: 'Stroke/Green 2', dartName: 'stroke.green2', resolve: (colors) => colors.stroke.green2),
        ColorToken(figmaName: 'Stroke/Red', dartName: 'stroke.red', resolve: (colors) => colors.stroke.red),
        ColorToken(figmaName: 'Stroke/Nuturel', dartName: 'stroke.neutral', resolve: (colors) => colors.stroke.neutral),
        ColorToken(figmaName: 'Stroke/Body', dartName: 'stroke.body', resolve: (colors) => colors.stroke.body),
        ColorToken(
          figmaName: 'Stroke/Dim/primary',
          dartName: 'stroke.dimPrimary',
          resolve: (colors) => colors.stroke.dimPrimary,
        ),
        ColorToken(
          figmaName: 'Stroke/Dim/secondary',
          dartName: 'stroke.dimSecondary',
          resolve: (colors) => colors.stroke.dimSecondary,
        ),
        ColorToken(
          figmaName: 'Stroke/Dim/neutral',
          dartName: 'stroke.dimNeutral',
          resolve: (colors) => colors.stroke.dimNeutral,
        ),
        ColorToken(
          figmaName: 'Stroke/Dim/success',
          dartName: 'stroke.dimSuccess',
          resolve: (colors) => colors.stroke.dimSuccess,
        ),
        ColorToken(
          figmaName: 'Stroke/Dim/error',
          dartName: 'stroke.dimError',
          resolve: (colors) => colors.stroke.dimError,
        ),
        ColorToken(
          figmaName: 'Stroke/Extra Dim/Primary',
          dartName: 'stroke.extraDimPrimary',
          resolve: (colors) => colors.stroke.extraDimPrimary,
        ),
        ColorToken(
          figmaName: 'Stroke/Extra Dim/Secondary',
          dartName: 'stroke.extraDimSecondary',
          resolve: (colors) => colors.stroke.extraDimSecondary,
        ),
        ColorToken(
          figmaName: 'Stroke/Extra Dim/Nuturel',
          dartName: 'stroke.extraDimNeutral',
          resolve: (colors) => colors.stroke.extraDimNeutral,
        ),
      ],
    ),
    ColorTokenGroup(
      figmaName: 'Shadow',
      tokens: [
        ColorToken(
          figmaName: 'Shadow/Primary/Full',
          dartName: 'shadow.primaryFull',
          resolve: (colors) => colors.shadow.primaryFull,
        ),
        ColorToken(
          figmaName: 'Shadow/Primary/Darker',
          dartName: 'shadow.primaryDarker',
          resolve: (colors) => colors.shadow.primaryDarker,
        ),
        ColorToken(
          figmaName: 'Shadow/Primary/Lighter',
          dartName: 'shadow.primaryLighter',
          resolve: (colors) => colors.shadow.primaryLighter,
        ),
        ColorToken(
          figmaName: 'Shadow/Secondary',
          dartName: 'shadow.secondary',
          resolve: (colors) => colors.shadow.secondary,
        ),
        ColorToken(
          figmaName: 'Shadow/Secondary/Full',
          dartName: 'shadow.secondaryFull',
          resolve: (colors) => colors.shadow.secondaryFull,
        ),
        ColorToken(
          figmaName: 'Shadow/Secondary/Darker',
          dartName: 'shadow.secondaryDarker',
          resolve: (colors) => colors.shadow.secondaryDarker,
        ),
        ColorToken(
          figmaName: 'Shadow/Secondary/Lighter',
          dartName: 'shadow.secondaryLighter',
          resolve: (colors) => colors.shadow.secondaryLighter,
        ),
        ColorToken(
          figmaName: 'Shadow/Green/Darker',
          dartName: 'shadow.greenDarker',
          resolve: (colors) => colors.shadow.greenDarker,
        ),
        ColorToken(
          figmaName: 'Shadow/Green/Lighter',
          dartName: 'shadow.greenLighter',
          resolve: (colors) => colors.shadow.greenLighter,
        ),
        ColorToken(
          figmaName: 'Shadow/Red/Red',
          dartName: 'shadow.redDarker',
          resolve: (colors) => colors.shadow.redDarker,
        ),
        ColorToken(
          figmaName: 'Shadow/Red/Lighter',
          dartName: 'shadow.redLighter',
          resolve: (colors) => colors.shadow.redLighter,
        ),
        ColorToken(
          figmaName: 'Shadow/Nutural/Full',
          dartName: 'shadow.neutralFull',
          resolve: (colors) => colors.shadow.neutralFull,
        ),
        ColorToken(
          figmaName: 'Shadow/Nutural/Darker',
          dartName: 'shadow.neutralDarker',
          resolve: (colors) => colors.shadow.neutralDarker,
        ),
        ColorToken(
          figmaName: 'Shadow/Nutural/Light',
          dartName: 'shadow.neutralLight',
          resolve: (colors) => colors.shadow.neutralLight,
        ),
        ColorToken(
          figmaName: 'Shadow/Nutural/Extra Light',
          dartName: 'shadow.neutralExtraLight',
          resolve: (colors) => colors.shadow.neutralExtraLight,
        ),
      ],
    ),
    ColorTokenGroup(
      figmaName: 'Cloud Color',
      tokens: [
        ColorToken(figmaName: 'Cloud Color/1', dartName: 'cloud.layer1', resolve: (colors) => colors.cloud.layer1),
        ColorToken(figmaName: 'Cloud Color/2', dartName: 'cloud.layer2', resolve: (colors) => colors.cloud.layer2),
        ColorToken(figmaName: 'Cloud Color/3', dartName: 'cloud.layer3', resolve: (colors) => colors.cloud.layer3),
      ],
    ),
  ];

  /// Figma `Shades/*` primitives, one ramp per colour family.
  ColorRampGroup getPalette() => const ColorRampGroup(
    figmaName: 'Shades',
    ramps: [
      ColorRamp(
        figmaName: 'Shades/primary',
        colors: [
          AppColors.primary50,
          AppColors.primary100,
          AppColors.primary200,
          AppColors.primary300,
          AppColors.primary400,
          AppColors.primary500,
          AppColors.primary600,
          AppColors.primary700,
          AppColors.primary800,
          AppColors.primary900,
          AppColors.primary950,
        ],
      ),
      ColorRamp(
        figmaName: 'Shades/secondary',
        colors: [
          AppColors.secondary50,
          AppColors.secondary100,
          AppColors.secondary200,
          AppColors.secondary300,
          AppColors.secondary400,
          AppColors.secondary500,
          AppColors.secondary600,
          AppColors.secondary700,
          AppColors.secondary800,
          AppColors.secondary900,
          AppColors.secondary950,
        ],
      ),
      ColorRamp(
        figmaName: 'Shades/ternary',
        colors: [
          AppColors.ternary50,
          AppColors.ternary100,
          AppColors.ternary200,
          AppColors.ternary300,
          AppColors.ternary400,
          AppColors.ternary500,
          AppColors.ternary600,
          AppColors.ternary700,
          AppColors.ternary800,
          AppColors.ternary900,
          AppColors.ternary950,
        ],
      ),
      ColorRamp(
        figmaName: 'Shades/neutral',
        colors: [
          AppColors.neutral50,
          AppColors.neutral100,
          AppColors.neutral200,
          AppColors.neutral300,
          AppColors.neutral400,
          AppColors.neutral500,
          AppColors.neutral600,
          AppColors.neutral700,
          AppColors.neutral800,
          AppColors.neutral900,
          AppColors.neutral950,
        ],
      ),
      ColorRamp(
        figmaName: 'Shades/Success',
        colors: [
          AppColors.success50,
          AppColors.success100,
          AppColors.success200,
          AppColors.success300,
          AppColors.success400,
          AppColors.success500,
          AppColors.success600,
          AppColors.success700,
          AppColors.success800,
          AppColors.success900,
          AppColors.success950,
        ],
      ),
      ColorRamp(
        figmaName: 'Shades/error',
        colors: [
          AppColors.error50,
          AppColors.error100,
          AppColors.error200,
          AppColors.error300,
          AppColors.error400,
          AppColors.error500,
          AppColors.error600,
          AppColors.error700,
          AppColors.error800,
          AppColors.error900,
          AppColors.error950,
        ],
      ),
      ColorRamp(
        figmaName: 'Shades/warning',
        colors: [
          AppColors.warning50,
          AppColors.warning100,
          AppColors.warning200,
          AppColors.warning300,
          AppColors.warning400,
          AppColors.warning500,
          AppColors.warning600,
          AppColors.warning700,
          AppColors.warning800,
          AppColors.warning900,
          AppColors.warning950,
        ],
      ),
    ],
  );

  /// Figma `Mieo/<role>/<size>` text styles, in Style Guide order.
  List<TypeStyleToken> getTypeStyles() => [
    TypeStyleToken(
      figmaName: 'Mieo/display/large',
      role: 'displayLarge',
      weightName: 'Black',
      resolve: (textTheme) => textTheme.displayLarge,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/display/medium',
      role: 'displayMedium',
      weightName: 'Black',
      resolve: (textTheme) => textTheme.displayMedium,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/display/small',
      role: 'displaySmall',
      weightName: 'ExtraBold',
      resolve: (textTheme) => textTheme.displaySmall,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/headline/large',
      role: 'headlineLarge',
      weightName: 'Black',
      resolve: (textTheme) => textTheme.headlineLarge,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/headline/medium',
      role: 'headlineMedium',
      weightName: 'ExtraBold',
      resolve: (textTheme) => textTheme.headlineMedium,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/headline/small',
      role: 'headlineSmall',
      weightName: 'Bold',
      resolve: (textTheme) => textTheme.headlineSmall,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/title/large',
      role: 'titleLarge',
      weightName: 'ExtraBold',
      resolve: (textTheme) => textTheme.titleLarge,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/title/medium',
      role: 'titleMedium',
      weightName: 'ExtraBold',
      resolve: (textTheme) => textTheme.titleMedium,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/title/small',
      role: 'titleSmall',
      weightName: 'ExtraBold',
      resolve: (textTheme) => textTheme.titleSmall,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/body/large',
      role: 'bodyLarge',
      weightName: 'Medium',
      resolve: (textTheme) => textTheme.bodyLarge,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/body/medium',
      role: 'bodyMedium',
      weightName: 'Medium',
      resolve: (textTheme) => textTheme.bodyMedium,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/body/small',
      role: 'bodySmall',
      weightName: 'Medium',
      resolve: (textTheme) => textTheme.bodySmall,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/label/large - prominent',
      role: 'labelLargeProminent',
      weightName: 'SemiBold',
      resolve: (textTheme) => textTheme.labelLargeProminent,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/label/large',
      role: 'labelLarge',
      weightName: 'Medium',
      resolve: (textTheme) => textTheme.labelLarge,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/label/medium - prominent',
      role: 'labelMediumProminent',
      weightName: 'SemiBold',
      resolve: (textTheme) => textTheme.labelMediumProminent,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/label/medium',
      role: 'labelMedium',
      weightName: 'Medium',
      resolve: (textTheme) => textTheme.labelMedium,
    ),
    TypeStyleToken(
      figmaName: 'Mieo/label/small',
      role: 'labelSmall',
      weightName: 'Medium',
      resolve: (textTheme) => textTheme.labelSmall,
    ),
  ];

  /// Figma `Spacing/*` variables.
  List<SizeToken> getSpacing() => const [
    SizeToken(name: 'spacing4', figmaName: 'Spacing/0,5', value: ThemeConstants.spacing4),
    SizeToken(name: 'spacing8', figmaName: 'Spacing/1', value: ThemeConstants.spacing8),
    SizeToken(name: 'spacing12', figmaName: 'Spacing/1,5', value: ThemeConstants.spacing12),
    SizeToken(name: 'spacing16', figmaName: 'Spacing/2', value: ThemeConstants.spacing16),
    SizeToken(name: 'spacing24', figmaName: 'Spacing/3', value: ThemeConstants.spacing24),
    SizeToken(name: 'spacing32', figmaName: 'Spacing/4', value: ThemeConstants.spacing32),
    SizeToken(name: 'spacing40', figmaName: 'Spacing/5', value: ThemeConstants.spacing40),
    SizeToken(name: 'spacing48', figmaName: 'Spacing/6', value: ThemeConstants.spacing48),
    SizeToken(name: 'spacing64', figmaName: 'Spacing/8', value: ThemeConstants.spacing64),
    SizeToken(name: 'spacing80', figmaName: 'Spacing/10', value: ThemeConstants.spacing80),
    SizeToken(name: 'spacing96', figmaName: 'Spacing/12', value: ThemeConstants.spacing96),
    SizeToken(name: 'spacing128', figmaName: 'Spacing/16', value: ThemeConstants.spacing128),
  ];

  /// The corner radii the components use.
  List<SizeToken> getRadii() => const [
    SizeToken(name: 'radius8', value: ThemeConstants.radius8),
    SizeToken(name: 'radius12', value: ThemeConstants.radius12),
    SizeToken(name: 'radius16', value: ThemeConstants.radius16),
    SizeToken(name: 'radius24', value: ThemeConstants.radius24),
    SizeToken(name: 'radiusPill', value: ThemeConstants.radiusPill),
  ];

  /// The hard-shadow looks of the components: fields and cards (neutral),
  /// focused field, outlined button, then the filled button families.
  List<ShadowToken> getShadows() => [
    ShadowToken(
      figmaName: 'Shadow/Nutural/Extra Light',
      offset: ThemeConstants.hardShadowOffsetSm,
      fill: (colors) => colors.surface.backgroundNeutral,
      border: (colors) => colors.stroke.extraDimNeutral,
      shadow: (colors) => colors.shadow.neutralExtraLight,
    ),
    ShadowToken(
      figmaName: 'Shadow/Nutural/Extra Light',
      offset: ThemeConstants.hardShadowOffset,
      fill: (colors) => colors.surface.backgroundNeutral,
      border: (colors) => colors.stroke.extraDimNeutral,
      shadow: (colors) => colors.shadow.neutralExtraLight,
    ),
    ShadowToken(
      figmaName: 'Shadow/Primary/Full',
      offset: ThemeConstants.hardShadowOffsetSm,
      fill: (colors) => colors.surface.backgroundNeutral,
      border: (colors) => colors.stroke.primary,
      shadow: (colors) => colors.shadow.primaryFull,
    ),
    ShadowToken(
      figmaName: 'Shadow/Nutural/Full',
      offset: ThemeConstants.hardShadowOffset,
      fill: (colors) => colors.surface.backgroundNeutral,
      border: (colors) => colors.stroke.neutral,
      shadow: (colors) => colors.shadow.neutralFull,
    ),
    ShadowToken(
      figmaName: 'Shadow/Primary/Darker',
      offset: ThemeConstants.hardShadowOffset,
      fill: (colors) => colors.surface.primary,
      shadow: (colors) => colors.shadow.primaryDarker,
    ),
    ShadowToken(
      figmaName: 'Shadow/Secondary/Darker',
      offset: ThemeConstants.hardShadowOffset,
      fill: (colors) => colors.surface.secondary,
      shadow: (colors) => colors.shadow.secondaryDarker,
    ),
    ShadowToken(
      figmaName: 'Shadow/Green/Darker',
      offset: ThemeConstants.hardShadowOffset,
      fill: (colors) => colors.surface.green,
      shadow: (colors) => colors.shadow.greenDarker,
    ),
    ShadowToken(
      figmaName: 'Shadow/Red/Red',
      offset: ThemeConstants.hardShadowOffset,
      fill: (colors) => colors.surface.red,
      shadow: (colors) => colors.shadow.redDarker,
    ),
  ];
}

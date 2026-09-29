# Mieo — design tokens (Figma → Flutter)

Every variable and style from the Figma **Style Guide 🎨** page (`4:7527`) and how the code exposes it.
Colour values were read from the Figma variables and verified one by one against the live file
(144/144 match in both modes). When the design changes, update `lib/core/theme/colors.dart`,
this table and `test/theme_test.dart` together.

- **File:** [Mieo — Language Learning](https://www.figma.com/design/mWILt2PBmTonssE3Z7uSgU/Mieo---Language-Learning?node-id=2158-14549&m=dev) (key `mWILt2PBmTonssE3Z7uSgU`)
- **Style Guide frames:** Colors `2158:14549` (every token with its Light and Dark value), Typography `19:24`
- **Variable collections:** `Colors` (144 variables, modes **Light** / **Dark**), `Typography` (23),
  `Spacing & Radius` (33), `Logics` (13: dummy data and flags)
- **Live preview:** the app's Style Guide screen (`lib/features/style_guide/`, route `/style-guide`) renders all
  of these through the real theme. Switch theme and language there to check both modes and both text directions.

## 1. Colours

Widgets read semantic tokens with `context.colors.<group>.<token>` (an `AppColorTokens` ThemeExtension
registered by `AppTheme`). The value follows the active theme and interpolates while the theme animates.
Primitives (`AppColors.*`) are used only where a Figma node is bound directly to a `Shades/*` variable.

Names in Figma keep the designer's spelling (`Nuturel`, `Nutural`, `Primacy`); the Dart names are corrected
(`neutral`, `primary`). Match on the Figma variable name in this table.

### Texts/* → `context.colors.text`

| Figma variable | Dart | Light | Dark |
|---|---|---|---|
| `Texts/Heading` | `context.colors.text.heading` | `#171A1C` (Shades/neutral/900) | `#E3E6E8` (Shades/neutral/100) |
| `Texts/Body Text` | `context.colors.text.body` | `#5D686F` (Shades/neutral/600) | `#ADB5BA` (Shades/neutral/300) |
| `Texts/primary` | `context.colors.text.primary` | `#1AB3FF` (Shades/primary/950) | `#1AB3FF` (Shades/primary/950) |
| `Texts/Secondary` | `context.colors.text.secondary` | `#FFCB61` (Shades/secondary/700) | `#FFCB61` (Shades/secondary/700) |
| `Texts/Green` | `context.colors.text.green` | `#34C759` (Shades/Success/400) | `#34C759` (Shades/Success/400) |
| `Texts/Red` | `context.colors.text.red` | `#DD3636` | `#DD3636` |
| `Texts/On Surface/primary` | `context.colors.text.onPrimary` | `#F5FCFF` (Shades/primary/50) | `#F5FCFF` (Shades/primary/50) |
| `Texts/On Surface/secondary` | `context.colors.text.onSecondary` | `#FFFFFF` (Shades/secondary/50) | `#FFFFFF` (Shades/secondary/50) |
| `Texts/On Surface/secondary Green` | `context.colors.text.onGreen` | `#F0FFF4` | `#F0FFF4` |
| `Texts/On Surface/secondary Red` | `context.colors.text.onRed` | `#FFF0F0` | `#FFF0F0` |
| `Texts/On Surface/Nuturel` | `context.colors.text.onNeutral` | `#FFFFFF` (Shades/neutral/50) | `#464E53` (Shades/neutral/700) |

### Icons/* → `context.colors.icon`

| Figma variable | Dart | Light | Dark |
|---|---|---|---|
| `Icons/primary` | `context.colors.icon.primary` | `#59C8FF` (Shades/primary/700) | `#1AB3FF` (Shades/primary/950) |
| `Icons/Nuturel` | `context.colors.icon.neutral` | `#464E53` (Shades/neutral/700) | `#C7CDD1` (Shades/neutral/200) |
| `Icons/On Surface/primary` | `context.colors.icon.onPrimary` | `#F5FCFF` (Shades/primary/50) | `#F5FCFF` (Shades/primary/50) |
| `Icons/On Surface/Nuturel` | `context.colors.icon.onNeutral` | `#FFFFFF` (Shades/neutral/50) | `#464E53` (Shades/neutral/700) |

### Surface/* → `context.colors.surface`

| Figma variable | Dart | Light | Dark |
|---|---|---|---|
| `Surface/Body` | `context.colors.surface.body` | `#FAFAFA` | `#171A1C` (Shades/neutral/900) |
| `Surface/Background Nuturel` | `context.colors.surface.backgroundNeutral` | `#FFFFFF` | `#2E3438` (Shades/neutral/800) |
| `Surface/Background Primacy` | `context.colors.surface.backgroundPrimary` | `#F5FCFF` (Shades/primary/50) | `#171A1C` (Shades/neutral/900) → Surface/Body |
| `Surface/Background Secondary` | `context.colors.surface.backgroundSecondary` | `#FFFFFF` | `#2F2002` |
| `Surface/Primary` | `context.colors.surface.primary` | `#59C8FF` (Shades/primary/700) | `#1AB3FF` (Shades/primary/950) |
| `Surface/Secondary` | `context.colors.surface.secondary` | `#FFCB61` (Shades/secondary/700) | `#FFCB61` (Shades/secondary/700) |
| `Surface/Green` | `context.colors.surface.green` | `#34C759` (Shades/Success/400) | `#34C759` (Shades/Success/400) |
| `Surface/Red` | `context.colors.surface.red` | `#DD3636` | `#DD3636` |
| `Surface/Nuturel` | `context.colors.surface.neutral` | `#464E53` (Shades/neutral/700) | `#FFFFFF` (Shades/neutral/50) |
| `Surface/Dim/primary` | `context.colors.surface.dimPrimary` | `#DFF4FF` (Shades/primary/100) | `#1AB3FF 16%` |
| `Surface/Dim/secondary` | `context.colors.surface.dimSecondary` | `#FFF1D3` (Shades/secondary/200) | `#FFB724 12%` |
| `Surface/Dim/neutral` | `context.colors.surface.dimNeutral` | `#ADB5BA` (Shades/neutral/300) | `#464E53` (Shades/neutral/700) |
| `Surface/Dim/success` | `context.colors.surface.dimSuccess` | `#EDFFF2` | `#1A2F24` |
| `Surface/Dim/error` | `context.colors.surface.dimError` | `#FFEDED` | `#2E1D1F` |
| `Surface/Extra Dim/Primary` | `context.colors.surface.extraDimPrimary` | `#F5FCFF` (Shades/primary/50) | `#1AB3FF 12%` |
| `Surface/Extra Dim/Secondary` | `context.colors.surface.extraDimSecondary` | `#FFF8E9` (Shades/secondary/100) | `#FFCB61 5%` |
| `Surface/Extra Dim/Nuturel` | `context.colors.surface.extraDimNeutral` | `#E3E6E8` (Shades/neutral/100) | `#464E53` (Shades/neutral/700) |
| `Surface/Sky/Top` | `context.colors.surface.skyTop` | `#B3E6FF` (Shades/primary/300) | `#FFFFFF 8%` |
| `Surface/Sky/Bottom` | `context.colors.surface.skyBottom` | `#FFFFFF` | `#FFFFFF 0%` |

### Stroke/* → `context.colors.stroke`

| Figma variable | Dart | Light | Dark |
|---|---|---|---|
| `Stroke/Primary` | `context.colors.stroke.primary` | `#59C8FF` (Shades/primary/700) | `#1AB3FF` (Shades/primary/950) |
| `Stroke/Secondary` | `context.colors.stroke.secondary` | `#FFCB61` (Shades/secondary/700) | `#FFCB61` (Shades/secondary/700) |
| `Stroke/Green` | `context.colors.stroke.green` | `#34C759` (Shades/Success/400) | `#34C759` (Shades/Success/400) |
| `Stroke/Green 2` | `context.colors.stroke.green2` | `#34C759` | `#34C759` |
| `Stroke/Red` | `context.colors.stroke.red` | `#DD3636` | `#DD3636` |
| `Stroke/Nuturel` | `context.colors.stroke.neutral` | `#464E53` (Shades/neutral/700) | `#E3E6E8` (Shades/neutral/100) |
| `Stroke/Body` | `context.colors.stroke.body` | `#FFFFFF` | `#FFFFFF` |
| `Stroke/Dim/primary` | `context.colors.stroke.dimPrimary` | `#C9EDFF` (Shades/primary/200) | `#464E53` (Shades/neutral/700) |
| `Stroke/Dim/secondary` | `context.colors.stroke.dimSecondary` | `#FFF1D3` (Shades/secondary/200) | `#FFCB61 12%` |
| `Stroke/Dim/neutral` | `context.colors.stroke.dimNeutral` | `#ADB5BA` (Shades/neutral/300) | `#E3E6E8 12%` |
| `Stroke/Dim/success` | `context.colors.stroke.dimSuccess` | `#EDFFF2` | `#217E38` (Shades/Success/700) |
| `Stroke/Dim/error` | `context.colors.stroke.dimError` | `#F5C3C3` | `#DD3636` → Texts/Red |
| `Stroke/Extra Dim/Primary` | `context.colors.stroke.extraDimPrimary` | `#F5FCFF` (Shades/primary/50) | `#F5FCFF` (Shades/primary/50) |
| `Stroke/Extra Dim/Secondary` | `context.colors.stroke.extraDimSecondary` | `#FFF8E9` (Shades/secondary/100) | `#FFF8E9` (Shades/secondary/100) |
| `Stroke/Extra Dim/Nuturel` | `context.colors.stroke.extraDimNeutral` | `#E3E6E8` (Shades/neutral/100) | `#464E53` (Shades/neutral/700) |

### Shadow/* → `context.colors.shadow`

| Figma variable | Dart | Light | Dark |
|---|---|---|---|
| `Shadow/Primary/Full` | `context.colors.shadow.primaryFull` | `#1AB3FF` | `#1AB3FF` |
| `Shadow/Primary/Darker` | `context.colors.shadow.primaryDarker` | `#3E8CB2` | `#006EA4` |
| `Shadow/Primary/Lighter` | `context.colors.shadow.primaryLighter` | `#C9EDFF` | `#464E53` (Shades/neutral/700) |
| `Shadow/Secondary` | `context.colors.shadow.secondary` | `#996E16` | `#996E16` |
| `Shadow/Secondary/Full` | `context.colors.shadow.secondaryFull` | `#FFCB61` | `#996E16` |
| `Shadow/Secondary/Darker` | `context.colors.shadow.secondaryDarker` | `#996E16` | `#FFF1D3` |
| `Shadow/Secondary/Lighter` | `context.colors.shadow.secondaryLighter` | `#FFF1D3` (Shades/secondary/200) | `#3F2D0C` |
| `Shadow/Green/Darker` | `context.colors.shadow.greenDarker` | `#217E38` (Shades/Success/700) | `#217E38` (Shades/Success/700) |
| `Shadow/Green/Lighter` | `context.colors.shadow.greenLighter` | `#A6E8B7` (Shades/Success/50) | `#34C759` (Shades/Success/400) |
| `Shadow/Red/Red` | `context.colors.shadow.redDarker` | `#A51C1C` (Shades/error/900) | `#A51C1C` (Shades/error/900) |
| `Shadow/Red/Lighter` | `context.colors.shadow.redLighter` | `#F5C3C3` | `#DD3636` (Shades/error/700) |
| `Shadow/Nutural/Full` | `context.colors.shadow.neutralFull` | `#464E53` | `#E3E6E8` |
| `Shadow/Nutural/Darker` | `context.colors.shadow.neutralDarker` | `#000000` | `#000000` |
| `Shadow/Nutural/Light` | `context.colors.shadow.neutralLight` | `#ADB5BA` | `#5D686F` |
| `Shadow/Nutural/Extra Light` | `context.colors.shadow.neutralExtraLight` | `#E3E6E8` | `#464E53` |

### Cloud Color/* → `context.colors.cloud`

| Figma variable | Dart | Light | Dark |
|---|---|---|---|
| `Cloud Color/1` | `context.colors.cloud.layer1` | `#FFFFFF` | `#2A2D30` |
| `Cloud Color/2` | `context.colors.cloud.layer2` | `#E9F7FF` | `#414548` |
| `Cloud Color/3` | `context.colors.cloud.layer3` | `#CFEBFF` | `#535B5F` |

### Primitives — `Shades/*` → `AppColors` (same in both modes)

| Family | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | 950 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `Shades/primary/*` → `AppColors.primary<step>` | `F5FCFF` | `DFF4FF` | `C9EDFF` | `B3E6FF` | `9DDFFF` | `87D7FF` | `71D0FF` | `59C8FF` | `45C1FF` | `2FBAFF` | `1AB3FF` |
| `Shades/secondary/*` → `AppColors.secondary<step>` | `FFFFFF` | `FFF8E9` | `FFF1D3` | `FFE9BD` | `FFE2A7` | `FFDB91` | `FFD47B` | `FFCB61` | `FFC550` | `FFBE3A` | `FFB724` |
| `Shades/ternary/*` → `AppColors.ternary<step>` | `FFFFFF` | `FFEEE5` | `FFDCCB` | `FFCBB1` | `FFB997` | `FFA87D` | `FF9663` | `FF894F` | `FF732F` | `FF6215` | `FA5200` |
| `Shades/neutral/*` → `AppColors.neutral<step>` | `FFFFFF` | `E3E6E8` | `C7CDD1` | `ADB5BA` | `909BA2` | `74818B` | `5D686F` | `464E53` | `2E3438` | `171A1C` | `000000` |
| `Shades/Success/*` → `AppColors.success<step>` | `A6E8B7` | `8BE1A1` | `70DA8A` | `55D374` | `34C759` | `2FB450` | `289944` | `217E38` | `1A632C` | `134820` | `0C2C14` |
| `Shades/error/*` → `AppColors.error<step>` | `FFFFFF` | `FAE1E1` | `F5C3C3` | `F0A5A5` | `EB8787` | `E56969` | `E04A4A` | `DD3636` | `C32121` | `A51C1C` | `871717` |
| `Shades/warning/warning-*` → `AppColors.warning<step>` | `FEFEFC` | `FDF9F1` | `FAF2E0` | `F6E7C7` | `F1DAA8` | `EBC981` | `E3B654` | `D79E23` | `785814` | `3F2E0A` | `2C2007` |

**Not bound to variables:** illustration fills (scene art, mascot, avatars, badges, 3D emoji icons) use raw
colours that are identical in both themes. The Dark Theme page is the Light Theme page with the `Colors`
collection switched to Dark, so anything not bound to a variable does not change in dark mode. Illustrations
drawn in code take their raw fills from `ArtworkColors` (`colors.dart`): `mieoFur` `#FF8731`, `mieoPaw`
`#FFAC71`, `mieoTongue` `#FF5555`, `mieoCheekShadow` `#CC6C27` and `mieoArmShadow` `#D46515` (the code-drawn Mieo
poses); raw black and white come from `AppColors.neutral950` / `neutral50`.

## 2. Typography — `Mieo/<role>/<size>` → `Theme.of(context).textTheme.<role>`

Family **Nunito** (one variable font, `assets/fonts/Nunito-VariableFont.ttf`; Flutter maps `fontWeight` onto its
`wght` axis). Every Figma style uses line height **Auto**, which is Nunito's natural line height
(ascent + descent = 1.364 × size). The Flutter styles are `inherit: false` with no `height`, so Material's default
text geometry (line height 1.43–1.5) is not merged in. `test/typography_test.dart` checks each line's pixel height
against Figma.

| Figma style | Flutter role | Weight | Size | Letter spacing | Line (Auto) |
|---|---|---|---|---|---|
| `Mieo/display/large` | `displayLarge` | Black 900 | 57 (`font/size/6XL`) | -0.25 | 78 |
| `Mieo/display/medium` | `displayMedium` | Black 900 | 45 (`5XL`) | 0 | 61 |
| `Mieo/display/small` | `displaySmall` | ExtraBold 800 | 36 (`4XL`) | 0 | 49 |
| `Mieo/headline/large` | `headlineLarge` | Black 900 | 32 (`3XL`) | 0 | 44 |
| `Mieo/headline/medium` | `headlineMedium` | ExtraBold 800 | 28 (`2XL`) | 0 | 38 |
| `Mieo/headline/small` | `headlineSmall` | Bold 700 | 24 (`1XL`) | 0 | 33 |
| `Mieo/title/large` | `titleLarge` | ExtraBold 800 | 22 (`XL`) | 0 | 30 |
| `Mieo/title/medium` | `titleMedium` | ExtraBold 800 | 16 (`L`) | 0.15 | 22 |
| `Mieo/title/small` | `titleSmall` | ExtraBold 800 | 14 (`M`) | 0.1 | 19 |
| `Mieo/body/large` | `bodyLarge` | Medium 500 | 16 (`L`) | 0.5 | 22 |
| `Mieo/body/medium` | `bodyMedium` | Medium 500 | 14 (`M`) | 0.25 | 19 |
| `Mieo/body/small` | `bodySmall` | Medium 500 | 12 (`S`) | 0 | 16 |
| `Mieo/label/large - prominent` | `labelLargeProminent` (extension) | SemiBold 600 | 14 (`M`) | 0.1 | 19 |
| `Mieo/label/large` | `labelLarge` | Medium 500 | 14 (`M`) | 0.1 | 19 |
| `Mieo/label/medium - prominent` | `labelMediumProminent` (extension) | SemiBold 600 | 12 (`S`) | 0.5 | 16 |
| `Mieo/label/medium` | `labelMedium` | Medium 500 | 12 (`S`) | 0.5 | 16 |
| `Mieo/label/small` | `labelSmall` | Medium 500 | 11 (`XS`) | 0.5 | 15 |

`font/*` variables are mirrored in `AppFonts` (`size6xl … sizeXs`, `letterSpacingXs … letterSpacingXl`,
`medium … black`). Never override size, weight or letter spacing in a widget (enforced by `tool/check_rules.sh`).

## 3. Spacing — `Spacing/*` → `ThemeConstants.spacingN`

| Figma | Dart | px |
|---|---|---|
| `Spacing/0,5 (4px)` | `spacing4` | 4 |
| `Spacing/1 (8px)` | `spacing8` | 8 |
| `Spacing/1,5 (12px)` | `spacing12` | 12 |
| `Spacing/2 (16px)` | `spacing16` | 16 |
| `Spacing/3 (24px)` | `spacing24` | 24 |
| — (no variable: the Login / Create Profile "Container" gap) | `spacing28` | 28 |
| `Spacing/4 (32px)` | `spacing32` | 32 |
| `Spacing/5 (40px)` | `spacing40` | 40 |
| `Spacing/6 (48px)` | `spacing48` | 48 |
| `Spacing/8 (64px)` | `spacing64` | 64 |
| `Spacing/10 (80px)` | `spacing80` | 80 |
| `Spacing/12 (96px)` | `spacing96` | 96 |
| `Spacing/16 (128px)` | `spacing128` | 128 |

The collection continues to 3840px (desktop scales); nothing in the mobile/tablet design uses those. Gaps the
design repeats without a variable (10, 6, 18…) are added to `ThemeConstants` with a comment when first needed.

## 4. Radius, border, hard shadow, grid

| Token | Value | Source |
|---|---|---|
| `ThemeConstants.radius8 / radius12 / radius16 / radius24` | 8 / 12 / 16 / 24 | Radii the components use (no Figma variables). 16 = buttons, cards; 12 = text fields |
| `ThemeConstants.radiusPill` | 1000 | Pills, chips, circles (Figma uses 100 and 1000) |
| `ThemeConstants.borderWidth` + `borderStrokeAlign` | 1.5, outside | Figma `Border`. Component strokes are drawn **outside**, so they never change layout size → `AppBorders.outline(color)` |
| `Border.all(color: …)` (defaults) | 1, inside | Tags and small badges: the Onboarding "Tag" draws a 1px `Stroke/Dim/primary` inside its frame, which is Flutter's default border width and alignment |
| `ThemeConstants.buttonHeight` | 48 | Figma Button: the label box with 14 above and below |
| `ThemeConstants.fieldHeight` | 52 | Figma Input Field and the social sign-in buttons: a 24 icon with 14 above and below |
| `ThemeConstants.hardShadowOffset` / `hardShadowOffsetSm` | 4 / 2 | Figma drop shadows x 0, y 4 or 2, blur 0, spread 0 → `AppShadows.hard(color, offset: …)` (spreads by the border width on bordered components, because Figma casts the shadow from the outline too). Feedback sheets use y -4 |
| Layout Grid style | 4 columns, gutter 16, margin 16 | `ThemeConstants.screenPaddingHorizontal`, `gridGutter` |
| Design frame | 375 × 812 @1x | Figma px = Flutter logical px |

Most used hard shadows in the screens: `Shadow/Nutural/Extra Light` y2 (fields, tiles) and y4 (cards),
`Shadow/Primary/Darker` y4 (filled buttons), `Shadow/Primary/Lighter` y2 (primary chips), `Shades/primary/700`
y2 (selected), `Shadow/Primary/Full` y4 (focused/selected), `Shadow/Nutural/Full` y4 (outlined buttons),
`Shadow/Red/Lighter` and `Shadow/Primary/Lighter` y-4 (sheet top edges).

## 5. Logics collection — dummy data

| Figma variable | Value | Use |
|---|---|---|
| `Entry Flow/Main User/Username` | Jenny | greeting, profile |
| `Entry Flow/Main User/Full Name` | Jenny Frost | profile |
| `Entry Flow/Main User/Email Address` | jennyfrost@gmail.com | login, profile |
| `Entry Flow/Main User/Mobile Number` | 1234567936 | edit profile |
| `Entry Flow/Main User/Gender` / `Age` | Female / 6 | edit profile (Create Profile's screen shows age 8, which its dummy data follows) |
| `Performance/Total XP` | 252 | leaderboard, profile |
| `Performance/Streak Days` | 25 | streak |
| `Performance/Hearts` | 5 | stat chips |
| `Performance/Gems` | 245 | stat chips |
| `Progressbar Value` | 60 | progress bars |
| `Entry Flow/Logged in`, `Dark Mode` | false | flags (settings) |

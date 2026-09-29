# CLAUDE.md — Mieo UI kit rules

Mandatory rules for anyone (human or AI agent) working in this repo. The project lead's guidelines are the
foundation (§1). Every other section adds detail to them and never overrides them. If a rule and the code
disagree, fix the code. If a rule seems wrong, ask; don't silently deviate.

- **Product:** Mieo, a kid-friendly language-learning app (lessons, hearts, gems, XP, streaks, leagues; mascot
  Mieo the bear). Sold on **UI8** as a coded Flutter template, so buyers read this code: code quality *is* the
  product.
- **Design source of truth:** [Figma: Mieo — Language Learning](https://www.figma.com/design/mWILt2PBmTonssE3Z7uSgU/Mieo---Language-Learning?node-id=2158-14549&m=dev)
  (file key `mWILt2PBmTonssE3Z7uSgU`):

  | Page | Node | Use |
  |---|---|---|
  | `📱Light Theme` | `19:149` | Every screen, light |
  | `📱Dark Theme` | `2159:12104` | The same screens, dark: an identical node tree with the `Colors` variables in Dark mode |
  | `Style Guide 🎨` | `4:7527` | Colors `2158:14549` (every token, Light + Dark) and Typography `19:24` |
  | `Components 📂` | `19:150` | 21 component sets + icons |

- **Docs:** [docs/design_review.md](docs/design_review.md) (screen inventory with Light **and** Dark node IDs,
  component review, open questions) and [docs/design_tokens.md](docs/design_tokens.md) (every Figma variable →
  Dart token, with both values). Read both before building any screen.
- **Live token reference:** the app's Style Guide screen (`lib/features/style_guide/`, route `/style-guide`)
  renders every token through the real theme, with theme and language switches.
- **Targets:** Android and iOS phones **and tablets**, plus Web (the live demo, served inside Device Preview).
- **Reference project:** `/Users/bhavik/Downloads/habbitie-ui8-main`, for patterns only (shallow scans:
  directory layout, one representative file). It predates the lead's folder structure; where it differs, this
  file wins.

---

## 1. Project lead guidelines (non-negotiable)

1. **Consistent, feature-first folder structure**, identical across projects (§3).
2. **Git repository** in your professional account named `<project-name>-ui8`, so this repo is **`mieo-ui8`**.
3. **Code-first visuals.** Paths, the level map and everything geometric are drawn in code (`CustomPainter`,
   widgets, gradients), so they scale to **unlimited levels** and stay crisp. Image assets are only for real
   artwork (§10, §11).
4. **Localization:** every user-facing string is a translation key, however small (§9).
5. **GetX for navigation and route management** (and for translations), nothing else (§2).
6. **Responsive across Mobile and Tablet**, verified in **Device Preview** (§8).
7. **Reusable widgets + dummy data models** wherever there's no real data source (§5, §12).
8. **Minimal dependencies:** no package unless there's no reasonable way without it (§2).
9. **Optimise every image before adding it, and prefer SVG** (§10).
10. **Smooth page transitions and subtle micro-animations** where appropriate (§13).
11. **Dart & Flutter best practices**, clean and well-structured code (§4, §5).
12. **`dart format` + zero analysis issues before submission**, enforced by `tool/preflight.sh` (§17).
13. **Light and dark are built together:** every screen is built from its Figma Light node and checked against
    its Dark twin before it's done (§6).

---

## 2. Phase, stack & dependencies

**Current phase: UI only.** Build screens with dummy data. There is no backend, no real auth and no persistence
beyond app settings. Don't add API calls, databases or real authentication until explicitly asked. Where a real
call will eventually go, the feature repository returns dummy data (§12), so wiring a backend later is a
one-file swap.

**Screens are built UI-only first, without Cubit wiring.** Build the visual layer (layout, `commons/` widgets,
`Form` validation, GetX navigation). Plain `StatefulWidget` + `setState` is fine for local UI state (selected
tab/option, toggles, animation controllers). Per-feature Cubit wiring is a separate pass, done only when
explicitly requested. The app-wide `ThemeCubit` / `LanguageCubit` already exist and may be used by settings UI.

| Concern | Package | Rule |
|---|---|---|
| Routing + translations | `get` | **Only** `GetMaterialApp`, `GetPage`, `Get.toNamed/offNamed/offAllNamed/back`, `Translations`/`.tr`/`.trParams`. **Never** `GetxController`, `Obx`, `.obs`, `GetBuilder`, `Get.put/find`, Bindings, or GetX `context.*` helpers (`context.isTablet`, `context.textTheme`…). |
| State | `flutter_bloc` | Cubits only (not raw Bloc). App-wide: `ThemeCubit`, `LanguageCubit`. Feature cubits live in `features/<name>/blocs/`. |
| Settings persistence | `hive`, `hive_flutter` | Theme mode + language only (`HiveConstants`). |
| SVG | `flutter_svg` | Artwork and icons exported from Figma. |
| Character animation | `rive` | Mascot animations (`assets/animations/*.riv`) through `RiveWidgetController` + the file's state machine; decode with `Factory.flutter`. `RiveNative.init()` runs in `main()`; a screen that plays Rive keeps a static fallback for when `RiveNative.isInitialized` is false (tests, unsupported platform). |
| Device testing | `device_preview` 3 (WRTeam fork, `release/v3`) | `DevicePreview.enable()` at the top of `main()`, before anything touches the binding; on for web builds (release included), native with `--dart-define=DEVICE_PREVIEW=true`. It simulates below the widget layer, so `GetMaterialApp` takes no `DevicePreview.appBuilder` / `locale` / `useInheritedMediaQuery`. Its toolbar's light/dark *is* the app theme: `ThemeCubit` keeps the two in sync through `DevicePreview.maybeController` (never `DevicePreview.controller`, which throws when it's off). |
| RTL/i18n | `flutter_localizations` (SDK) | Required for RTL Directionality. |

Adding a package needs a one-line justification comment in `pubspec.yaml` **and** sign-off from the lead. Never
add a package for something a few lines of Flutter can do: no `flutter_screenutil`, no `google_fonts` (fonts are
bundled), no `intl` just to format a number, no GetX state extensions, no path/shape/animation packages for what
`CustomPainter` and implicit animations do.

---

## 3. Folder structure (lead's template)

```
lib/
├── core/                        # app-wide infrastructure — exactly one of each
│   ├── api/                     # api_client.dart, api_endpoints.dart (empty until a backend exists)
│   ├── configs/                 # app_config.dart — app name, defaults, Device Preview switch, text-scale cap
│   ├── constants/               # theme_constants (spacing/radius/border/shadow/layout), animation_constants,
│   │                            #   assets_constants, hive_constants, localization_constants
│   ├── localization/            # app_translations.dart (JSON loader), lang_keys.dart, language_cubit.dart
│   ├── routes/                  # routes.dart — Routes (names) + AppPages (GetPage list)
│   └── theme/                   # colors.dart (AppColors, ArtworkColors, AppColorTokens light/dark), fonts.dart
│                                #   (AppFonts), app_decorations.dart (AppBorders, AppShadows), app_theme.dart,
│                                #   theme_cubit.dart
├── commons/                     # shared by 2+ features
│   ├── widgets/                 # reusable widgets (§5): AppPressable, AppButton, AppIconButton/AppBackButton,
│   │                            #   AppTopBar, AppSocialButton, AppTextLink, AppTapTarget, AppIcon, AppTag,
│   │                            #   SelectableOptionTile, AppRadio, GlossyProgressBar, AppTooltipBubble,
│   │                            #   PageHeading, LabeledDivider, HighlightedText, SpeechBubble, ResponsiveContent,
│   │                            #   SkyBackdrop, SkyFormScaffold, ProfileFormFields; fields/ (AppFieldBox,
│   │                            #   AppFieldLayout, AppTextField, AppDropdownField); clouds/ (cloud shapes, groups,
│   │                            #   painter); meadow/ (MeadowBackdrop, MeadowStage, MeadowPainter); typewriter/
│   │                            #   (TypewriterText, TypewriterSchedule)
│   ├── models/                  # app-wide models (ProfileDetails); enums/ for app-wide enums (DeviceType, Gender)
│   ├── blocs/                   # global cubits (e.g. UserCubit) when needed
│   └── repositories/            # global repositories (e.g. user profile dummy data)
├── features/
│   ├── splash/                  # splash scene (route /): stage, Rive mascot
│   ├── onboarding/              # welcome (route /onboarding), "Hi! I'm Mieo" (/account-setup), the questions
│   │                            #   intro (/account-setup/questions) and the setup questions (native language,
│   │                            #   learning language, level, daily goal): scene stage, pedestal and mascot
│   │                            #   painters, MeadowTalkScaffold (the talk page), RiveMascot (a Rive mascot + still
│   │                            #   pose), SetupQuestionScaffold (the question page), OnboardingRepository
│   ├── auth/                    # login (route /login) and create profile (/create-profile), AuthRepository
│   ├── style_guide/             # renders every design token (route /style-guide)
│   └── <feature_name>/
│       ├── screens/             # one file per screen: <name>_screen.dart
│       ├── widgets/             # widgets (and painters) used only by this feature
│       ├── blocs/               # this feature's cubits (later pass)
│       ├── models/              # models.dart (barrel export) + enums/
│       └── repositories/        # <feature>_repository.dart — dummy data from Figma
├── utils/                       # global helpers — use sparingly
│   ├── extensions/              # context_extensions.dart (context.colors, context.responsive…)
│   └── input_validators.dart    # InputValidators.*
└── main.dart                    # bootstrap + MieoApp
assets/
├── animations/                  # Rive (.riv) character animations
├── fonts/                       # Nunito variable font + OFL.txt
├── icons/                       # single-glyph SVG icons
├── images/                      # artwork only: mascot, characters, scenes, badges (SVG, or WebP + 2.0x/3.0x)
└── languages/                   # en.json, ur.json
docs/                            # design_review.md, design_tokens.md
tool/                            # check_rules.sh, preflight.sh
test/                            # app_boot, localization, theme (tokens), theme_cubit (saved theme + Device Preview
                                 #   brightness sync), typography (Figma line heights), splash,
                                 #   onboarding, hello, questions_intro, setup_questions, login, create_profile,
                                 #   clouds, app_button, fields, commons_widgets, choice_widgets, highlighted_text,
                                 #   speech_bubble, typewriter,
                                 #   input_validators; helpers/ (pumpScreen, device matrix, talk-page bubble checks)
```

- **`core/` vs `commons/` vs `features/`:** a file goes in `core/` only if there is exactly one of it app-wide;
  in `commons/` if two or more features use it; otherwise it stays inside the feature that owns it. Features
  never import another feature's internals. Share through `commons/`.
- Each feature's `models/models.dart` re-exports that feature's model files. Screens import the barrel.
- Routing is centralised in `core/routes/routes.dart`, so the whole navigation graph is in one place.
- Splash is a feature (`features/splash/`). There is no `core/screens/`.

## 4. Naming & code style

- Files and folders: `snake_case` (`sign_in_screen.dart`). Classes, enums, typedefs: `PascalCase`. Members:
  `camelCase`. Screens end in `Screen`, cubits in `Cubit`, repositories in `Repository`, painters in `Painter`.
- Constants: `camelCase`, grouped in a `PascalCase` holder class when global (`ThemeConstants.spacing16`),
  `_`-prefixed when file-private.
- Imports: relative for project files, ordered `dart:` → `package:` → relative (enforced by the
  `directives_ordering` and `prefer_relative_imports` lints).
- `const` constructors everywhere possible, `final` locals, single quotes, 120-column format width
  (`dart format` reads `analysis_options.yaml`).
- **Keep `build()` short.** Pull each logical chunk (a form, a row, a card) into a **private widget class** in
  the same file (`_LoginForm`, `_StatsRow`), never a `Widget _buildX()` method. Private classes get their own
  element and can be `const`.
- Use `Row`/`Column`/`Flex` **`spacing:`** for uniform gaps between children instead of interleaved `SizedBox`es
  or index-based separator logic. An explicit `SizedBox` is only for a one-off gap or a fixed-size placeholder.
- Use `MediaQuery.sizeOf/paddingOf/viewInsetsOf(context)`, never `MediaQuery.of(context).size`.
- No `print`/`debugPrint`, no commented-out code, no `TODO`/`FIXME` in delivered code.

## 5. Reusable widgets

- **Before writing a widget, check `commons/widgets/`** and the feature's `widgets/`. Reuse or extend (add a
  variant or parameter) rather than fork. Already there:
  - **Tappables:** `AppPressable` (the shared 3D press: a box on a hard shadow that sinks into it; build every new
    3D tappable on it), `AppButton` (Figma Button: filled / outlined / shaded, disabled when `onPressed` is null),
    `AppIconButton` / `AppBackButton` (Figma Back Button; the back arrow mirrors in RTL), `AppSocialButton` (the
    sign-in choice tiles), `SelectableOptionTile` (Figma Input Option: icon, label and `AppRadio`, one picked in a
    list), `AppTextLink` (underlined text), `AppTapTarget` (a 48 tap target around a small child without changing
    the layout).
  - **Inputs** (`fields/`): `AppTextField` and `AppDropdownField` (Figma Input Field, FormFields with a validator),
    built from `AppFieldBox` (the box and its idle / focused / filled / error looks) and `AppFieldLayout` (inline
    label + validation message). `ProfileFormFields` + `ProfileFormController`: the name / email / gender / age form.
  - **Page pieces:** `SkyFormScaffold` (sky page with an optional `AppTopBar`, form centred on the screen, keyboard
    handling), `SkyBackdrop`, `AppTopBar` (TopAppBar General; a `center` widget can take the title's place),
    `GlossyProgressBar` (Figma Progress Bar), `AppTooltipBubble` (Figma Tool Tip), `PageHeading`, `LabeledDivider`,
    `AppIcon` (Figma icons, tinted by token), `AppTag`, `HighlightedText` (accent words marked `**…**` and underlined
    words `__…__` in the translation), `SpeechBubble` (Figma Talk Bubble: one line, or a set width the text wraps
    in; the tail under it or at its start, `SpeechBubbleFace`; `SpeechBubbleEntrance.typing` pops it up, then types
    its words), `TypewriterText` (`typewriter/`: a text that types itself out, at its final size from the start),
    `ResponsiveContent`, the sky clouds (`clouds/`: the nine Figma cloud shapes, the shared `CloudGroups`, placed,
    scaled and tilted with `CloudPlacement`), and the
    New Account Progress sky panel (`meadow/`: `MeadowBackdrop`, fitted by `MeadowStage`; screens add their bubble
    and Mieo in its frame).
- **Extract while building, not later.** If a sibling widget in the same screen or feature already has the same
  wrapper (tap target + hard shadow + border, icon + text row…), factor it into a shared, parameterised widget
  right away. The component-to-widget plan is in
  [docs/design_review.md §4](docs/design_review.md#4-component-review--flutter-widgets): one Flutter widget per
  Figma component, its Figma variants as enums.
- A widget used by one feature lives in `features/<name>/widgets/`. Promote it to `commons/` the moment a second
  feature needs it.
- Variants are enums (`AppButtonVariant.filled`, `AppButtonTone.success`), not boolean flags.
- **Every user-input field has a validator.** Wrap fields in a `Form` with a `GlobalKey<FormState>`, call
  `validate()` in the CTA and only proceed when it returns true. Use `InputValidators.*`
  (`utils/input_validators.dart`), adding a new static method there if needed. Never write inline validation.
  Error copy comes from `LangKeys.validation*`.

---

## 6. Light + dark: every screen is built from both Figma twins

Figma has every screen twice: `📱Light Theme` and `📱Dark Theme`, at the same canvas positions. The dark page
is the same node tree with the `Colors` variable collection switched to **Dark**, so every colour bound to a
variable changes and everything else (layout, sizes, copy, raw-colour artwork) stays identical. The code mirrors
this: all variable-bound colours come from `context.colors`, which resolves the Light or Dark value.

**Per screen, before writing code:**

1. Take both node IDs from [docs/design_review.md §3](docs/design_review.md#3-screen-inventory--light-and-dark-twins)
   (Light column + Dark column; overlays and component sets too).
2. `get_screenshot` **both** nodes and compare them side by side. Note every element that changes.
3. `get_design_context` on the **Light** node for structure and specs; also on the **Dark** node (or on the
   dark sub-node that differs) whenever the screenshots differ in a way the variables don't explain.
4. Map each colour by its **Figma variable name** to its token (`Surface/Dim/primary` →
   `context.colors.surface.dimPrimary`; table in [design_tokens.md](docs/design_tokens.md)). Never copy either
   mode's hex into a widget.
5. **Colours not bound to a variable** (raw hex) are identical in both themes. Artwork (scenes, mascot, avatars,
   badges, emoji icons) is meant to stay that way. If a raw colour is UI chrome (text, surface, stroke, shadow)
   and looks wrong in the dark screenshot, report it and, once confirmed, add a semantic token to
   `AppColorTokens` with explicit light and dark values. Never a local brightness ternary.
6. Build, then verify in **both** themes (Style Guide switch or Device Preview dark mode) against **both**
   screenshots: contrast, borders, shadows, the sky/clouds, translucent dim fills.
7. In the screen summary, list the light/dark differences found and any raw colours reported.

**Dark-mode behaviour already known from the Figma tokens:**

- Page `Surface/Body` #FAFAFA → #171A1C; cards/fields `Surface/Background Nuturel` #FFFFFF → #2E3438; text
  `Texts/Heading` #171A1C → #E3E6E8, `Texts/Body Text` #5D686F → #ADB5BA.
- Brand fills shift: `Surface/Primary` #59C8FF → #1AB3FF, `Shadow/Primary/Darker` #3E8CB2 → #006EA4.
- Dim tones become translucent over the dark surface (`Surface/Dim/primary` → #1AB3FF 16%).
- Some shadows and strokes invert: `Shadow/Secondary/Darker` #996E16 → #FFF1D3, `Shadow/Nutural/Full` #464E53 →
  #E3E6E8, `Stroke/Nuturel` #464E53 → #E3E6E8.
- Sky backdrop: light blue gradient → a faint white glow (`Surface/Sky/Top` white 8% → `Surface/Sky/Bottom` 0%)
  over the dark page; clouds turn grey (`Cloud Color/1–3`).
- Scene illustrations (home map, stories) and the mascot do not change.

## 7. Pixel-perfect UI (Figma → Flutter)

The goal is a build that overlays the Figma frame exactly on the reference device.

1. **Units are 1:1.** The Figma frame is **375 × 812 @1x**, so Figma px = Flutter logical px. Never scale sizes
   by screen width or height (no `screenWidth * 0.9`, no ScreenUtil-style scaling). Sizes stay fixed; *layout*
   adapts (§8).
2. **Read specs, don't eyeball.** Take every value from `get_design_context` (and `get_metadata` for exact
   geometry) on **the specific node** you're building, never from a screenshot or memory. Walk every sub-node:
   gaps, paddings, radii, border widths, colours, text style per text node, icon size.
3. **Every value maps to a token** ([design_tokens.md](docs/design_tokens.md)). Colours → `context.colors.*` by
   Figma variable name (primitives `AppColors.*` only where a node binds a `Shades/*` variable directly). Text →
   `textTheme.<role>` by Figma style name. Spacing, radius, border and shadow → `ThemeConstants` (names carry the
   pixel value: gap 16 → `spacing16`, radius 12 → `radius12`). A value with no token gets a named constant first:
   in `ThemeConstants` if the design repeats it, in the component's file if it's a one-off. Never inline the
   number.
4. **Typography:** use the theme role with no size, weight or letter-spacing override (enforced). The Figma
   styles use line height **Auto** = the font's natural height; the `AppFonts` styles are `inherit: false` with
   no `height`, which keeps it (a 16px line is 22px, like Figma). Only set `height:` for a node with an explicit
   pixel line height (`height = lineHeightPx / fontSize`). `.copyWith()` is only for colour or decoration.
5. **Hard shadows are solid offsets, not blur:** `AppShadows.hard(context.colors.shadow.x, offset: …)` (4 for
   buttons and cards, 2 for fields and tiles, negative for sheets). Never approximate with `elevation` or blur.
   Pressed 3D components sink into their shadow (move down by the offset while the shadow animates to 0).
6. **Borders:** Figma component outlines are **1.5px outside** the frame, so they don't change layout size:
   `AppBorders.outline(context.colors.stroke.x)`. If a node uses another stroke weight or alignment (1px inside
   on illustrations, 2px center), match it with a named constant.
7. **Device chrome isn't design.** Frames draw an iOS status bar and rounded corners, so don't reproduce them.
   Figma y-positions include the 44px status bar: content starts inside `SafeArea`. Backgrounds (sky, scenes)
   extend edge-to-edge behind the status bar. A screen on its own backdrop sets status-bar icon brightness with
   its own `AnnotatedRegion<SystemUiOverlayStyle>` (the app default follows the theme).
8. **Artwork is the real exported asset**, never approximated; geometry is drawn in code (§10). Before reusing
   an existing asset for a new node because it "looks similar", export that node and compare.
9. **Figma layer names lie.** Identify screens by node ID plus screenshot. Asset URLs and `imgX` variable names
   from `get_design_context` are scoped to that one response, so never reuse them across calls.
10. **Instances that disagree:** when two instances of one component differ by 1–2px (e.g. 345 vs 343 wide),
    build the component's master spec with the standard 16px gutter and report the discrepancy. Never hard-code
    the odd instance.
11. **Verify visually.** Run on a 375 × 812 device (Device Preview's DevTools panel → Custom… 375 × 812, since the
    catalog has no 375 × 812 phone; or an iPhone 13 mini / 11 Pro simulator) and compare
    side-by-side with `get_screenshot` of the Light **and** Dark node: alignment, spacing, wrapping, colours,
    shadows.

## 8. Responsive UI (Mobile & Tablet)

Fixed Figma *sizes*, fluid *layout*. `DeviceType` comes from the **shortest side**: `< 600` = mobile, `≥ 600` =
tablet (`ThemeConstants.tabletBreakpoint`). Use `context.deviceType`, `context.isTabletLayout` and
`context.responsive(mobile: …, tablet: …)` from `utils/extensions/context_extensions.dart`.

**Width**
- Never hard-code a content width taken from Figma (343, 345…). Full-width elements are the screen width minus
  `ThemeConstants.screenPaddingHorizontal` (16) on each side: use `double.infinity`, `Expanded` or `Flexible`.
  Side-by-side items (answer tiles, stat cards, gem packs) share space with `Expanded`, never fixed widths.
- Text must wrap or ellipsize gracefully (`maxLines` + `overflow`) at 320 wide.

**Height**
- Never position by Figma absolute `y`. Build vertical rhythm with `Column` + the spacing tokens, and use
  `Spacer`/`Expanded` for "pinned to bottom" areas. The one exception is a **scene** (below).
- Every screen must work from **667 tall (iPhone SE)** up. If the content can exceed the viewport, it scrolls
  (`SingleChildScrollView`, or `CustomScrollView` for long lists) while pinned elements (bottom CTA, bottom nav,
  lesson top bar) stay fixed. Design frames taller than 812 are scrolling screens.
- Forms keep the focused field and CTA visible above the keyboard.

**Tablet (≥ 600)**
- Backgrounds (sky, scene art) stay **full-bleed**. The content column is capped at
  `ThemeConstants.maxContentWidth` and centred: wrap screen content in `ResponsiveContent`
  (`commons/widgets/responsive_content.dart`).
- Layouts that should use the extra width (grids, avatar rows, achievement lists) change their column count with
  `context.responsive(...)` instead of being capped. The level map widens its path amplitude, not its sizes.
- Bottom sheets, dialogs and the floating bottom nav keep their mobile width, centred.
- Illustrations keep their aspect ratio (`BoxFit.contain`/`cover` as designed) and are size-capped. Never blow
  them up to 2×.
- Must work in portrait and landscape.

**Scenes (splash, onboarding, illustrated compositions)**
- A frame whose layers overlap as one picture (sky, clouds, title, mascot) is laid out in the Figma frame's own
  coordinates inside a **stage**: one box of the frame's size, placed and scaled uniformly by `FittedBox`
  (`SplashStage` centres the whole splash frame on the screen; `OnboardingStage` fits the Onboarding "Body" frame
  into the space under its intro text, bottom-anchored). On the 375 × 812 reference the mapping is the identity,
  so every layer lands on its Figma pixel.
- The stage keeps the design size on phones and only shrinks when its must-see content (the mascot, the pedestal
  he stands on) wouldn't fit; on tablets it may scale up (to fill the height, or to the content-column width).
  Never scale individual elements. Where even the smallest scene wouldn't fit (landscape phones, text scale 1.3),
  the scene's panel scrolls instead (IntrinsicHeight + a minimum slot height).
- Backgrounds stay full-bleed around the stage; UI chrome (footer, buttons) sits outside it at 1×, pinned to the
  screen edges. Text inside uses `PositionedDirectional` or directional padding (mirrors in RTL); artwork layers
  don't mirror.
- A layer painted with a blend mode (the Onboarding Mieo's soft-light shadows) blends with what is already in
  its picture layer, so keep `RepaintBoundary` out from between it and the scene it sits on.

**Accessibility**
- System text scale is clamped app-wide at `AppConfig.maxTextScaleFactor` (1.3). Layouts must not overflow at
  1.3. Tap targets are at least 48 × 48 (`ThemeConstants.minTapTarget`): pad small icons, or wrap a small tappable
  that must keep its Figma spacing in `AppTapTarget`.

**Device Preview test matrix** (run `flutter run -d chrome`, or native with `--dart-define=DEVICE_PREVIEW=true`).
The toolbar switches Android/iOS, the device and light/dark; in debug builds the **device_preview** tab in
Flutter DevTools adds custom sizes, landscape, text scale and the keyboard. Switch the language in the app (Style
Guide). Before calling a screen done, check:
- iPhone SE (375×667)
- 375×812 (Custom… in DevTools), the pixel-perfect reference
- iPhone 15 Pro Max (430×932)
- a 360×800 Android
- iPad mini and iPad Pro 12.9 (portrait + landscape)
- Each in **light + dark**, **English (LTR) + Urdu (RTL)**, at text scale **1.0 and 1.3**.
- No overflow stripes, no clipped text, no layout jumps.

---

## 9. Localization, RTL & learning content

**Adding a UI string**
1. Add a constant to `LangKeys` (`core/localization/lang_keys.dart`). The Dart name is camelCase and the value
   is the snake_case JSON key. Group keys under a `// ── Screen ──` header.
2. Add the key to **every** file in `assets/languages/` (`en.json`, `ur.json`). `test/localization_test.dart`
   fails CI on a missing, extra or blank key.
3. Render with `LangKeys.x.tr`, or `.trParams({'count': '3'})` for `@count` placeholders. Never `'raw'.tr`, never
   a bare literal, not even for single words, units or punctuation-only labels.

**Learning content is not UI copy.** Mieo teaches languages, so separate the two:
- **UI copy and app-authored content:** buttons, headings, prompts ("Choose the Right Options"), feedback
  ("Nice.!"), level, story and achievement names, language names. These use LangKeys, and models hold the *key*
  (`titleKey`), resolved with `.tr` in the widget.
- **Learning material:** the target-language sentences, answer options, word blocks and dialogue being taught,
  plus personal data (user names, emails), numbers and design identifiers (token names on the Style Guide
  screen). This is **data**: plain strings/numbers in the feature repository, never `.tr`, because it must stay
  in the language being learned whatever the UI language is.

**RTL: every widget, even ones that look symmetric**
- `EdgeInsetsDirectional` for all padding and margin (also `.all`/`.symmetric`), never `EdgeInsets`.
- `AlignmentDirectional`, `PositionedDirectional`, `BorderRadiusDirectional`, `TextAlign.start/end`,
  `start`/`end` everywhere, never `left`/`right`.
- Use `Directionality.of(context)` if you need the current direction. **Painters** receive the text direction
  and mirror their geometry for RTL (the level path winds the other way).
- Icon glyphs aren't mirrored manually: `Row` re-orders icon and label automatically. Exceptions: back arrows and
  chevrons that point "forward/back" are mirrored in RTL inside their shared widget.
- Never hard-code `TextDirection.ltr/rtl`. The one exception is learning material that must keep its own
  language's direction. Mark it `// check-rules: ignore — <reason>`.

## 10. Visuals: code first, then SVG, then raster

Decide per element, in this order:

1. **Code** (widgets, `CustomPainter`, gradients, `ClipPath`) for anything geometric: paths and the level map
   (§11), progress bars and rings, the sky gradient and clouds, the cloud-shaped top edge of feedback sheets,
   speech-bubble and tooltip tails, glossy button stripes, dashed/dotted connectors, radio/toggle/check marks,
   hexagon badge shapes, calendar grids, chips, dividers. Colours from `context.colors`; sizes from tokens;
   geometry mirrored for RTL. Painters are pure (inputs in, pixels out) with a precise `shouldRepaint`.
2. **SVG** for real artwork that code can't reasonably reproduce: the mascot, characters and avatars, 3D
   emoji-style icons (gem, heart, flame, bolt), flags, league/achievement badge art, brand logos, and the line
   icons. Export the node's own SVG from MCP, strip metadata (C2PA manifests, editor data), keep `viewBox`, and
   confirm it renders in `flutter_svg` (no unsupported filters or blurs). When the art depends on effects
   flutter_svg can't draw (blend-mode shadows, inner shadows) and they are hard (no blur), generate a
   `CustomPainter` from the exported geometry instead, one path per shape and per effect, with the raw fills in
   `ArtworkColors` (the Onboarding Mieo, `WelcomeMascotPainter`, generated at 0.001px precision).
3. **Rive** (`.riv`) for character animation that needs timelines, a state machine or events (the mascot
   flying, waving, blinking). Keep the artboard in the Figma frame's coordinates so it overlays the design 1:1,
   use flat fills and gradients (Rive can't import SVG shadow filters), name the state machine and events in
   `AssetsConstants`, and react to events (`splashDone`) rather than timers. Background scenery around the
   character is still drawn in code.
4. **Raster** only for painterly art SVG can't carry (blurred or photo-like scenes, story illustrations). Export
   at 3×, convert to **WebP** (quality ~80) and ship `name.webp` + `2.0x/` + `3.0x/` variants. Each file stays
   under 300 KB (enforced by `check_rules.sh`).

- **Prefer Material `Icons.*`** over a downloaded SVG when a generic glyph (chevron, check, close, info, clock…)
  is a faithful match after comparing with the export. Set its colour and size explicitly from tokens.
- Naming is flat and prefixed: `ic_<name>.svg` in `assets/icons/`, and `<category>_<name>.<ext>` in
  `assets/images/` (`mascot_waving.svg`, `scene_park.webp`, `flag_uk.svg`) and `assets/animations/`
  (`mascot_splash.riv`).
- Every asset has an `AssetsConstants` entry (grouped by feature, with a note on where it's used and whether it's
  tinted). No unused assets (enforced). No `'assets/…'` strings outside constants.
- Tinted icons use `colorFilter: ColorFilter.mode(color, BlendMode.srcIn)` with a token colour. Multi-colour art
  renders raw (so it looks the same in both themes, like Figma).

## 11. Level map & paths (CustomPainter, unlimited levels)

The Home map (`429:34434` / dark `2159:22457`) is a winding cobblestone path with level nodes and the mascot. It
must support **any number of levels**, so it is generated from data and drawn in code, never a tall background
image.

- **Data-driven:** the map renders `List<LevelModel>` from the home repository (any length; each level has a
  title key, icon, state: completed / current (with progress) / locked). Adding levels needs no layout change.
- **One layout function** (e.g. `LevelPathLayout`) maps a level index → node centre (a repeating S-curve whose
  spacing and amplitude come from the Figma frame) and builds the `Path` between nodes from cubic Béziers. The
  painter, the node widgets and hit-testing all use it, so taps land exactly on what's drawn. It takes the text
  direction and mirrors horizontally in RTL.
- **Lazy and fast:** the map scrolls (`CustomScrollView`); paint only the visible segments (tile the path per
  level or per screen-height chunk). Wrap painters in `RepaintBoundary`, cache `Paint`/`Path` objects, rebuild
  geometry only when levels, size or direction change, and make `shouldRepaint` compare exactly those inputs.
- **Look:** the path's edge, fill and stone texture are painter strokes/fills (round caps and joins; texture via
  `PathMetrics` along the path). Level nodes are widgets positioned by the layout (for semantics, taps and
  micro-animations); the current node's progress ring is a small painter; icons are SVG/Material.
- **Scenery** (bushes, rocks, grass, trees) is placed procedurally and deterministically from the level index
  (seeded `Random`), so the map is endless yet identical on every rebuild. Simple shapes in code; complex art as
  small reusable SVG pieces.
- **Behaviour:** on open, animate-scroll the current level into view; the mascot sits at the current node;
  unlocking/completing animates the node and the path segment. The same approach applies to every other path in
  the app (Explore Levels timeline connectors, streak calendar lines, story progress).

## 12. Dummy data

- Dummy data comes from **the actual Figma content** for that screen: real names ("Jenny Frost"), stats (245 gems,
  5 hearts, 25-day streak, 252 XP), level, story and league entries. The Figma `Logics` variables hold the main
  user and performance values ([design_tokens.md §5](docs/design_tokens.md#5-logics-collection--dummy-data)).
  No "Item 1", no lorem ipsum, unless the Figma itself shows lorem ipsum.
- It lives in the feature's `repositories/<feature>_repository.dart` as a repository class returning the
  feature's `models/` types (`HomeRepository().getLevels()`). Shared data (the current user's profile and stats)
  goes in `commons/repositories/`. Never put lists inline in `build()`.
- Models are immutable (`final` fields, `const` constructors). UI copy is held as LangKeys keys (§9), learning
  material and personal data as plain values.

## 13. Motion

- Page transitions are app-wide (`AnimationConstants.pageTransition`, a Cupertino slide that is RTL-aware).
  Override per `GetPage` only with reason (e.g. a fade from splash).
- Theme changes cross-fade: `AppColorTokens` lerps, so never cache a resolved colour outside `build()`.
- Micro-animations are subtle and purposeful: button press (sink into the hard shadow), option select, toggles,
  progress fill, feedback sheet slide-up, reward/streak count-up, list entrances, level-node unlock. Prefer
  implicit animations (`AnimatedContainer`, `AnimatedScale`, `AnimatedSwitcher`, `TweenAnimationBuilder`).
- Every `Duration` and `Curve` comes from `AnimationConstants`. Dispose every controller.

## 14. Theming & tokens

- `AppTheme` builds light and dark `ThemeData` from one recipe. Colour lives in `core/theme/colors.dart`:
  `AppColors` (Figma `Shades/*` primitives) and `AppColorTokens` (every semantic Figma variable with its Light and
  Dark value, a lerping `ThemeExtension`). Values are mirrored 1:1 from Figma and verified by
  `test/theme_test.dart`; change them only when the Figma variables change, and update
  [design_tokens.md](docs/design_tokens.md) with them.
- **No raw colours in widgets.** Never `Color(0x…)` or `Colors.*` (except `Colors.transparent`), and never branch
  on brightness (enforced). Instead:
  - **Everything bound to a Figma variable:** `context.colors.<group>.<token>` (`surface`, `text`, `icon`,
    `stroke`, `shadow`, `cloud`), which is correct in both themes and during the cross-fade.
  - **Text:** the role's default colour is `Texts/Heading`; other text colours via
    `.copyWith(color: context.colors.text.body)` etc.
  - **Primitives** `AppColors.*` only where the Figma node binds a `Shades/*` variable directly (theme-invariant
    by definition, e.g. `DROP_SHADOW Shades/primary/700`).
  - **Raw artwork fills** of illustrations drawn in code → `ArtworkColors.*` (`mieoFur`, `mieoPaw`), named after
    the artwork; raw black and white → `AppColors.neutral950` / `neutral50`. The same in both themes, like Figma.
  - A colour Figma doesn't have as a variable but that must differ per theme → a new token in `AppColorTokens`.
- The Material `ColorScheme` is derived from the same tokens (so stock widgets match); Mieo widgets read
  `context.colors` directly.
- Borders and shadows use `AppBorders` / `AppShadows` (`core/theme/app_decorations.dart`).
- **Don't pass `Scaffold.backgroundColor`** just to repeat the theme default (`Surface/Body`). Pass it only when a
  screen genuinely needs a different background, and then use a token.
- Component styles that repeat across widgets go into the shared widget (or an `AppTheme` component theme),
  never copied per screen.
- The Style Guide screen must keep rendering every token; update its repository when tokens change.

## 15. Comments (for a reader arriving cold)

- Every non-trivial screen or widget file starts with a banner between `// ───…` rules describing its structure
  top to bottom and the local state it owns.
- `// ── Section ──` headers inside `build()` group the stacked pieces.
- Explain complex UI logic on the spot (animations, painter geometry, PageView/indicator sync, multi-state
  tiles) and non-obvious values.
- Describe **what the code does and how the pieces fit**, not why alternatives were rejected.
- Never reference project docs, phases or tasks in code comments ("see CLAUDE.md", "UI-only for now", "no Cubit
  yet"). Describe what *is*.

---

## 16. Figma MCP workflow (per screen)

Connection: open the file in the Figma desktop app with the **Dev Mode MCP server** enabled
(`http://127.0.0.1:3845/mcp`, registered in `.mcp.json` as `figma-desktop`). The claude.ai Figma connector works
too. Load the **`figma-design-to-code`** skill before any `get_design_context` call.

**Read-only.** Never modify the Figma file (no `use_figma` writes). `use_figma` may be used for read-only
inspection when the other tools can't answer: exact variable values, style specs, `exportAsync` of an SVG when
asset URLs can't be downloaded.

1. Pick the screen's **Light and Dark** node IDs from
   [docs/design_review.md §3](docs/design_review.md#3-screen-inventory--light-and-dark-twins). `get_screenshot`
   both to confirm they're the right screen and to see what changes (§6).
2. `get_metadata` gives structure and exact geometry. `get_design_context` on the Light frame (or on sub-nodes
   for big frames) gives specs; `get_variable_defs` gives the tokens used. Repeat on the Dark node where the
   screenshots differ beyond the variables.
3. Map everything to existing tokens and widgets (docs/design_tokens.md, docs/design_review.md §4). Add missing
   tokens or shared widgets first (§5, §7.3).
4. Decide code vs asset per element (§10). Download real artwork from the response's asset URLs (they're
   temporary), optimise it, add it to `assets/` and `AssetsConstants`.
5. Build: strings to LangKeys + all JSON files; dummy data to the repository; route in `routes.dart` (replacing
   any `PlaceholderScreen`); `ResponsiveContent` for the content column.
6. Run `bash tool/preflight.sh --fix`, then the Device Preview matrix (§8) and a visual compare with **both**
   Figma screenshots (§7.11).
7. Summarise: files added, any deviation from Figma and why, light/dark differences and raw colours found (§6),
   design inconsistencies, open questions. Don't start the next screen until the current one passes.

## 17. Definition of done

A screen or change is done only when **all** of these hold:

- [ ] `bash tool/preflight.sh` passes: `dart format` clean → `flutter analyze` **0 issues** → `flutter test`
      green → `tool/check_rules.sh` **0 violations**.
- [ ] Matches the Figma **Light** node on the 375 × 812 reference (§7), with every value from tokens.
- [ ] Matches the Figma **Dark** node the same way; nothing hard-codes either mode (§6).
- [ ] Responsive matrix passes: mobile + tablet, portrait + landscape, 667 tall, text scale 1.3 (§8).
- [ ] LTR + RTL are both correct, painters included, with every string translated (§9).
- [ ] Geometry is drawn in code, assets are real artwork only, optimised and registered (§10, §11).
- [ ] Shared widgets are reused or extracted, `build()` methods are short, and there are no `Widget _buildX()`
      methods (§4, §5).
- [ ] Dummy data comes from Figma via a repository (§12).
- [ ] Banner and section comments are present (§15).

`tool/check_rules.sh` enforces the mechanical rules: raw colours, font sizes/weights/letter spacing, brightness
branching, LTR-only APIs, raw strings, durations, asset paths, locales, routes, magic numbers, GetX state, GetX
context helpers, widget methods, `MediaQuery.of`, prints, TODOs, and unused or oversized assets. A genuine
exception carries `// check-rules: ignore — <reason>` on that line.

## 18. Adding a feature or screen

1. Create `lib/features/<name>/{screens,widgets,models,repositories}` (and `blocs/` when state is wired), plus
   `models/models.dart`.
2. Add route constants and `GetPage` entries in `core/routes/routes.dart`, replacing any `PlaceholderScreen`.
3. Add strings to `LangKeys` and every language JSON; add assets to `AssetsConstants`.
4. Follow §16, then §17.

## 19. Git & delivery

- Repository: **`mieo-ui8`** in your professional account. The default branch is `main`, and features go on
  branches (`feature/<name>`).
- Commit messages are imperative and scoped (`home: add level map screen`). Commit only work that passes
  preflight. Never commit `build/`, `.dart_tool/` or IDE files (see `.gitignore`).
- Before a UI8 submission, check:
  - preflight passes
  - no TODOs, prints or dead code
  - README is up to date
  - all assets are licensed for redistribution (fonts ship with their license)
  - no secrets or API keys
  - the app runs on Android, iOS and Web

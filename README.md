# Mieo — Language Learning App UI Kit (Flutter)

A playful, kid-friendly language-learning app UI kit for **Android, iOS (phone and tablet) and Web**.
It covers lessons, streaks, leagues, rewards, stories and a shop, featuring Mieo the bear.

- Pixel-perfect to the Figma design and responsive from small phones to large tablets
- Animated splash: Mieo flies in on his plane (Rive) over a sky and clouds drawn in code
- Onboarding welcome: Mieo on language pedestals among the clouds, the whole scene drawn in code, with 3D buttons
  that sink into their shadow when pressed
- New-account questions (native language, learning language, level, daily goal) on one shared question page: Mieo
  taking notes on his cloud, a progress bar that grows step by step, selectable tiles, and a snapping minute picker
- Login and Create Profile forms: validated text fields (password eye, inline labels, error messages), a gender
  dropdown, Google / Apple sign-in buttons, keyboard-aware scrolling, built from reusable form widgets
- Light and dark themes mirrored from the Figma variables, with an animated theme switch
- Built-in Style Guide screen that renders every colour, text style, spacing, radius and shadow token
- English (LTR) and Urdu (RTL) out of the box. Adding a language takes one JSON file.
- Clean, feature-first architecture with minimal dependencies

## Tech stack

| | |
|---|---|
| Flutter / Dart | Flutter 3.47+ (stable), Dart `^3.13.3` |
| Navigation & translations | [`get`](https://pub.dev/packages/get), used **only** for routing (`GetPage`) and translations (`.tr`) |
| State management | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (Cubits) |
| Settings persistence | [`hive`](https://pub.dev/packages/hive) (theme mode, language) |
| Vector assets | [`flutter_svg`](https://pub.dev/packages/flutter_svg) |
| Character animation | [`rive`](https://pub.dev/packages/rive) (the mascot on the splash) |
| Device testing | [`device_preview`](https://github.com/wrteam-aayush/flutter_device_preview) 3 (on for web builds) |
| Typeface | Nunito (bundled variable font, SIL OFL) |

## Getting started

```bash
flutter pub get
flutter run                      # connected device / simulator
flutter run -d chrome            # web, inside Device Preview
flutter run --dart-define=DEVICE_PREVIEW=true   # Device Preview on a native build
```

Inside Device Preview the app runs in a simulated phone or tablet, under a toolbar that switches between Android
and iOS, picks the device, and toggles light/dark. That toggle is the app's own theme setting, so it stays in step
with the in-app theme switch and is remembered. In debug builds, the **device_preview** tab in Flutter DevTools
adds custom screen sizes, landscape, text scale and the software keyboard.

iOS needs Xcode with CocoaPods (`cd ios && pod install`), and Android needs the Android SDK with NDK
27.2.12479018 or newer (Rive's native runtime). On web, Rive loads its WebAssembly runtime from unpkg.com the
first time the app starts.

## Quality checks

```bash
bash tool/preflight.sh           # format check → analyze → tests → project rule checks
bash tool/preflight.sh --fix     # apply dart format first
```

CI (`.github/workflows/ci.yml`) runs the same preflight on every push and pull request. The tests cover the
app boot (splash → onboarding) and RTL switch, translation completeness, the Figma colour tokens in both
themes, the saved theme setting and its sync with Device Preview's light/dark toggle, the type scale (each text style's line height is checked against Figma with the real font), the splash
and onboarding scene geometry, the onboarding, login and create-profile layouts (Figma gaps on the reference
device, then the Device Preview matrix in light/dark and LTR/RTL, at text scale 1.3 and with the keyboard up),
their validation and navigation, the form validators, and the shared widgets (buttons, fields and dropdown, top
bar, tap targets, highlighted text, clouds, the talk bubble and its typing entrance, the typewriter's timing).
Widget tests run without the Rive runtime, so the splash shows its static scene there.

## Style guide

The **Style Guide** screen (route `/style-guide`; on web, open `#/style-guide`) shows every design token from
the Figma style guide, rendered through the live theme. Use its buttons to switch light/dark and English/Urdu.
The full token tables (Figma variable → Dart, light and dark values) are in
[`docs/design_tokens.md`](docs/design_tokens.md).

## Project structure

```
lib/
  core/          app-wide infrastructure: theme, routes, localization, constants, configs
  commons/       widgets, models and repositories shared by 2+ features
  features/      one folder per feature: screens/, widgets/, blocs/, models/, repositories/
  utils/         extensions and input validators
  main.dart      bootstrap
assets/          animations/ (Rive), fonts/, icons/, images/, languages/
docs/            design_review.md (screens, components), design_tokens.md (all tokens)
```

## Customisation

| To change… | Edit |
|---|---|
| App name | `AppConfig.appName` (`lib/core/configs/app_config.dart`), the `app_name` key in `assets/languages/*.json`, `android:label` in `AndroidManifest.xml`, `CFBundleDisplayName` in `ios/Runner/Info.plist`, and `web/index.html` / `web/manifest.json` |
| Package / bundle ID | `applicationId` in `android/app/build.gradle.kts`, `PRODUCT_BUNDLE_IDENTIFIER` in Xcode |
| Colours | `lib/core/theme/colors.dart`: `AppColors` is the primitive palette; `AppColorTokens.light` / `.dark` hold every semantic colour (surface, text, icon, stroke, shadow, cloud) for each theme; `ArtworkColors` holds the mascot's fur and paw colours |
| Buttons | `lib/commons/widgets/app_button.dart` (`AppButtonVariant.filled` / `outlined` / `shaded`; a null `onPressed` shows it disabled); the shared 3D press in `app_pressable.dart` |
| Form fields | `lib/commons/widgets/fields/` (`AppTextField`, `AppDropdownField`; the box looks in `app_field_box.dart`); validation messages in `lib/utils/input_validators.dart` |
| Setup questions (the languages, levels and daily goals offered) | `lib/features/onboarding/repositories/onboarding_repository.dart`; the shared page in `lib/features/onboarding/widgets/setup_question_scaffold.dart` |
| Form screens' page (sky, clouds, centring) | `lib/commons/widgets/sky_form_scaffold.dart`, `sky_backdrop.dart`, `clouds/cloud_groups.dart` |
| Typography | `lib/core/theme/fonts.dart` (type scale); font files and registration go in `assets/fonts/` + `pubspec.yaml` |
| Spacing, radii, borders, shadows, breakpoints | `lib/core/constants/theme_constants.dart`; border and hard-shadow recipes in `lib/core/theme/app_decorations.dart` |
| Animations | `lib/core/constants/animation_constants.dart` (page transition, durations, curves, splash timing) |
| Splash mascot | replace `assets/animations/mascot_splash.riv` (artboard "Splash", state machine "SplashSM", event "splashDone") |
| Texts / add a language | `assets/languages/<code>.json` + `LocalizationConstants.supportedLocales` |
| Default theme / text-scale cap | `lib/core/configs/app_config.dart` |
| Device Preview (when it's on, the device it opens on) | `enableDevicePreview` / `devicePreviewInitialDevice` in `lib/core/configs/app_config.dart`; the toolbar is set up in `main()` |
| Screen data | each feature's `repositories/` (dummy data you can swap for your API) |

## Credits

Design: WRTeam Design. Typeface: [Nunito](https://github.com/googlefonts/nunito) (SIL Open Font
License 1.1, see `assets/fonts/OFL.txt`).
# mieo

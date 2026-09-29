import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rive/rive.dart' show RiveNative;

import 'core/configs/app_config.dart';
import 'core/constants/animation_constants.dart';
import 'core/constants/hive_constants.dart';
import 'core/constants/localization_constants.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/language_cubit.dart';
import 'core/routes/routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BOOTSTRAP
//
// main() finishes all setup before the first frame, so that frame already
// renders with the saved theme, saved language and loaded strings:
//   1. The binding. DevicePreview.enable() creates it: with
//      AppConfig.enableDevicePreview it simulates a device (screen, safe
//      areas, brightness…) beneath the widget layer and draws the toolbar
//      above it; without, it behaves exactly like WidgetsFlutterBinding.
//      Either way it has to exist before anything below touches the binding.
//   2. Hive + the settings box (read synchronously by ThemeCubit /
//      LanguageCubit when they're created).
//   3. Translation JSON for every supported locale.
//   4. The Rive runtime (native library; WebAssembly on web) that plays the
//      mascot animations. If it can't start, the app still runs: animated
//      screens check RiveNative.isInitialized and show their static layout.
//
// Widget tree, top to bottom (Device Preview wraps it from the binding, so it
// isn't part of the tree):
//   MieoApp              — provides the app-wide cubits.
//   _MieoMaterialApp     — BlocBuilder<ThemeCubit> → GetMaterialApp, rebuilt
//                          with the new themeMode on every theme change.
// ─────────────────────────────────────────────────────────────────────────────
Future<void> main() async {
  DevicePreview.enable(
    enabled: AppConfig.enableDevicePreview,
    toolbar: const DevicePreviewToolbar(
      appName: AppConfig.appName,
      initialDevice: AppConfig.devicePreviewInitialDevice,
    ),
  );
  await Hive.initFlutter();
  final settingsBox = await Hive.openBox<dynamic>(HiveConstants.settingsBox);
  await AppTranslations.load();
  await _startRive();

  runApp(MieoApp(settingsBox: settingsBox, devicePreview: DevicePreview.maybeController));
}

Future<void> _startRive() async {
  try {
    await RiveNative.init();
  } on Object {
    // Leaves RiveNative.isInitialized false; the splash falls back to its
    // static scene.
  }
}

class MieoApp extends StatelessWidget {
  const MieoApp({super.key, required this.settingsBox, this.devicePreview});

  final Box<dynamic> settingsBox;

  /// Device Preview's controller when the app runs inside it; ThemeCubit keeps
  /// the simulated device's brightness in step with the theme through it.
  final DevicePreviewController? devicePreview;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(settingsBox, devicePreview: devicePreview)),
        BlocProvider(create: (_) => LanguageCubit(settingsBox)),
      ],
      child: const _MieoMaterialApp(),
    );
  }
}

// GetMaterialApp (not MaterialApp) wires up GetX routing (Get.toNamed…) and
// the `.tr` translation lookup. Locale changes don't go through this
// rebuild — LanguageCubit calls Get.updateLocale(), which GetMaterialApp
// handles itself; `locale:` here only seeds the saved language on launch.
class _MieoMaterialApp extends StatelessWidget {
  const _MieoMaterialApp();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) => GetMaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,

        // ── Theme ──
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,

        // ── Text scaling, system bars ──
        // The text-scale clamp caps the system setting, and a simulated
        // device's too: Device Preview feeds its values in through the same
        // MediaQuery. The AnnotatedRegion gives the status and navigation bars
        // icons that contrast with the active theme (Device Preview tints its
        // simulated status bar from it too); a screen drawn on its own
        // backdrop (sky, scene) overrides it with its own AnnotatedRegion.
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.systemOverlayStyle(Theme.of(context).brightness),
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: AppConfig.maxTextScaleFactor,
            child: child ?? const SizedBox.shrink(),
          ),
        ),

        // ── Localization ──
        // The delegates are what make Flutter treat RTL locales as RTL —
        // without them Directionality stays LTR for every locale.
        translations: AppTranslations(),
        locale: context.read<LanguageCubit>().state,
        fallbackLocale: LocalizationConstants.fallbackLocale,
        supportedLocales: LocalizationConstants.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,

        // ── Routing ──
        initialRoute: Routes.initial,
        getPages: AppPages.pages,
        defaultTransition: AnimationConstants.pageTransition,
        transitionDuration: AnimationConstants.pageTransitionDuration,
      ),
    );
  }
}

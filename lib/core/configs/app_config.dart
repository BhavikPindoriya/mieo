import 'package:device_preview/presets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP CONFIG
//
// App-level switches and defaults read once at bootstrap (main.dart). Values
// that describe *how the app is configured* live here; design values
// (spacing, durations, asset paths, locales…) live in core/constants/.
// ─────────────────────────────────────────────────────────────────────────────
class AppConfig {
  AppConfig._();

  /// Brand name — used as the OS-level app title (task switcher / browser
  /// tab). On-screen copy goes through LangKeys like every other string.
  static const String appName = 'Mieo';

  /// Theme used on first launch, before the user has picked one.
  static const ThemeMode defaultThemeMode = ThemeMode.light;

  /// Runs the app inside Device Preview: a simulated phone or tablet under a
  /// toolbar (app name, Android/iOS switch, device menu, light/dark). On for
  /// web builds, which is how the live demo is served, release builds
  /// included; on native builds it is opt-in via
  /// `--dart-define=DEVICE_PREVIEW=true`. Off, the app runs full screen with
  /// no simulation installed.
  static const bool enableDevicePreview = kIsWeb || bool.fromEnvironment('DEVICE_PREVIEW');

  /// The device Device Preview opens on: the standard-size iPhone closest to
  /// the 375 × 812 Figma frame (a 375 × 812 device isn't in its catalog).
  static const DevicePreset devicePreviewInitialDevice = DevicePresets.iPhone16;

  /// Upper bound applied to the system text-scale setting app-wide. Layouts
  /// are built to the Figma sizes and verified up to this factor; beyond it
  /// fixed-size components (buttons, chips, tiles) would clip their labels.
  static const double maxTextScaleFactor = 1.3;
}

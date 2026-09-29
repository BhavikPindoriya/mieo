import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../configs/app_config.dart';
import '../constants/hive_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THEME CUBIT
//
// App-wide light/dark/system selection. State is the ThemeMode itself.
//
//   • Created in main.dart with the already-open settings box, so the saved
//     mode is read synchronously and the first frame renders in it (no
//     light → dark flash).
//   • changeThemeMode() persists the choice, then emits; the BlocBuilder
//     around GetMaterialApp rebuilds it with the new themeMode.
//
// Inside Device Preview (the web demo) the theme and the simulated device's
// brightness are one setting, so the toolbar's light/dark button and the
// in-app switches always agree:
//
//   ThemeMode.light / .dark  ↔  simulated Brightness.light / .dark
//   ThemeMode.system         ↔  no simulated brightness (the real device's)
//
// The cubit pushes its mode into the simulation when it's created and on
// every change, and adopts — and saves — a brightness picked in the toolbar.
// ─────────────────────────────────────────────────────────────────────────────
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._settingsBox, {this._devicePreview}) : super(_savedThemeMode(_settingsBox)) {
    _devicePreview?.simulationListenable.addListener(_adoptSimulatedBrightness);
    unawaited(_simulateBrightness(state));
  }

  final Box<dynamic> _settingsBox;

  /// Device Preview's controller while the app runs inside it, else null.
  final DevicePreviewController? _devicePreview;

  static ThemeMode _savedThemeMode(Box<dynamic> box) {
    final savedName = box.get(HiveConstants.themeModeKey) as String?;
    return ThemeMode.values.firstWhere((mode) => mode.name == savedName, orElse: () => AppConfig.defaultThemeMode);
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    await _save(mode);
    await _simulateBrightness(mode);
  }

  Future<void> _save(ThemeMode mode) async {
    await _settingsBox.put(HiveConstants.themeModeKey, mode.name);
    emit(mode);
  }

  // ── Device Preview sync ──

  /// Sets the simulated device's brightness to match [mode]. Emitting before
  /// this call keeps the listener below from echoing the change back.
  Future<void> _simulateBrightness(ThemeMode mode) async {
    final devicePreview = _devicePreview;
    final brightness = _brightnessOf(mode);
    if (devicePreview == null || devicePreview.simulation?.platformBrightness == brightness) return;
    await devicePreview.update((simulation) => simulation.copyWith(platformBrightness: brightness));
  }

  /// Takes a brightness set outside the app (the toolbar's light/dark button,
  /// the DevTools panel) as the user's theme choice.
  void _adoptSimulatedBrightness() {
    final mode = _themeModeOf(_devicePreview?.simulation?.platformBrightness);
    if (mode != state) unawaited(_save(mode));
  }

  static Brightness? _brightnessOf(ThemeMode mode) => switch (mode) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system => null,
  };

  static ThemeMode _themeModeOf(Brightness? brightness) => switch (brightness) {
    Brightness.light => ThemeMode.light,
    Brightness.dark => ThemeMode.dark,
    null => ThemeMode.system,
  };

  @override
  Future<void> close() {
    _devicePreview?.simulationListenable.removeListener(_adoptSimulatedBrightness);
    return super.close();
  }
}

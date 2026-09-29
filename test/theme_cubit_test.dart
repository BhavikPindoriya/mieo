import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mieo_ui8/core/configs/app_config.dart';
import 'package:mieo_ui8/core/constants/hive_constants.dart';
import 'package:mieo_ui8/core/theme/theme_cubit.dart';

// ThemeCubit: the saved theme setting, and — inside Device Preview — its sync
// with the simulated device's brightness, driven from the app (changeThemeMode)
// and from the toolbar's light/dark button.
void main() {
  late Box<dynamic> settingsBox;

  setUpAll(() async {
    Hive.init(Directory.systemTemp.createTempSync('mieo_theme_test_').path);
    settingsBox = await Hive.openBox<dynamic>(HiveConstants.settingsBox);
  });

  setUp(() => settingsBox.clear());

  tearDownAll(Hive.close);

  String? savedMode() => settingsBox.get(HiveConstants.themeModeKey) as String?;

  group('theme setting', () {
    test('starts in the default mode until one is saved', () async {
      final cubit = ThemeCubit(settingsBox);
      addTearDown(cubit.close);

      expect(cubit.state, AppConfig.defaultThemeMode);
    });

    test('starts in the saved mode', () async {
      await settingsBox.put(HiveConstants.themeModeKey, ThemeMode.dark.name);
      final cubit = ThemeCubit(settingsBox);
      addTearDown(cubit.close);

      expect(cubit.state, ThemeMode.dark);
    });

    test('changeThemeMode saves the mode and emits it', () async {
      final cubit = ThemeCubit(settingsBox);
      addTearDown(cubit.close);

      await cubit.changeThemeMode(ThemeMode.dark);

      expect(cubit.state, ThemeMode.dark);
      expect(savedMode(), ThemeMode.dark.name);
    });
  });

  group('inside Device Preview', () {
    late _FakeDevicePreview devicePreview;

    setUp(() => devicePreview = _FakeDevicePreview());

    ThemeCubit createCubit() {
      final cubit = ThemeCubit(settingsBox, devicePreview: devicePreview);
      addTearDown(cubit.close);
      return cubit;
    }

    test('the simulated device starts in the saved theme', () async {
      await settingsBox.put(HiveConstants.themeModeKey, ThemeMode.dark.name);
      createCubit();

      expect(devicePreview.simulation?.platformBrightness, Brightness.dark);
      expect(devicePreview.simulation?.presetId, _FakeDevicePreview.presetId, reason: 'the device was replaced');
    });

    test('a system theme leaves the real device brightness in place', () async {
      await settingsBox.put(HiveConstants.themeModeKey, ThemeMode.system.name);
      createCubit();

      expect(devicePreview.simulation?.platformBrightness, isNull);
      expect(devicePreview.updates, 0);
    });

    test('changing the theme in the app sets the simulated brightness', () async {
      final cubit = createCubit();

      await cubit.changeThemeMode(ThemeMode.dark);
      expect(devicePreview.simulation?.platformBrightness, Brightness.dark);

      await cubit.changeThemeMode(ThemeMode.system);
      expect(devicePreview.simulation?.platformBrightness, isNull);
      expect(cubit.state, ThemeMode.system);
      expect(savedMode(), ThemeMode.system.name);
    });

    test('the simulation change made by the app is not echoed back', () async {
      final cubit = createCubit();
      final updatesAtStart = devicePreview.updates;
      final writes = <Object?>[];
      final subscription = settingsBox
          .watch(key: HiveConstants.themeModeKey)
          .listen((event) => writes.add(event.value));
      addTearDown(subscription.cancel);

      await cubit.changeThemeMode(ThemeMode.dark);
      await pumpEventQueue();

      expect(writes, [ThemeMode.dark.name], reason: 'the listener saved the change a second time');
      expect(devicePreview.updates - updatesAtStart, 1);
    });

    test('a brightness picked in the toolbar becomes the saved theme', () async {
      final cubit = createCubit();
      final next = cubit.stream.first;

      devicePreview.pickBrightness(Brightness.dark);

      expect(await next, ThemeMode.dark);
      expect(savedMode(), ThemeMode.dark.name);
    });

    test('clearing the simulated brightness follows the real device', () async {
      final cubit = createCubit();
      final next = cubit.stream.first;

      devicePreview.pickBrightness(null);

      expect(await next, ThemeMode.system);
    });

    test('stops following the toolbar once closed', () async {
      final cubit = ThemeCubit(settingsBox, devicePreview: devicePreview);
      await cubit.close();

      devicePreview.pickBrightness(Brightness.dark);
      await pumpEventQueue();

      expect(savedMode(), isNull);
    });
  });
}

/// Device Preview's controller as the app sees it: a simulated device whose
/// brightness the app (update) and the toolbar (pickBrightness) can change.
/// Like the real one, it commits an update before the returned future
/// completes and notifies only when the simulation actually changes.
class _FakeDevicePreview extends Fake implements DevicePreviewController {
  static const String presetId = 'iphone-16';

  final ValueNotifier<DeviceSimulation?> _simulation = ValueNotifier(const DeviceSimulation(presetId: presetId));

  /// How many times the app has changed the simulation.
  int updates = 0;

  @override
  DeviceSimulation? get simulation => _simulation.value;

  @override
  ValueListenable<DeviceSimulation?> get simulationListenable => _simulation;

  @override
  Future<void> update(DeviceSimulation Function(DeviceSimulation current) mutate) async {
    updates++;
    _simulation.value = mutate(simulation ?? const DeviceSimulation());
  }

  /// The toolbar's light/dark button (or, with null, the DevTools panel
  /// handing brightness back to the real device).
  void pickBrightness(Brightness? brightness) =>
      _simulation.value = (simulation ?? const DeviceSimulation()).copyWith(platformBrightness: brightness);
}

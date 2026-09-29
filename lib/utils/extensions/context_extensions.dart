import 'package:flutter/material.dart';

import '../../commons/models/enums/device_type.dart';
import '../../core/constants/theme_constants.dart';
import '../../core/theme/colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONTEXT EXTENSIONS
//
// Project helpers on BuildContext. Names are chosen so they don't collide
// with GetX's own BuildContext extensions (context.isTablet, .textTheme,
// .width…) — use these, not the GetX ones, which read the full
// MediaQuery.of() and rebuild on every metrics change.
// ─────────────────────────────────────────────────────────────────────────────

extension AppColorsContextExtension on BuildContext {
  /// The Figma colour tokens of the active theme, grouped like the Figma
  /// variables: `context.colors.surface.body`, `.text.heading`,
  /// `.stroke.extraDimNeutral`, `.shadow.primaryDarker`… While the theme
  /// animates between light and dark, these are the interpolated values.
  AppColorTokens get colors => Theme.of(this).extension<AppColorTokens>()!;
}

extension ResponsiveContextExtension on BuildContext {
  /// Resolved from the screen's *shortest* side, so a phone rotated to
  /// landscape stays [DeviceType.mobile]. MediaQuery.sizeOf only rebuilds
  /// the caller when the size changes, not on every MediaQuery update.
  DeviceType get deviceType =>
      MediaQuery.sizeOf(this).shortestSide >= ThemeConstants.tabletBreakpoint ? DeviceType.tablet : DeviceType.mobile;

  bool get isTabletLayout => deviceType == DeviceType.tablet;

  /// Picks a per-device value, e.g. a grid's column count:
  /// `context.responsive(mobile: 2, tablet: 4)`.
  T responsive<T>({required T mobile, required T tablet}) => switch (deviceType) {
    DeviceType.mobile => mobile,
    DeviceType.tablet => tablet,
  };
}

extension SystemInsetsContextExtension on BuildContext {
  /// Height of the system navigation bar along the bottom edge, or 0 when the
  /// bottom inset is only a home indicator or gesture pill
  /// (≤ ThemeConstants.homeIndicatorInset). Bottom-pinned content keeps its
  /// Figma position over a home indicator and is lifted by this much above a
  /// navigation bar, so it is never hidden behind one.
  double get navigationBarInset {
    final bottom = MediaQuery.viewPaddingOf(this).bottom;
    return bottom > ThemeConstants.homeIndicatorInset ? bottom : 0;
  }
}

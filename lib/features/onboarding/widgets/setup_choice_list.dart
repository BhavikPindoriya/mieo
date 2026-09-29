import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../commons/widgets/selectable_option_tile.dart';
import '../../../core/constants/theme_constants.dart';
import '../models/models.dart';
import 'signal_strength_icon.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SETUP CHOICE LIST
//
// Figma "Questions" of the setup question screens: the answers to one
// question as a column of SelectableOptionTiles, 18 apart, exactly one picked.
// Tapping a tile picks it. Two ready-made lists:
//
//   • LanguageChoiceList  — languages, each with its flag;
//   • ProficiencyChoiceList — levels, each with its signal icon.
//
// No local state: the screen holds the pick and passes it back in.
// ─────────────────────────────────────────────────────────────────────────────
class SetupChoiceList<T> extends StatelessWidget {
  const SetupChoiceList({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelOf,
    required this.iconOf,
  });

  final List<T> options;

  /// The picked option.
  final T selected;

  final ValueChanged<T> onSelected;

  /// The label shown for an option.
  final String Function(T option) labelOf;

  /// The 24 × 24 picture before an option's label, which may follow whether
  /// it is picked.
  final Widget Function(T option, bool selected) iconOf;

  /// Gap between two tiles (Figma "Questions" item spacing).
  static const double _gap = 18;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: _gap,
      children: [
        for (final option in options)
          SelectableOptionTile(
            icon: iconOf(option, option == selected),
            label: labelOf(option),
            selected: option == selected,
            onPressed: () => onSelected(option),
          ),
      ],
    );
  }
}

/// Languages to pick one of, each with its flag.
class LanguageChoiceList extends StatelessWidget {
  const LanguageChoiceList({super.key, required this.languages, required this.selected, required this.onSelected});

  final List<SetupLanguage> languages;
  final SetupLanguage selected;
  final ValueChanged<SetupLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    return SetupChoiceList<SetupLanguage>(
      options: languages,
      selected: selected,
      onSelected: onSelected,
      labelOf: (language) => language.nameKey.tr,
      iconOf: (language, _) => _Flag(language.flag),
    );
  }
}

/// Levels to pick one of, each with its signal icon.
class ProficiencyChoiceList extends StatelessWidget {
  const ProficiencyChoiceList({super.key, required this.levels, required this.selected, required this.onSelected});

  final List<ProficiencyLevel> levels;
  final ProficiencyLevel selected;
  final ValueChanged<ProficiencyLevel> onSelected;

  @override
  Widget build(BuildContext context) {
    return SetupChoiceList<ProficiencyLevel>(
      options: levels,
      selected: selected,
      onSelected: onSelected,
      labelOf: (level) => level.labelKey.tr,
      iconOf: (level, selected) => SignalStrengthIcon(strength: level.signal, selected: selected),
    );
  }
}

/// A language's flag: multi-colour artwork, shown as exported.
class _Flag extends StatelessWidget {
  const _Flag(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: ThemeConstants.iconSize24,
      height: ThemeConstants.iconSize24,
      excludeFromSemantics: true,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/constants/animation_constants.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../core/constants/theme_constants.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/fonts.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../app_icon.dart';
import 'app_field_box.dart';
import 'app_field_layout.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP DROPDOWN FIELD
//
// A pick-one field in the Figma "Input Field" look (AppFieldBox inside
// AppFieldLayout) with a chevron at the end, like Create Profile's Gender
// (366:15469). The box shows the chosen option's label in label/large -
// prominent and Texts/Heading, or the hint in Texts/Body Text.
//
// A tap opens a menu of the options right under the box and as wide as it: a
// card on Surface/Background Nuturel with a Stroke/Extra Dim/Nuturel outline
// and a hard shadow 4 below, each option 48 high, the chosen one on
// Surface/Dim/primary in Texts/primary. Picking one closes the menu and
// reports it through onChanged. While the menu is open the box shows the
// Focused look and the chevron turns over.
//
// It's a FormField: the enclosing Form checks [value] with [validator] and
// the message shows under the box. The parent owns [value] and updates it
// from onChanged.
//
// Local state: the menu controller and whether the menu is open.
// ─────────────────────────────────────────────────────────────────────────────

/// One choice of an [AppDropdownField]: its value and the label shown for it.
@immutable
class AppDropdownOption<T> {
  const AppDropdownOption(this.value, this.label);

  final T value;
  final String label;
}

class AppDropdownField<T> extends StatefulWidget {
  const AppDropdownField({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.label,
    this.validator,
  });

  final List<AppDropdownOption<T>> options;

  /// The chosen option's value; null before a choice.
  final T? value;

  final ValueChanged<T> onChanged;

  /// Shown in the box before a choice.
  final String? hintText;

  /// Inline label before the box (AppFieldLayout).
  final String? label;

  final FormFieldValidator<T>? validator;

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

/// A half turn: the chevron points up while the menu is open.
const double _chevronOpenTurns = 0.5;

/// Space between the box and the menu under it.
const double _menuGap = ThemeConstants.spacing8;

/// The menu panel draws itself (a Mieo card), so MenuAnchor's own Material
/// surface is made invisible and unpadded.
const MenuStyle _menuStyle = MenuStyle(
  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
  shadowColor: WidgetStatePropertyAll(Colors.transparent),
  surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
  elevation: WidgetStatePropertyAll(0),
  padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
  side: WidgetStatePropertyAll(BorderSide.none),
  shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
);

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  final MenuController _menu = MenuController();
  bool _open = false;

  AppDropdownOption<T>? get _selected {
    for (final option in widget.options) {
      if (option.value == widget.value) {
        return option;
      }
    }
    return null;
  }

  void _toggleMenu() {
    if (_menu.isOpen) {
      _menu.close();
      return;
    }
    // Closes the keyboard of any focused text field before the menu opens.
    FocusManager.instance.primaryFocus?.unfocus();
    _menu.open();
  }

  void _setOpen(bool open) {
    if (mounted && open != _open) {
      setState(() => _open = open);
    }
  }

  AppFieldStatus _statusOf(FormFieldState<T> field) {
    if (field.hasError) {
      return AppFieldStatus.error;
    }
    if (_open) {
      return AppFieldStatus.focused;
    }
    return widget.value == null ? AppFieldStatus.idle : AppFieldStatus.filled;
  }

  @override
  Widget build(BuildContext context) {
    final validator = widget.validator;
    return FormField<T>(
      initialValue: widget.value,
      validator: validator == null ? null : (_) => validator(widget.value),
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      builder: (field) => AppFieldLayout(
        label: widget.label,
        errorText: field.errorText,
        box: LayoutBuilder(
          builder: (context, constraints) => MenuAnchor(
            controller: _menu,
            style: _menuStyle,
            alignmentOffset: const Offset(0, _menuGap),
            clipBehavior: Clip.none,
            onOpen: () => _setOpen(true),
            onClose: () => _setOpen(false),
            menuChildren: [
              _OptionsMenu<T>(
                width: constraints.maxWidth,
                options: widget.options,
                selected: widget.value,
                onSelected: (value) {
                  widget.onChanged(value);
                  field.didChange(value);
                },
              ),
            ],
            builder: (context, menu, child) => _DropdownBox(
              status: _statusOf(field),
              label: _selected?.label,
              hintText: widget.hintText,
              open: _open,
              onTap: _toggleMenu,
            ),
          ),
        ),
      ),
    );
  }
}

/// The field's box: the chosen label (or the hint) and the chevron.
class _DropdownBox extends StatelessWidget {
  const _DropdownBox({
    required this.status,
    required this.label,
    required this.hintText,
    required this.open,
    required this.onTap,
  });

  final AppFieldStatus status;
  final String? label;
  final String? hintText;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = Theme.of(context).textTheme.labelLargeProminent;
    final label = this.label;
    return Semantics(
      container: true,
      button: true,
      expanded: open,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AppFieldBox(
            status: status,
            trailing: AnimatedRotation(
              turns: open ? _chevronOpenTurns : 0,
              duration: AnimationConstants.durationFast,
              curve: AnimationConstants.curveStandard,
              child: AppIcon(AssetsConstants.icChevronDown, color: colors.icon.neutral),
            ),
            child: Text(
              label ?? hintText ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style?.copyWith(color: label == null ? colors.text.body : colors.text.heading),
            ),
          ),
        ),
      ),
    );
  }
}

/// The open menu: a card with one row per option.
class _OptionsMenu<T> extends StatelessWidget {
  const _OptionsMenu({required this.width, required this.options, required this.selected, required this.onSelected});

  /// The box's width, which the menu matches.
  final double width;

  final List<AppDropdownOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelected;

  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(ThemeConstants.radius12));
  static const BorderRadius _optionRadius = BorderRadius.all(Radius.circular(ThemeConstants.radius8));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    // The menu scrolls inside a clipped viewport, so the card keeps its
    // outline inside its edge and leaves room below itself for the shadow.
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: ThemeConstants.hardShadowOffset),
      child: SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface.backgroundNeutral,
            border: Border.all(color: colors.stroke.extraDimNeutral, width: ThemeConstants.borderWidth),
            borderRadius: _borderRadius,
            boxShadow: AppShadows.hard(colors.shadow.neutralExtraLight, bordered: false),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(ThemeConstants.spacing4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final option in options)
                  MenuItemButton(
                    onPressed: () => onSelected(option.value),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        option.value == selected ? colors.surface.dimPrimary : Colors.transparent,
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        option.value == selected ? colors.text.primary : colors.text.heading,
                      ),
                      overlayColor: WidgetStatePropertyAll(colors.surface.extraDimPrimary),
                      textStyle: WidgetStatePropertyAll(textTheme.labelLargeProminent),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsetsDirectional.symmetric(horizontal: ThemeConstants.spacing12),
                      ),
                      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: _optionRadius)),
                    ),
                    child: Text(option.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

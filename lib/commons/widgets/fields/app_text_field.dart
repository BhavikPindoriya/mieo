import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/assets_constants.dart';
import '../../../core/localization/lang_keys.dart';
import '../../../core/theme/fonts.dart';
import '../../../utils/extensions/context_extensions.dart';
import '../app_icon.dart';
import '../app_tap_target.dart';
import 'app_field_box.dart';
import 'app_field_layout.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APP TEXT FIELD
//
// A one-line text input in the Figma "Input Field" look (AppFieldBox inside
// AppFieldLayout): the value in label/large - prominent and Texts/Heading,
// the hint in the same style in Texts/Body Text. The box shows Default while
// empty, Focused while being edited, Selected once it holds a value, and the
// error look when [validator] fails.
//
// It's a FormField: the enclosing Form validates [controller]'s text with
// [validator] (an InputValidators method) and the message shows under the
// box. After a failed check it re-checks on every edit, so the message goes
// away as soon as the value is fixed. A tap anywhere on the box or its label
// focuses the text.
//
// [obscurable] makes it a password field: the text is hidden, and the eye at
// the end (Icons/primary while the text shows) toggles it.
//
// Local state: focus (which drives the look) and whether an obscurable value
// is shown.
// ─────────────────────────────────────────────────────────────────────────────
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.label,
    this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autofillHints,
    this.inputFormatters,
    this.obscurable = false,
    this.onSubmitted,
  });

  /// Holds the value; owned by the screen, which reads it after validation.
  final TextEditingController controller;

  /// Optional, e.g. to move focus here from another field.
  final FocusNode? focusNode;

  /// Placeholder shown while the field is empty.
  final String? hintText;

  /// Inline label before the box (AppFieldLayout).
  final String? label;

  /// An `AssetsConstants.ic*` line icon at the start of the box.
  final String? icon;

  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  /// Hides the text, with an eye toggle at the end (passwords).
  final bool obscurable;

  /// Called when the keyboard's action key is pressed.
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _ownFocusNode;
  bool _revealed = false;
  late bool _empty = widget.controller.text.isEmpty;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_handleFocusChange);
      if (widget.focusNode != null) {
        _ownFocusNode?.dispose();
        _ownFocusNode = null;
      }
      _focusNode.addListener(_handleFocusChange);
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleTextChange);
      widget.controller.addListener(_handleTextChange);
      _empty = widget.controller.text.isEmpty;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() => setState(() {});

  // Rebuilds only when the field turns empty or non-empty (Default ↔ Selected).
  void _handleTextChange() {
    final empty = widget.controller.text.isEmpty;
    if (empty != _empty) {
      setState(() => _empty = empty);
    }
  }

  void _toggleRevealed() => setState(() => _revealed = !_revealed);

  AppFieldStatus _statusOf(FormFieldState<String> field) {
    if (field.hasError) {
      return AppFieldStatus.error;
    }
    if (_focusNode.hasFocus) {
      return AppFieldStatus.focused;
    }
    return _empty ? AppFieldStatus.idle : AppFieldStatus.filled;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = Theme.of(context).textTheme.labelLargeProminent;
    final validator = widget.validator;
    return FormField<String>(
      initialValue: widget.controller.text,
      validator: validator == null ? null : (_) => validator(widget.controller.text),
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      builder: (field) => GestureDetector(
        onTap: _focusNode.requestFocus,
        // Keeps the eye inside the text field's tap region, so tapping it
        // doesn't count as a tap outside the field.
        child: TextFieldTapRegion(
          child: AppFieldLayout(
            label: widget.label,
            errorText: field.errorText,
            box: AppFieldBox(
              status: _statusOf(field),
              leadingIcon: widget.icon,
              trailing: widget.obscurable ? _RevealToggle(revealed: _revealed, onToggle: _toggleRevealed) : null,
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                style: style?.copyWith(color: colors.text.heading),
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                  hintStyle: style?.copyWith(color: colors.text.body),
                ),
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                textCapitalization: widget.textCapitalization,
                textAlign: widget.textAlign,
                autofillHints: widget.autofillHints,
                inputFormatters: widget.inputFormatters,
                obscureText: widget.obscurable && !_revealed,
                autocorrect: !widget.obscurable,
                enableSuggestions: !widget.obscurable,
                onChanged: field.didChange,
                onSubmitted: widget.onSubmitted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The password field's eye: shows or hides the text. A 24 icon that takes
/// taps in a full tap target around it.
class _RevealToggle extends StatelessWidget {
  const _RevealToggle({required this.revealed, required this.onToggle});

  final bool revealed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final icon = context.colors.icon;
    return AppTapTarget(
      child: Semantics(
        container: true,
        button: true,
        toggled: revealed,
        label: LangKeys.fieldShowPassword.tr,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: AppIcon(AssetsConstants.icEye, color: revealed ? icon.primary : icon.neutral),
          ),
        ),
      ),
    );
  }
}

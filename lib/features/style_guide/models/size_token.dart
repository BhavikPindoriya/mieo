/// A named dimension from ThemeConstants: a spacing step or a corner radius.
class SizeToken {
  const SizeToken({required this.name, required this.value, this.figmaName});

  /// ThemeConstants member, e.g. `spacing16`.
  final String name;

  /// Figma variable, when the value has one, e.g. `Spacing/2`.
  final String? figmaName;

  final double value;

  /// [value] as Figma shows it.
  String get valueLabel => format(value);

  /// A token value without a trailing `.0`, as Figma shows it: `16`, `1.5`, `-0.25`.
  static String format(double value) => value == value.truncateToDouble() ? value.toStringAsFixed(0) : value.toString();
}

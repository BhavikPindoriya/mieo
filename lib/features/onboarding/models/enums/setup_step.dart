/// The setup questions in the order they are asked, each with how far the
/// top bar's progress bar is filled while it is on screen: the Figma fill
/// widths (87, 146, 221 and 243) of the 279 wide bar.
enum SetupStep {
  nativeLanguage(87),
  learningLanguage(146),
  proficiency(221),
  dailyGoal(243);

  const SetupStep(this._filledWidth);

  final double _filledWidth;

  /// Width of the Figma progress bar.
  static const double _barWidth = 279;

  /// How much of the bar is filled, from 0 to 1.
  double get progress => _filledWidth / _barWidth;

  /// The progress of the question before this one (0 before the first), where
  /// the bar grows from as this one opens.
  double get previousProgress => index == 0 ? 0 : SetupStep.values[index - 1].progress;
}

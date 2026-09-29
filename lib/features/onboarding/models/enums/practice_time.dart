import '../../../../core/localization/lang_keys.dart';

/// When in the day a learner means to practise: the tabs under the daily
/// goal.
enum PracticeTime {
  morning(LangKeys.practiceTimeMorning),
  afternoon(LangKeys.practiceTimeAfternoon),
  evening(LangKeys.practiceTimeEvening);

  const PracticeTime(this.labelKey);

  /// LangKeys key of the tab's label.
  final String labelKey;
}

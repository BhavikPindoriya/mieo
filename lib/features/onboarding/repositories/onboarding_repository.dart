import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ONBOARDING REPOSITORY
//
// The choices the new-account setup questions offer, in the order and with
// the answers Figma shows picked (New Account Progress: native language
// 62:8472, learning language 62:10515, level 62:9688, daily goal 62:9100).
// ─────────────────────────────────────────────────────────────────────────────
class OnboardingRepository {
  const OnboardingRepository();

  /// The languages offered as the learner's own.
  List<SetupLanguage> getNativeLanguages() => const [
    SetupLanguage.gujarati,
    SetupLanguage.marathi,
    SetupLanguage.hindi,
    SetupLanguage.englishUsa,
    SetupLanguage.french,
  ];

  SetupLanguage getDefaultNativeLanguage() => SetupLanguage.hindi;

  /// The languages offered to learn.
  List<SetupLanguage> getLearningLanguages() => const [
    SetupLanguage.gujarati,
    SetupLanguage.englishUsa,
    SetupLanguage.marathi,
    SetupLanguage.englishUk,
    SetupLanguage.tamil,
    SetupLanguage.telugu,
  ];

  SetupLanguage getDefaultLearningLanguage() => SetupLanguage.englishUk;

  /// The answers of the level question.
  List<ProficiencyLevel> getProficiencyLevels() => ProficiencyLevel.values;

  ProficiencyLevel getDefaultProficiencyLevel() => ProficiencyLevel.basicWords;

  /// The daily goals the minute picker offers, in minutes.
  List<int> getDailyGoalMinutes() => const [5, 10, 15, 30, 45];

  int getDefaultDailyGoalMinutes() => 15;

  /// When in the day the learner can practise.
  List<PracticeTime> getPracticeTimes() => PracticeTime.values;

  PracticeTime getDefaultPracticeTime() => PracticeTime.morning;
}

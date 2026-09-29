// ─────────────────────────────────────────────────────────────────────────────
// LANG KEYS
//
// Every user-facing UI string is keyed here and rendered as
// `LangKeys.xxx.tr` — never a string literal, never `'some_key'.tr`.
//
//   • Dart name: camelCase. Value: snake_case — the value IS the JSON key.
//   • Every value must exist in EVERY file under assets/languages/ (enforced
//     by test/localization_test.dart); a missing key renders as the raw key.
//   • Group keys under a `// ── Feature / Screen ──` header, in screen order.
//   • Placeholders use GetX's `@name` syntax in the JSON value and are filled
//     with `.trParams({'name': value})`.
//
// Lesson/learning content (the words and sentences being taught) is data,
// not UI copy — it lives in feature repositories, not here.
// ─────────────────────────────────────────────────────────────────────────────
class LangKeys {
  LangKeys._();

  // ── App ──
  static const String appName = 'app_name';

  // ── Splash ──
  /// Kicker line above the app name.
  static const String splashTagline = 'splash_tagline';

  /// Credit line pinned to the bottom of the splash.
  static const String splashCredit = 'splash_credit';

  // ── Onboarding ──
  /// Tag above the heading.
  static const String onboardingKidsSafe = 'onboarding_kids_safe';

  /// Heading. The highlighted word is wrapped in `**` (HighlightedText).
  static const String onboardingTitle = 'onboarding_title';

  /// Primary action: set up a new account.
  static const String onboardingFreshStart = 'onboarding_fresh_start';

  /// Secondary action: log in to an existing account.
  static const String onboardingResumeJourney = 'onboarding_resume_journey';

  // ── Hello (new account, "Hi! I’m Mieo") ──
  /// Mieo's greeting in the talk bubble. His name is wrapped in `**`
  /// (HighlightedText).
  static const String helloGreeting = 'hello_greeting';

  /// The action that answers him and starts the setup questions.
  static const String helloSayHi = 'hello_say_hi';

  // ── Questions intro (new account, "I just want to Ask you some Questions") ──
  /// Mieo asks whether he may ask some questions. "Questions" is wrapped in
  /// `**` (HighlightedText).
  static const String questionsIntroMessage = 'questions_intro_message';

  /// The action that agrees and opens the first question.
  static const String questionsIntroContinue = 'questions_intro_continue';

  // ── Setup questions (new account, New Account Progress) ──
  /// The action that answers a setup question and opens the next one.
  static const String setupNext = 'setup_next';

  /// Mieo asks for the learner's own language. "Native" is wrapped in
  /// `**__…__**`: accented and underlined (HighlightedText).
  static const String setupNativeLanguageMessage = 'setup_native_language_message';

  /// Mieo asks which language to learn. "Learn" is wrapped in `**`.
  static const String setupLearningLanguageMessage = 'setup_learning_language_message';

  /// Mieo asks how well the learner knows the language they picked.
  /// Placeholder: `@language` — that language's name, inside `**__…__**`.
  static const String setupProficiencyMessage = 'setup_proficiency_message';

  /// Mieo asks for a daily learning goal.
  static const String setupDailyGoalMessage = 'setup_daily_goal_message';

  // ── Languages (the names on the language pickers) ──
  static const String languageGujarati = 'language_gujarati';
  static const String languageMarathi = 'language_marathi';
  static const String languageHindi = 'language_hindi';
  static const String languageEnglishUsa = 'language_english_usa';
  static const String languageFrench = 'language_french';
  static const String languageEnglishUk = 'language_english_uk';
  static const String languageTamil = 'language_tamil';
  static const String languageTelugu = 'language_telugu';

  // ── Proficiency (how well the learner knows the language) ──
  static const String proficiencyNone = 'proficiency_none';
  static const String proficiencyBasicWords = 'proficiency_basic_words';
  static const String proficiencyChat = 'proficiency_chat';
  static const String proficiencyConversation = 'proficiency_conversation';

  // ── Daily goal ──
  /// The unit under each number of the minute picker.
  static const String dailyGoalMinutesUnit = 'daily_goal_minutes_unit';

  /// Screen-reader label of a minute picker entry. Placeholder: `@count` —
  /// the minutes.
  static const String dailyGoalMinutes = 'daily_goal_minutes';

  /// The cheer over the chosen goal.
  static const String dailyGoalCheer = 'daily_goal_cheer';

  // ── Practice time (when in the day the learner practises) ──
  static const String practiceTimeMorning = 'practice_time_morning';
  static const String practiceTimeAfternoon = 'practice_time_afternoon';
  static const String practiceTimeEvening = 'practice_time_evening';

  // ── Login ──
  static const String loginTitle = 'login_title';
  static const String loginDescription = 'login_description';

  /// Link under the password field.
  static const String loginForgotPassword = 'login_forgot_password';
  static const String loginSubmit = 'login_submit';

  /// Divider label above the social sign-in buttons.
  static const String loginContinueWith = 'login_continue_with';
  static const String loginGoogle = 'login_google';
  static const String loginApple = 'login_apple';

  // ── Create profile ──
  static const String createProfileTitle = 'create_profile_title';
  static const String createProfileDescription = 'create_profile_description';
  static const String createProfileSubmit = 'create_profile_submit';

  // ── Form fields (hints and inline labels the forms share) ──
  static const String fieldFullName = 'field_full_name';
  static const String fieldEmail = 'field_email';
  static const String fieldPassword = 'field_password';

  /// Screen-reader label of the password field's eye toggle.
  static const String fieldShowPassword = 'field_show_password';
  static const String fieldGender = 'field_gender';

  /// Gender dropdown before a choice is made.
  static const String fieldGenderHint = 'field_gender_hint';
  static const String fieldAge = 'field_age';

  // ── Gender ──
  static const String genderFemale = 'gender_female';
  static const String genderMale = 'gender_male';
  static const String genderOther = 'gender_other';

  // ── Common actions ──
  /// Screen-reader label of the back button.
  static const String actionBack = 'action_back';

  /// Screen-reader value of a progress bar. Placeholder: `@percent` — how
  /// much is done, 0 to 100.
  static const String progressPercent = 'progress_percent';

  // ── Validation (used by utils/input_validators.dart) ──
  static const String validationRequired = 'validation_required';
  static const String validationEmailInvalid = 'validation_email_invalid';

  /// Placeholder: `@count` — minimum number of characters.
  static const String validationPasswordMinLength = 'validation_password_min_length';
  static const String validationPasswordMismatch = 'validation_password_mismatch';

  /// Placeholders: `@min`, `@max` — the accepted age range.
  static const String validationAgeRange = 'validation_age_range';

  // ── Style guide ──
  static const String styleGuideTitle = 'style_guide_title';
  static const String styleGuideSubtitle = 'style_guide_subtitle';
  static const String styleGuideSwitchTheme = 'style_guide_switch_theme';
  static const String styleGuideSwitchLanguage = 'style_guide_switch_language';
  static const String styleGuideColors = 'style_guide_colors';
  static const String styleGuideTypography = 'style_guide_typography';
  static const String styleGuideSampleText = 'style_guide_sample_text';
  static const String styleGuideSpacing = 'style_guide_spacing';
  static const String styleGuideRadius = 'style_guide_radius';
  static const String styleGuideShadows = 'style_guide_shadows';

  /// Placeholder: `@value` — hard-shadow offset in logical pixels.
  static const String styleGuideShadowOffset = 'style_guide_shadow_offset';
}

import '../../../../core/localization/lang_keys.dart';

/// How well a learner already knows the language they picked, from nothing
/// to simple conversation: the answers of the level question.
enum ProficiencyLevel {
  none(LangKeys.proficiencyNone, 0),
  basicWords(LangKeys.proficiencyBasicWords, 1),
  chat(LangKeys.proficiencyChat, 2),
  conversation(LangKeys.proficiencyConversation, 3);

  const ProficiencyLevel(this.labelKey, this.signal);

  /// LangKeys key of the answer.
  final String labelKey;

  /// How many parts of the signal icon beside it are lit, 0 to 3.
  final int signal;
}

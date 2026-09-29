import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/localization/lang_keys.dart';
import '../../../core/routes/routes.dart';
import '../models/models.dart';
import '../repositories/onboarding_repository.dart';
import '../widgets/setup_choice_list.dart';
import '../widgets/setup_question_scaffold.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LEARNING LANGUAGE SCREEN
//
// Figma "Survey": Light 62:10515, Dark 2159:37925. The second setup question,
// on the shared question page (SetupQuestionScaffold, second step):
//
//   • Mieo asks "Okay.! Now, What would you like to Learn.?" ("Learn"
//     accented);
//   • the languages (LanguageChoiceList), English (UK) picked at first; the
//     list is longer than the space above Next, so it scrolls under it;
//   • Next opens the level question for the picked language.
//
// Local state: the picked language.
// ─────────────────────────────────────────────────────────────────────────────
class LearningLanguageScreen extends StatefulWidget {
  const LearningLanguageScreen({super.key});

  @override
  State<LearningLanguageScreen> createState() => _LearningLanguageScreenState();
}

class _LearningLanguageScreenState extends State<LearningLanguageScreen> {
  static const OnboardingRepository _repository = OnboardingRepository();

  final List<SetupLanguage> _languages = _repository.getLearningLanguages();
  SetupLanguage _selected = _repository.getDefaultLearningLanguage();

  @override
  Widget build(BuildContext context) {
    return SetupQuestionScaffold(
      step: SetupStep.learningLanguage,
      question: LangKeys.setupLearningLanguageMessage.tr,
      answers: LanguageChoiceList(
        languages: _languages,
        selected: _selected,
        onSelected: (language) => setState(() => _selected = language),
      ),
      onNext: () => unawaited(Get.toNamed<void>(Routes.setupProficiency, arguments: _selected)),
    );
  }
}

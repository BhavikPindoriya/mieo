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
// NATIVE LANGUAGE SCREEN
//
// Figma "Survey": Light 62:8472, Dark 2159:37809 (the same frame with the
// Colors variables in Dark mode). The first setup question, on the shared
// question page (SetupQuestionScaffold, first step):
//
//   • Mieo asks "So.! What is your Native Language" ("Native" accented and
//     underlined);
//   • the languages (LanguageChoiceList), Hindi picked at first;
//   • Next opens the learning-language question.
//
// Local state: the picked language.
// ─────────────────────────────────────────────────────────────────────────────
class NativeLanguageScreen extends StatefulWidget {
  const NativeLanguageScreen({super.key});

  @override
  State<NativeLanguageScreen> createState() => _NativeLanguageScreenState();
}

class _NativeLanguageScreenState extends State<NativeLanguageScreen> {
  static const OnboardingRepository _repository = OnboardingRepository();

  final List<SetupLanguage> _languages = _repository.getNativeLanguages();
  SetupLanguage _selected = _repository.getDefaultNativeLanguage();

  @override
  Widget build(BuildContext context) {
    return SetupQuestionScaffold(
      step: SetupStep.nativeLanguage,
      question: LangKeys.setupNativeLanguageMessage.tr,
      answers: LanguageChoiceList(
        languages: _languages,
        selected: _selected,
        onSelected: (language) => setState(() => _selected = language),
      ),
      onNext: () => unawaited(Get.toNamed<void>(Routes.setupLearningLanguage)),
    );
  }
}

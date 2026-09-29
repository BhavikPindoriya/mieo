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
// PROFICIENCY SCREEN
//
// Figma "Survey": Light 62:9688, Dark 2159:38042. The third setup question,
// on the shared question page (SetupQuestionScaffold, third step):
//
//   • Mieo asks how well the learner knows the language they chose to learn
//     ("How much you Know English (UK) Language", the name accented and
//     underlined). The language comes in as the route's arguments from the
//     learning-language question; opened any other way, it is the one that
//     question picks at first;
//   • the levels (ProficiencyChoiceList), "Know some basic words" picked at
//     first;
//   • Next opens the daily goal question.
//
// Local state: the picked level.
// ─────────────────────────────────────────────────────────────────────────────
class ProficiencyScreen extends StatefulWidget {
  const ProficiencyScreen({super.key});

  @override
  State<ProficiencyScreen> createState() => _ProficiencyScreenState();
}

class _ProficiencyScreenState extends State<ProficiencyScreen> {
  static const OnboardingRepository _repository = OnboardingRepository();

  final List<ProficiencyLevel> _levels = _repository.getProficiencyLevels();
  ProficiencyLevel _selected = _repository.getDefaultProficiencyLevel();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.settingsOf(context)?.arguments;
    final language = arguments is SetupLanguage ? arguments : _repository.getDefaultLearningLanguage();
    return SetupQuestionScaffold(
      step: SetupStep.proficiency,
      question: LangKeys.setupProficiencyMessage.trParams({'language': language.nameKey.tr}),
      answers: ProficiencyChoiceList(
        levels: _levels,
        selected: _selected,
        onSelected: (level) => setState(() => _selected = level),
      ),
      onNext: () => unawaited(Get.toNamed<void>(Routes.setupDailyGoal)),
    );
  }
}

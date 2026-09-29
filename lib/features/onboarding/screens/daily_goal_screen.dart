import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/localization/lang_keys.dart';
import '../../../core/routes/routes.dart';
import '../models/models.dart';
import '../repositories/onboarding_repository.dart';
import '../widgets/daily_goal_card.dart';
import '../widgets/setup_question_scaffold.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DAILY GOAL SCREEN
//
// Figma "Survey": Light 62:9100, Dark 2159:38157. The last setup question, on
// the shared question page (SetupQuestionScaffold, last step):
//
//   • Mieo asks "What’s your daily learning goal.?";
//   • the goal card (DailyGoalCard): minutes a day, 15 at first, and the time
//     of day, Morning at first;
//   • Next goes on to loading the learner's course, handing it the goal.
//
// Local state: the picked goal and time of day.
// ─────────────────────────────────────────────────────────────────────────────
class DailyGoalScreen extends StatefulWidget {
  const DailyGoalScreen({super.key});

  @override
  State<DailyGoalScreen> createState() => _DailyGoalScreenState();
}

class _DailyGoalScreenState extends State<DailyGoalScreen> {
  static const OnboardingRepository _repository = OnboardingRepository();

  final List<int> _minutes = _repository.getDailyGoalMinutes();
  final List<PracticeTime> _times = _repository.getPracticeTimes();
  final int _initialMinutes = _repository.getDefaultDailyGoalMinutes();
  late int _selectedMinutes = _initialMinutes;
  PracticeTime _selectedTime = _repository.getDefaultPracticeTime();

  @override
  Widget build(BuildContext context) {
    return SetupQuestionScaffold(
      step: SetupStep.dailyGoal,
      question: LangKeys.setupDailyGoalMessage.tr,
      answers: DailyGoalCard(
        minutes: _minutes,
        initialMinutes: _initialMinutes,
        onMinutesChanged: (minutes) => _selectedMinutes = minutes,
        times: _times,
        selectedTime: _selectedTime,
        onTimeChanged: (time) => setState(() => _selectedTime = time),
      ),
      onNext: () => unawaited(
        Get.toNamed<void>(
          Routes.setupLoading,
          arguments: DailyGoal(minutes: _selectedMinutes, time: _selectedTime),
        ),
      ),
    );
  }
}

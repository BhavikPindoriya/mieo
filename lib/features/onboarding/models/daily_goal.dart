import 'enums/practice_time.dart';

/// A learner's daily goal: how many minutes a day, and when in the day.
class DailyGoal {
  const DailyGoal({required this.minutes, required this.time});

  final int minutes;
  final PracticeTime time;
}

import 'package:get/get.dart';

import '../../commons/widgets/placeholder_screen.dart';
import '../../features/auth/screens/create_profile_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/onboarding/screens/daily_goal_screen.dart';
import '../../features/onboarding/screens/hello_screen.dart';
import '../../features/onboarding/screens/learning_language_screen.dart';
import '../../features/onboarding/screens/native_language_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/proficiency_screen.dart';
import '../../features/onboarding/screens/questions_intro_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/style_guide/screens/style_guide_screen.dart';
import '../constants/animation_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ROUTES
//
// The app's full navigation graph, in one place:
//
//   • Routes   — route name constants. Navigate with Get.toNamed /
//                Get.offNamed / Get.offAllNamed(Routes.xxx), never a string.
//   • AppPages — every GetPage GetMaterialApp can resolve. Pages inherit the
//                app-wide transition (AnimationConstants.pageTransition,
//                set in main.dart); pass `transition:` on a GetPage only
//                when that route needs a different one.
//
// A route whose screen isn't built yet points at PlaceholderScreen, so the
// graph always resolves.
// ─────────────────────────────────────────────────────────────────────────────
class Routes {
  Routes._();

  static const String splash = '/';

  /// First screen after the splash: the welcome with the two ways in.
  static const String onboarding = '/onboarding';

  /// New-account setup, from "Let’s Get a Fresh Start" on onboarding: Mieo
  /// says hello.
  static const String accountSetup = '/account-setup';

  /// Mieo asks whether he may ask some questions, from "Say “Hi” to Mieo".
  static const String setupQuestions = '/account-setup/questions';

  /// The first setup question (the learner's native language), from "Sure.!
  /// Continue".
  static const String setupNativeLanguage = '/account-setup/native-language';

  /// The second setup question (the language to learn), from Next on the
  /// native language.
  static const String setupLearningLanguage = '/account-setup/learning-language';

  /// The third setup question (how well the learner knows that language),
  /// from Next on the learning language, which passes the language as the
  /// route's arguments (a SetupLanguage).
  static const String setupProficiency = '/account-setup/proficiency';

  /// The last setup question (the daily goal), from Next on the level.
  static const String setupDailyGoal = '/account-setup/daily-goal';

  /// "Loading your course" after the setup questions, from Next on the daily
  /// goal, which passes the goal as the route's arguments (a DailyGoal).
  static const String setupLoading = '/account-setup/loading';

  /// Login for returning learners, from "Resume Journey" on onboarding.
  static const String login = '/login';

  /// Password recovery, from "Forgot Password .?" on login.
  static const String forgotPassword = '/forgot-password';

  /// Profile details after a Google or Apple sign-in on login.
  static const String createProfile = '/create-profile';

  /// The home map, once signed in.
  static const String home = '/home';

  /// Every Figma design token rendered through the live theme and language.
  static const String styleGuide = '/style-guide';

  /// First route GetMaterialApp opens.
  static const String initial = splash;
}

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
      transition: AnimationConstants.splashExitTransition,
      transitionDuration: AnimationConstants.splashExitDuration,
    ),
    GetPage(name: Routes.accountSetup, page: () => const HelloScreen()),
    GetPage(name: Routes.setupQuestions, page: () => const QuestionsIntroScreen()),
    GetPage(name: Routes.setupNativeLanguage, page: () => const NativeLanguageScreen()),
    GetPage(name: Routes.setupLearningLanguage, page: () => const LearningLanguageScreen()),
    GetPage(name: Routes.setupProficiency, page: () => const ProficiencyScreen()),
    GetPage(name: Routes.setupDailyGoal, page: () => const DailyGoalScreen()),
    GetPage(name: Routes.setupLoading, page: () => const PlaceholderScreen()),
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(name: Routes.forgotPassword, page: () => const PlaceholderScreen()),
    GetPage(name: Routes.createProfile, page: () => const CreateProfileScreen()),
    GetPage(name: Routes.home, page: () => const PlaceholderScreen()),
    GetPage(name: Routes.styleGuide, page: () => const StyleGuideScreen()),
  ];
}

import 'package:get/get.dart';
import 'package:chess_live/presentation/screens/splash/splash_screen.dart';
import 'package:chess_live/presentation/screens/auth/login_screen.dart';
import 'package:chess_live/presentation/screens/auth/register_screen.dart';
import 'package:chess_live/presentation/screens/home/home_screen.dart';
import 'package:chess_live/presentation/screens/matchmaking/matchmaking_screen.dart';
import 'package:chess_live/presentation/screens/game/game_screen.dart';
import 'package:chess_live/presentation/screens/leaderboard/leaderboard_screen.dart';
import 'package:chess_live/presentation/screens/profile/profile_screen.dart';
import 'package:chess_live/presentation/screens/settings/settings_screen.dart';

abstract class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String matchmaking = '/matchmaking';
  static const String game = '/game';
  static const String leaderboard = '/leaderboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

abstract class AppPages {
  static const String initial = Routes.splash;

  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.matchmaking,
      page: () => const MatchmakingScreen(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.game,
      page: () => const GameScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.leaderboard,
      page: () => const LeaderboardScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}

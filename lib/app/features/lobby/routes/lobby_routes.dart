import 'package:go_router/go_router.dart';
import 'package:shadow_game_v2/app/features/lobby/screens/game_over_screen.dart';
import 'package:shadow_game_v2/app/features/lobby/screens/start_game_screen.dart';
import 'package:shadow_game_v2/app/features/lobby/screens/tutorial_screen.dart';

class LobbyRoutes {
  static GoRoute startGame = GoRoute(
    path: '/start-game',
    builder: (context, state) => const StartGameScreen(),
  );

  static GoRoute gameOver = GoRoute(
    path: '/game-over',
    builder: (context, state) => const GameOverScreen(),
  );

  static GoRoute tutorial = GoRoute(
    path: '/tutorial',
    builder: (context, state) => const TutorialScreen(),
  );
}

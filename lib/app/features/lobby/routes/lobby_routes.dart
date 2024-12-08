import 'package:go_router/go_router.dart';
import 'package:shadow_game_v2/app/features/lobby/screens/lobby_screen.dart';

class LobbyRoutes {
  static GoRoute startGame = GoRoute(
    path: '/start-game',
    builder: (context, state) => const LobbyScreen(),
  );
}

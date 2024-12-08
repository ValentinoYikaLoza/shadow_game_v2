import 'package:go_router/go_router.dart';
import 'package:shadow_game_v2/app/config/router/app_router.dart';
import 'package:shadow_game_v2/app/features/level_one/routes/level_one_routes.dart';
import 'package:shadow_game_v2/app/features/lobby/routes/lobby_routes.dart';

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        return '/start-game';
      },
    ),
    LobbyRoutes.startGame,
    LobbyRoutes.gameOver,
    LevelOneRoutes.levelOne,
  ],
);

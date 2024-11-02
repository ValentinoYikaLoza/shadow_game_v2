import 'package:go_router/go_router.dart';
import 'package:shadow_game_v2/app/config/router/app_router.dart';
import 'package:shadow_game_v2/app/features/level_one/routes/level_one_routes.dart';

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        return '/level-one';
      },
    ),
    LevelOneRoutes.levelOne,
  ],
);

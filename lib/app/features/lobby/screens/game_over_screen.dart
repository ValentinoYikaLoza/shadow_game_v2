import 'package:flutter/material.dart';
import 'package:shadow_game_v2/app/config/router/app_router.dart';
import 'package:shadow_game_v2/app/features/lobby/routes/lobby_routes.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_button.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final themeColor = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      decoration: BoxDecoration(
        color: themeColor,
      ),
      child: Center(
          child: CustomButton(
        width: screen.width / 2,
        imagePath: 'assets/images/lobby/game_over.png',
        onPressed: () {
          AppRouter.go(LobbyRoutes.startGame.path);
        },
      )),
    );
  }
}

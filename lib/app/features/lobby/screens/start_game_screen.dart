import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/config/router/app_router.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/routes/level_one_routes.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_button.dart';

class StartGameScreen extends ConsumerStatefulWidget {
  const StartGameScreen({super.key});

  @override
  StartGameScreenState createState() => StartGameScreenState();
}

class StartGameScreenState extends ConsumerState<StartGameScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(playerProvider.notifier).resetData();
    });
    super.initState();
  }
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
        imagePath: 'assets/images/lobby/start_game.png',
        onPressed: () {
          AppRouter.go(LevelOneRoutes.levelOne.path);
        },
      )),
    );
  }
}

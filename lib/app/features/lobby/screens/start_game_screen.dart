import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/config/constants/app_colors.dart';
import 'package:shadow_game_v2/app/config/router/app_router.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/routes/level_one_routes.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_button.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_gif.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/loader.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/snackbar.dart';

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
    final screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.gray3,
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/icon.jpg',
          ),
          Positioned(
            top: screenSize.height * 0.15,
            left: screenSize.width / 2 - ((screenSize.width * 0.7) / 2),
            child: CustomGif(
              images: const ['assets/images/lobby/shadow_game.png'],
              width: screenSize.width * 0.7,
              loop: false,
            ),
          ),
          Positioned(
            top: screenSize.height * 0.4,
            left: screenSize.width - ((screenSize.width * 0.55)),
            child: CustomButton(
              imagePath: 'assets/images/lobby/start_game.png',
              width: screenSize.width * 0.5,
              onPressed: () {
                Loader.show();
                AppRouter.go(LevelOneRoutes.levelOne.path);
                Loader.dissmiss();
              },
            ),
          ),
          Positioned(
            top: screenSize.height * 0.58,
            left: screenSize.width - ((screenSize.width * 0.2)),
            child: CustomButton(
              imagePath: 'assets/images/lobby/home.png',
              width: screenSize.width * 0.15,
              onPressed: () {
                SnackbarService.show('Proximamente...');
              },
            ),
          ),
          Positioned(
            top: screenSize.height * 0.68,
            left: screenSize.width - ((screenSize.width * 0.35)),
            child: CustomButton(
              imagePath: 'assets/images/lobby/tutorial.png',
              width: screenSize.width * 0.3,
              onPressed: () {
                SnackbarService.show('Proximamente...');
              },
            ),
          ),
          Positioned(
            top: screenSize.height * 0.78,
            left: screenSize.width - ((screenSize.width * 0.2)),
            child: CustomButton(
              imagePath: 'assets/images/lobby/shop.png',
              width: screenSize.width * 0.15,
              onPressed: () {
                SnackbarService.show('Proximamente...');
              },
            ),
          ),
        ],
      ),
    );
  }
}

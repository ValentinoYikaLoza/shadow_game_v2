import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/config/constants/app_colors.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_gif.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_button.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/lifebar.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/skills_dialog.dart';

class InterfaceButtons extends ConsumerWidget {
  final Widget child;
  const InterfaceButtons({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, ref) {
    final screen = MediaQuery.of(context);
    final backgroundState = ref.watch(backgroundProvider);
    final playerState = ref.watch(playerProvider);
    return Stack(
      children: [
        child,
        // coords
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            'x: ${backgroundState.initialPosition}',
            style: const TextStyle(
                fontSize: 18,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                height: 21 / 18,
                decoration: TextDecoration.none),
          ),
        ),
        // coins
        Positioned(
          top: 50,
          right: 20,
          child: Row(
            children: [
              Text(
                '${playerState.coins.round()}',
                style: const TextStyle(
                  fontSize: 26,
                  color: AppColors.golden,
                  fontWeight: FontWeight.w900,
                  height: 28 / 26,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 10),
              CustomGif(
                images: CoinStates.looping.images,
                width: 26,
                loop: true,
              ),
            ],
          ),
        ),
        // players life
        Positioned(
          top: 25,
          right: 20,
          child: Lifebar(
            totalHearts: playerState.maxHealth,
            fullHearts: playerState.health,
          ),
        ),
        // skill button
        Positioned(
          bottom: 30,
          left: screen.size.width / 2 - 75,
          child: CustomButton(
            imagePath: 'assets/images/shared/skillButton.png',
            width: 150,
            onPressed: () {
              SkillDialog.show();
            },
          ),
        ),
      ],
    );
  }
}

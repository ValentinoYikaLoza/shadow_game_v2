import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/config/constants/app_colors.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/custom_button.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/skills_dialog.dart';

class InterfaceButtons extends ConsumerWidget {
  final Widget child;
  const InterfaceButtons({
    super.key,
    required this.child,
  });

  Widget _buildHealthHearts(double health, double maxHealth) {
    double totalHearts = maxHealth; // Total de corazones
    double fullHearts = health; // Número de corazones llenos

    return SizedBox(
      height: 50,
      width: 20 * maxHealth,
      child: Stack(
        children: List.generate(totalHearts.toInt(), (index) {
          double offset =
              index * 18.0; // Desplazamiento para que se superpongan

          Widget heart = (index < fullHearts)
              ? SizedBox(
                  width: 40,
                  child: Image.asset(
                    'assets/icons/life.png',
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(
                  width: 40,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      'assets/icons/life.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                );

          return Positioned(
            left: offset, // Desplazamiento para superponer los corazones
            child: heart,
          );
        }),
      ),
    );
  }

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
        // players life
        if (playerState.isAlive)
          Positioned(
              top: 10,
              right: 20,
              child: _buildHealthHearts(
                  playerState.health, playerState.maxHealth)),
        // skill button
        Positioned(
          bottom: 40,
          left: screen.size.width / 2 - 36.5,
          child: CustomButton(
            imagePath: 'assets/images/shared/skillButton.png',
            scale: 2,
            onPressed: () {
              SkillDialog.show();
            },
          ),
        ),
      ],
    );
  }
}

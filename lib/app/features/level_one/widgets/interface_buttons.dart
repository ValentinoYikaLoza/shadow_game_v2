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
    final backgroundState = ref.watch(backgroundProvider);
    final playerState = ref.watch(playerProvider);
    final screenSize = MediaQuery.of(context).size;
    final groundHeight = screenSize.height * 0.13;
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
          bottom: groundHeight,
          left: screenSize.width / 2 - (screenSize.width * 0.2) / 2,
          child: CustomButton(
            imagePath: 'assets/images/lobby/skills.png',
            width: screenSize.width * 0.2,
            onPressed: () {
              SkillDialog.show();
            },
          ),
        ),

        Positioned(
          bottom: screenSize.height * 0.08,
          left: screenSize.width / 2 - (screenSize.width * 0.15) / 2,
          child: CustomButton(
            imagePath: 'assets/images/lobby/tutorial.png',
            width: screenSize.width * 0.15,
            onPressed: () {
              // SnackbarService.showMultipleMessages(
              //   [
              //     'Hola soy Shadow, y este es mi juego',
              //     'te enseñaré lo básico para aprender a moverte',
              //     'debes mantener presionado y luego deslizar en circulos',
              //     'nos moveremos a la dirección donde presiones',
              //     'cuando te encuentres con un enemigo no podrás moverte',
              //     'tendrás que matar al enemigo, es muy facil...',
              //     'solo presionas encima del enemigo y le harás daño',
              //     'consejo: presiona muchas veces para matarlo',
              //     'una vez muerto podrás seguir avanzando',
              //     'cuando encuentres un cofre pasa por encima y se abrirá',
              //     'por ahora solo te da monedas',
              //     'pero pronto se irán añadiendo otros objetos',
              //     'las monedas sirven para aumentar tus habilidades',
              //     'si presionas en skills, podrás subirlas de nivel',
              //     'eso sería todo, disfruta el juego',
              //   ],
              //   type: SnackbarType.tutorial,
              // );
            },
          ),
        ),
      ],
    );
  }
}

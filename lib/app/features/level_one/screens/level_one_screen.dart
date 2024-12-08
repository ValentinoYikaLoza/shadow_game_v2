import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/gestures.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/interface_buttons.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/objects.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/parallax_background.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/skills_dialog.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/characters.dart'
    as characters;

class LevelOneScreen extends ConsumerStatefulWidget {
  const LevelOneScreen({super.key});

  @override
  LevelOneScreenState createState() => LevelOneScreenState();
}

class LevelOneScreenState extends ConsumerState<LevelOneScreen> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    final playerState = ref.watch(playerProvider);
    return Scaffold(
      body: SkillProvider(
        child: InterfaceButtons(
          child: characters.Characters(
            //porque no permite poner el nombre Characters por si solo porque ya hay otra clase con ese nombre
            child: Objects(
              child: Gestures(
                child: Stack(
                  children: [
                    // Capa del cielo con repetición
                    SizedBox(
                      width: screen.size.width,
                      height: screen.size.height,
                      child: ParallaxBackground(
                        imagePath: 'assets/images/level_one/sky.png',
                        position: playerState.skyPosition,
                        speed: playerState.playerSpeed,
                      ),
                    ),
                    // Capa del suelo con repetición
                    SizedBox(
                      width: screen.size.width,
                      height: screen.size.height,
                      child: ParallaxBackground(
                        imagePath: 'assets/images/level_one/ground.png',
                        position: playerState.groundPosition,
                        speed: playerState.playerSpeed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

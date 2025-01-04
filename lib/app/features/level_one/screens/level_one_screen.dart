import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
// import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(playerProvider.notifier).resetData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final backgroundState = ref.watch(backgroundProvider);
    return Scaffold(
      body: SkillProvider(
        child: InterfaceButtons(
          child: characters.Characters(
            //porque no permite poner el nombre Characters por si solo porque ya hay otra clase con ese nombre
            child: Gestures(
              child: Objects(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ParallaxBackground(
                        imagePath: 'assets/images/level_one/sky.png',
                        positionLeft: backgroundState.backgroundPosition,
                        speed: playerState.speed,
                        height: MediaQuery.of(context).size.height * 0.8,
                      ),
                    ),
                    // Ground background always at the bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ParallaxBackground(
                        imagePath: 'assets/images/level_one/ground.png',
                        positionLeft: backgroundState.backgroundPosition,
                        speed: playerState.speed,
                        height: MediaQuery.of(context).size.height *
                            0.3, // Adjust height as needed
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/object_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/shadow_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/parallax_background.dart';

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
    final doorState = ref.watch(objectProvider);
    final dogState = ref.watch(dogProvider);
    return Scaffold(
      body: Stack(
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
          //Puerta
          Positioned(
            bottom: 60,
            left: doorState.initialPosition,
            child: SizedBox(
              width: 100,
              child: Image.asset(
                'assets/images/level_one/door/close_door.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Perro
          Positioned(
            bottom: dogState.positionY,
            left: dogState.positionX,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                dogState.currentDirection == Directions.left
                    ? 3.14159
                    : 0,
              ),
              child: Image.asset(
                width: 80,
                dogState.currentState.gif,
                gaplessPlayback: true,
                key: ValueKey('${dogState.currentState}-${1}'),
              ),
            ),
          ),
          // Jugador
          Positioned(
            bottom: playerState.positionY,
            left: playerState.positionX,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                playerState.currentDirection == Directions.left
                    ? 3.14159
                    : 0,
              ),
              child: Image.asset(
                playerState.currentState.gif,
                gaplessPlayback: true,
                key: ValueKey('${playerState.currentState}-${1}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
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
    final dogState = ref.watch(dogProvider);
    final backgroundState = ref.watch(backgroundProvider);
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
          // Perro
          Positioned(
            bottom: dogState.positionY,
            left: dogState.positionX,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                dogState.currentDirection == ShadowDirections.left
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
                playerState.currentDirection == PlayerDirections.left
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
          Positioned(
            top: 20,
            left: 20,
            child: SizedBox(
              width: 100,
              child: Text(
                'x: ${backgroundState.initialPosition}',
              ),
            ),
          ),
          // Controles táctiles
          Row(
            children: [
              // Zona izquierda
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).moveLeft();
                    });
                  },
                  onDoubleTapDown: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).attack();
                    });
                  },
                  onLongPressMoveUpdate: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).moveLeft();
                    });
                  },
                  onLongPressEnd: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).stopMoving();
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).stopMoving();
                    });
                  },
                  onVerticalDragUpdate: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).jump();
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ),
              // Zona derecha
              Expanded(
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      ref
                          .read(playerProvider.notifier)
                          .moveRight(screen.size.width - 70);
                      ref
                          .read(backgroundProvider.notifier)
                          .updateXCoords(playerState.playerSpeed);
                    });
                  },
                  onDoubleTapDown: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).attack();
                    });
                  },
                  onLongPressMoveUpdate: (_) {
                    setState(() {
                      ref
                          .read(playerProvider.notifier)
                          .moveRight(screen.size.width - 70);
                    });
                  },
                  onLongPressEnd: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).stopMoving();
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).stopMoving();
                    });
                  },
                  onVerticalDragUpdate: (_) {
                    setState(() {
                      ref.read(playerProvider.notifier).jump();
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

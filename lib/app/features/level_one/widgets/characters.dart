import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/shadow_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/characters_animation.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/lifebar.dart';

class Characters extends ConsumerStatefulWidget {
  final Widget child;
  const Characters({
    super.key,
    required this.child,
  });

  @override
  CharactersState createState() => CharactersState();
}

class CharactersState extends ConsumerState<Characters> {
  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final dogState = ref.watch(dogProvider);
    final spiderState = ref.watch(spiderProvider);
    return Stack(
      children: [
        widget.child,
        // Enemigo araña
        Positioned(
          bottom: 80,
          left: spiderState.initialPosition,
          child: GestureDetector(
            onLongPressDown: (_) {
              setState(() {
                ref.read(playerProvider.notifier).attack();
              });
            },
            onLongPressEnd: (_) {
              setState(() {
                ref
                    .read(playerProvider.notifier)
                    .changeState(PlayerStates.stay);
              });
            },
            onTapUp: (_) {
              setState(() {
                ref
                    .read(playerProvider.notifier)
                    .changeState(PlayerStates.stay);
              });
            },
            child: Column(
              children: [
                Lifebar(
                  totalHearts: spiderState.maxHealth,
                  fullHearts: spiderState.health,
                ),
                SizedBox(
                  width: 100,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(
                      spiderState.currentDirection != Directions.left
                          ? 3.14159
                          : 0,
                    ),
                    child: SizedBox(
                      height: 77,
                      width: 95,
                      child: CustomAnimatedSpriteWidget(
                        spritePath: spiderState.currentState.sheet,
                        frameWidth: 95,
                        frameHeight: 77,
                        frameCount: spiderState.currentState.frames,
                        stepTime: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Perro
        Positioned(
          bottom: dogState.positionY,
          left: dogState.positionX,
          child: GestureDetector(
            onLongPressDown: (_) {
              setState(() {
                ref.read(dogProvider.notifier).changeState(ShadowStates.bark);
              });
            },
            onLongPressEnd: (_) {
              setState(() {
                ref.read(dogProvider.notifier).changeState(ShadowStates.sit);
              });
            },
            onTapUp: (_) {
              setState(() {
                ref.read(dogProvider.notifier).changeState(ShadowStates.sit);
              });
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                dogState.currentDirection == Directions.left ? 3.14159 : 0,
              ),
              child: SizedBox(
                height: 72,
                width: 100,
                child: CustomAnimatedSpriteWidget(
                  spritePath: dogState.currentState.sheet,
                  frameWidth: 100,
                  frameHeight: 72,
                  frameCount: dogState.currentState.frames,
                  stepTime: 0.15,
                ),
              ),
            ),
          ),
        ),
        // Jugador
        Positioned(
          bottom: playerState.positionY,
          left: playerState.positionX,
          child: GestureDetector(
            onLongPressDown: (_) {
              setState(() {});
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                playerState.currentDirection == Directions.left ? 3.14159 : 0,
              ),
              child: SizedBox(
                height: 50,
                width: 50,
                child: CustomAnimatedSpriteWidget(
                  spritePath: playerState.currentState.sheet,
                  frameWidth: 50,
                  frameHeight: 50,
                  frameCount: playerState.currentState.frames,
                  stepTime: 0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
                CustomAnimatedSpriteWidget(
                  spritePath: spiderState.currentState.sheet,
                  width: 95,
                  frameWidth: 95,
                  frameHeight: 77,
                  frameCount: spiderState.currentState.frames,
                  stepTime: 0.2,
                  flipHorizontally:
                      spiderState.currentDirection != Directions.left,
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
            child: CustomAnimatedSpriteWidget(
              spritePath: dogState.currentState.sheet,
              width: 80,
              frameWidth: 100,
              frameHeight: 72,
              frameCount: dogState.currentState.frames,
              stepTime: 0.15,
              flipHorizontally: dogState.currentDirection == Directions.left,
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
            child: CustomAnimatedSpriteWidget(
              spritePath: playerState.currentState.sheet,
              width: 50,
              frameWidth: 50,
              frameHeight: 50,
              frameCount: playerState.currentState.frames,
              stepTime: 0.2,
              flipHorizontally:
                  playerState.currentDirection == Directions.left,
            ),
          ),
        ),
      ],
    );
  }
}

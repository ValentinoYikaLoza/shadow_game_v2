import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/shadow_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider_provider.dart';

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
    // final screen = MediaQuery.of(context);
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
                ref.read(dogProvider.notifier).changeState(ShadowStates.sit);
              });
            },
            onTapUp: (_) {
              setState(() {
                ref
                    .read(playerProvider.notifier)
                    .changeState(PlayerStates.stay);
                ref.read(dogProvider.notifier).changeState(ShadowStates.sit);
              });
            },
            child: SizedBox(
              width: 100,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(
                  spiderState.currentDirection != Directions.left ? 3.14159 : 0,
                ),
                child: Image.asset(
                  spiderState.currentState.gif,
                  fit: BoxFit.cover,
                ),
              ),
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
              child: Image.asset(
                width: 80,
                dogState.currentState.gif,
                gaplessPlayback: true,
                key: ValueKey('${dogState.currentState}-${1}'),
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
              child: Image.asset(
                playerState.currentState.gif,
                gaplessPlayback: true,
                key: ValueKey('${playerState.currentState}-${1}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

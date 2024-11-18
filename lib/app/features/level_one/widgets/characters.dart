import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/shadow_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/characters_animation.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/spider_widget.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(spiderProvider.notifier).addSpider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final dogState = ref.watch(dogProvider);
    final spiderState = ref.watch(spiderProvider);
    return Stack(
      children: [
        widget.child,
        // Enemigo araña
        ...List.generate(
          spiderState.spiders.length,
          (index) {
            final spider = spiderState.spiders[index];
            return SpiderWidget(
              spider: spider,
              isBoss: index == 9,
            );
          },
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
              stepTime: dogState.currentState.fps,
              loop: dogState.currentState.loop,
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
              stepTime: playerState.currentState.fps,
              loop: playerState.currentState.loop,
              flipHorizontally: playerState.currentDirection == Directions.left,
            ),
          ),
        ),
      ],
    );
  }
}

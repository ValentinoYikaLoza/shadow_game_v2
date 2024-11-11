import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/shadow_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider2_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/characters_animation.dart';

class SpiderWidget extends ConsumerStatefulWidget {
  final Spider spider;
  const SpiderWidget({
    super.key,
    required this.spider,
  });

  @override
  SpiderWidgetState createState() => SpiderWidgetState();
}

class SpiderWidgetState extends ConsumerState<SpiderWidget> {
  Timer? dieTimer;
  double opacity = 1;

  initOpacity() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        dieTimer = Timer.periodic(
          const Duration(milliseconds: 50),
          (timer) {
            final newOpacity = opacity - 0.1;
            if (newOpacity <= 0) {
              setState(() {
                opacity = 0;
                dieTimer!.cancel();
              });
            } else {
              setState(() {
                opacity = newOpacity;
              });
            }
          },
        );
      });
    });
  }

  @override
  void didUpdateWidget(covariant SpiderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spider.currentState == SpiderStates.die &&
        oldWidget.spider.currentState != SpiderStates.die) {
      initOpacity();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dogState = ref.watch(dogProvider);
    return Positioned(
      bottom: 80,
      left: widget.spider.initialPosition,
      child: GestureDetector(
        onLongPressDown: (_) {
          setState(() {
            dogState.isEnemyNear
                ? ref.read(playerProvider.notifier).attack()
                : null;
          });
        },
        onLongPressEnd: (_) {
          setState(() {
            ref.read(playerProvider.notifier).changeState(PlayerStates.stay);
          });
        },
        onTapUp: (_) {
          setState(() {
            ref.read(playerProvider.notifier).changeState(PlayerStates.stay);
          });
        },
        child: Column(
          children: [
            Opacity(
              opacity: opacity,
              child: CustomAnimatedSpriteWidget(
                spritePath: widget.spider.currentState.sheet,
                width: 95,
                frameWidth: 95,
                frameHeight: 77,
                frameCount: widget.spider.currentState.frames,
                stepTime: widget.spider.currentState.fps,
                loop: widget.spider.currentState.loop,
                flipHorizontally:
                    widget.spider.currentDirection != Directions.left,
                onLastFrame: () {
                  if (widget.spider.currentState == SpiderStates.attack) {
                    setState(() {
                      ref
                          .read(playerProvider.notifier)
                          .takeDamage(widget.spider.attackDamage);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

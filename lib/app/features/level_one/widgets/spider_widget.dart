import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider_provider.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_gif.dart';

class SpiderWidget extends ConsumerStatefulWidget {
  final Spider spider;
  final bool isBoss;
  const SpiderWidget({
    super.key,
    required this.spider,
    this.isBoss = false,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final groundHeight = screenHeight * 0.3;
    return Positioned(
      bottom: widget.isBoss
          ? widget.spider.currentState == SpiderStates.die
              ? groundHeight - 20
              : groundHeight - 5
          : groundHeight - 2,
      left: widget.spider.xCoords,
      child: GestureDetector(
        onLongPressDown: (_) {
          setState(() {
            widget.spider.currentState == SpiderStates.attack
                ? ref.read(playerProvider.notifier).attack()
                : null;
          });
        },
        onLongPressEnd: (_) {
          setState(() {
            ref.read(playerProvider.notifier).updateState(PlayerStates.stay);
          });
        },
        onTapUp: (_) {
          setState(() {
            ref.read(playerProvider.notifier).updateState(PlayerStates.stay);
          });
        },
        child: Opacity(
          opacity: opacity,
          child: CustomGif(
            images: widget.spider.currentState.images,
            width: widget.isBoss ? 475 : 95,
            loop: widget.spider.currentState.loop,
            flip: widget.spider.currentDirection != Directions.left,
            onComplete: () {
              if (widget.spider.currentState == SpiderStates.attack) {
                setState(() {
                  ref
                      .read(playerProvider.notifier)
                      .takeDamage(widget.spider.damage);
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

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
  double opacity = 1.0;

  void initOpacity() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      dieTimer?.cancel();
      dieTimer = Timer.periodic(
        const Duration(milliseconds: 50),
        (timer) {
          if (!mounted) {
            dieTimer?.cancel();
            return;
          }
          setState(() {
            opacity = (opacity - 0.1).clamp(0.0, 1.0);
            if (opacity == 0) {
              dieTimer?.cancel();
            }
          });
        },
      );
    });
  }

  @override
  void didUpdateWidget(covariant SpiderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spider.currentState == SpiderAnimations.die &&
        oldWidget.spider.currentState != SpiderAnimations.die) {
      initOpacity();
    }
  }

  @override
  void dispose() {
    dieTimer?.cancel();
    dieTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final groundHeight = screenHeight * 0.3;
    return Positioned(
      bottom: widget.isBoss
          ? widget.spider.currentState == SpiderAnimations.die
              ? groundHeight - 20
              : groundHeight - 5
          : groundHeight - 2,
      left: widget.spider.xCoords,
      child: GestureDetector(
        onLongPressDown: (_) {
          widget.spider.currentState == SpiderAnimations.attack
              ? ref.read(playerProvider.notifier).attack()
              : null;
        },
        onLongPressEnd: (_) {
          ref.read(playerProvider.notifier).updateState(PlayerAnimations.stay);
        },
        onTapUp: (_) {
          ref.read(playerProvider.notifier).updateState(PlayerAnimations.stay);
        },
        child: Opacity(
          opacity: opacity,
          child: CustomGif(
            images: widget.spider.currentState.state.images,
            width: widget.isBoss ? 475 : 95,
            loop: widget.spider.currentState.state.loop,
            flip: widget.spider.currentDirection != Directions.left,
            onComplete: () {
              if (widget.spider.currentState == SpiderAnimations.attack) {
                ref
                    .read(playerProvider.notifier)
                    .takeDamage(widget.spider.damage);
              }
            },
          ),
        ),
      ),
    );
  }
}

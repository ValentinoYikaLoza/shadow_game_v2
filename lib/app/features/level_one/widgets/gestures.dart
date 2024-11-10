import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/shadow_provider.dart';

class Gestures extends ConsumerStatefulWidget {
  final Widget child;
  const Gestures({
    super.key,
    required this.child,
  });

  @override
  GesturesState createState() => GesturesState();
}

class GesturesState extends ConsumerState<Gestures> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    final dogState = ref.watch(dogProvider);
    return Stack(
      children: [
        widget.child,
        Row(
          children: [
            // Zona izquierda
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    !dogState.isEnemyNear
                        ? ref.read(playerProvider.notifier).moveLeft()
                        : null;
                  });
                },
                onLongPressMoveUpdate: (_) {
                  setState(() {
                    !dogState.isEnemyNear
                        ? ref.read(playerProvider.notifier).moveLeft()
                        : null;
                        print(dogState.positionX);
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
                    !dogState.isEnemyNear
                        ? ref
                            .read(playerProvider.notifier)
                            .moveRight(screen.size.width - 70)
                        : null;
                  });
                },
                onLongPressMoveUpdate: (_) {
                  setState(() {
                    !dogState.isEnemyNear
                        ? ref
                            .read(playerProvider.notifier)
                            .moveRight(screen.size.width - 70)
                        : null;
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
    );
  }
}

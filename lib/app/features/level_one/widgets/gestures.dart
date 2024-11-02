import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

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
    final playerState = ref.watch(playerProvider);
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
    );
  }
}

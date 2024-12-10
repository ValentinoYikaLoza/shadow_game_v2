import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

class Gestures extends ConsumerStatefulWidget {
  final Widget child;

  const Gestures({super.key, required this.child});

  @override
  GesturesState createState() => GesturesState();
}

class GesturesState extends ConsumerState<Gestures> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final playerNotifier = ref.read(playerProvider.notifier);

    return Stack(
      children: [
        widget.child,
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onLongPressMoveUpdate: (_) => playerNotifier.moveLeft(),
                onLongPressEnd: (_) => playerNotifier.stopMoving(),
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onLongPressMoveUpdate: (_) =>
                    playerNotifier.moveRight(screenWidth - 70),
                onLongPressEnd: (_) => playerNotifier.stopMoving(),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

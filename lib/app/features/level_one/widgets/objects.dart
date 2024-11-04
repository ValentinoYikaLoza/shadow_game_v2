import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/door_provider.dart';

class Objects extends ConsumerWidget {
  final Widget child;
  const Objects({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, ref) {
    // final screen = MediaQuery.of(context);
    final doorState = ref.watch(doorProvider);
    final chestState = ref.watch(chestProvider);
    return Stack(
      children: [
        child,
        //Puerta
        Positioned(
          bottom: 63,
          left: doorState.initialPosition,
          child: Column(
            children: [
              Image.asset('assets/gifs/home.gif'),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: Image.asset(
                  doorState.currentState.image,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        // Cofre
        Positioned(
          bottom: 85,
          left: chestState.initialPosition,
          child: SizedBox(
            width: 60,
            child: Image.asset(
              chestState.currentState.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

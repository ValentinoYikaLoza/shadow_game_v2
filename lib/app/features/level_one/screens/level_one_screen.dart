import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/parallax_background.dart';

class LevelOneScreen extends ConsumerStatefulWidget {
  const LevelOneScreen({super.key});

  @override
  LevelOneScreenState createState() => LevelOneScreenState();
}

class LevelOneScreenState extends ConsumerState<LevelOneScreen> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    final playerState = ref.watch(playerProvider);
    return Scaffold(
      body: Stack(
        children: [
          // Capa del cielo con repetición
          SizedBox(
            width: screen.size.width,
            height: screen.size.height,
            child: ParallaxBackground(
              imagePath: 'assets/images/level_one/sky.png',
              position: playerState.skyPosition,
              speed: playerState.playerSpeed,
            ),
          ),
          // Capa del suelo con repetición
          SizedBox(
            width: screen.size.width,
            height: screen.size.height,
            child: ParallaxBackground(
              imagePath: 'assets/images/level_one/ground.png',
              position: playerState.groundPosition,
              speed: playerState.playerSpeed,
            ),
          ),
        ],
      ),
    );
  }
}

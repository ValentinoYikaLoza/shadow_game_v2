import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CustomAnimatedSpriteWidget extends StatelessWidget {
  final String spritePath;
  final double frameWidth;
  final double frameHeight;
  final int frameCount;
  final double stepTime;
  final bool loop;

  const CustomAnimatedSpriteWidget({
    super.key,
    required this.spritePath,
    required this.frameWidth,
    required this.frameHeight,
    required this.frameCount,
    this.stepTime = 0.1,
    this.loop = true,
  });

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: _CustomAnimatedSpriteGame(
        spritePath: spritePath,
        frameWidth: frameWidth,
        frameHeight: frameHeight,
        frameCount: frameCount,
        stepTime: stepTime,
        loop: loop,
      ),
    );
  }
}

class _CustomAnimatedSpriteGame extends FlameGame {
  final String spritePath;
  final double frameWidth;
  final double frameHeight;
  final int frameCount;
  final double stepTime;
  final bool loop;

  _CustomAnimatedSpriteGame({
    required this.spritePath,
    required this.frameWidth,
    required this.frameHeight,
    required this.frameCount,
    required this.stepTime,
    required this.loop,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Cargar el sprite sheet y crear una animación
    final spriteSheet = await images.load(spritePath);
    final spriteFrames = <Sprite>[];

    // Dividir el sprite sheet en cuadros individuales
    for (int i = 0; i < frameCount; i++) {
      spriteFrames.add(
        Sprite(
          spriteSheet,
          srcPosition: Vector2(frameWidth * i, 0),
          srcSize: Vector2(frameWidth, frameHeight),
          
        ),
      );
    }

    // Crear la animación con los cuadros
    final spriteAnimation = SpriteAnimation.spriteList(
      spriteFrames,
      stepTime: stepTime,
      loop: loop
    );

    // Crear un componente animado
    final animatedComponent = SpriteAnimationComponent()
      ..animation = spriteAnimation
      ..size = Vector2(frameWidth, frameHeight);

    add(animatedComponent);
  }
}

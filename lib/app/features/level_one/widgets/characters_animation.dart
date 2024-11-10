import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CustomAnimatedSpriteWidget extends StatefulWidget {
  final String spritePath;
  final double frameWidth;
  final double frameHeight;
  final int frameCount;
  final double stepTime;
  final bool loop;
  final double? width;
  final bool flipHorizontally;

  const CustomAnimatedSpriteWidget({
    super.key,
    required this.spritePath,
    required this.frameWidth,
    required this.frameHeight,
    required this.frameCount,
    this.stepTime = 0.1,
    this.loop = true,
    this.width,
    this.flipHorizontally = false,
  });

  @override
  State<CustomAnimatedSpriteWidget> createState() => _CustomAnimatedSpriteWidgetState();
}

class _CustomAnimatedSpriteWidgetState extends State<CustomAnimatedSpriteWidget> {
  _CustomAnimatedSpriteGame? _game;
  String? _currentSpritePath;
  
  @override
  void initState() {
    super.initState();
    _createGame();
  }

  @override
  void didUpdateWidget(CustomAnimatedSpriteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spritePath != oldWidget.spritePath ||
        widget.frameCount != oldWidget.frameCount ||
        widget.stepTime != oldWidget.stepTime) {
      _createGame();
    }
  }

  void _createGame() {
    if (_currentSpritePath != widget.spritePath) {
      _currentSpritePath = widget.spritePath;
      _game = _CustomAnimatedSpriteGame(
        spritePath: widget.spritePath,
        frameWidth: widget.frameWidth,
        frameHeight: widget.frameHeight,
        frameCount: widget.frameCount,
        stepTime: widget.stepTime,
        loop: widget.loop,
        widgetWidth: widget.width,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.frameHeight / widget.frameWidth;
    final calculatedHeight = widget.width != null ? widget.width! * aspectRatio : widget.frameHeight;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(widget.flipHorizontally ? 3.14159 : 0),
      child: SizedBox(
        width: widget.width,
        height: calculatedHeight,
        child: _game != null ? GameWidget(game: _game!) : Container(),
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
  final double? widgetWidth;
  SpriteAnimationComponent? _animatedComponent;
  bool _isLoaded = false;

  _CustomAnimatedSpriteGame({
    required this.spritePath,
    required this.frameWidth,
    required this.frameHeight,
    required this.frameCount,
    required this.stepTime,
    required this.loop,
    this.widgetWidth,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (!_isLoaded) {
      await _loadAnimation();
      _isLoaded = true;
    }
  }

  Future<void> _loadAnimation() async {
    try {
      if (_animatedComponent != null) {
        remove(_animatedComponent!);
      }

      final spriteSheet = await images.load(spritePath);
      final spriteFrames = List<Sprite>.generate(
        frameCount,
        (i) => Sprite(
          spriteSheet,
          srcPosition: Vector2(frameWidth * i, 0),
          srcSize: Vector2(frameWidth, frameHeight),
        ),
      );

      final spriteAnimation = SpriteAnimation.spriteList(
        spriteFrames,
        stepTime: stepTime,
        loop: loop,
      );

      _animatedComponent = SpriteAnimationComponent()
        ..animation = spriteAnimation
        ..anchor = Anchor.center;

      if (widgetWidth != null) {
        double aspectRatio = frameHeight / frameWidth;
        _animatedComponent!.size = Vector2(widgetWidth!, widgetWidth! * aspectRatio);
      } else {
        _animatedComponent!.size = Vector2(frameWidth, frameHeight);
      }

      _animatedComponent!.position = size / 2;
      await add(_animatedComponent!);
    } catch (e) {
      debugPrint('Error loading animation: $e');
    }
  }

  @override
  void update(double dt) {
    if (_isLoaded && _animatedComponent != null) {
      _animatedComponent!.position = size / 2;
    }
    super.update(dt);
  }
}
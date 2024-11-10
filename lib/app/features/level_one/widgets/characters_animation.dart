import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// Widget que muestra una animación de sprite personalizada
/// Maneja la configuración inicial y la presentación del sprite animado
class CustomAnimatedSpriteWidget extends StatefulWidget {
  // Ruta al archivo de imagen del spritesheet
  final String spritePath;
  // Ancho de cada frame individual en el spritesheet
  final double frameWidth;
  // Alto de cada frame individual en el spritesheet
  final double frameHeight;
  // Número total de frames en la animación
  final int frameCount;
  // Tiempo entre cada frame (en segundos)
  final double stepTime;
  // Si la animación debe repetirse
  final bool loop;
  // Ancho opcional para el widget (escala la animación)
  final double? width;
  // Si el sprite debe voltearse horizontalmente
  final bool flipHorizontally;
  // Función que se ejecutará cuando se llegue al último frame
  final VoidCallback? onLastFrame;

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
    this.onLastFrame,
  });

  @override
  State<CustomAnimatedSpriteWidget> createState() =>
      _CustomAnimatedSpriteWidgetState();
}

class _CustomAnimatedSpriteWidgetState
    extends State<CustomAnimatedSpriteWidget> {
  // Instancia del juego que maneja la animación
  _CustomAnimatedSpriteGame? _game;
  // Almacena la ruta actual del sprite para detectar cambios
  String? _currentSpritePath;

  @override
  void initState() {
    super.initState();
    _createGame();
  }

  /// Se llama cuando las propiedades del widget cambian
  /// Recrea el juego si cambian propiedades importantes
  @override
  void didUpdateWidget(CustomAnimatedSpriteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spritePath != oldWidget.spritePath ||
        widget.frameCount != oldWidget.frameCount ||
        widget.stepTime != oldWidget.stepTime) {
      _createGame();
    }
  }

  /// Crea una nueva instancia del juego si la ruta del sprite ha cambiado
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
        onLastFrame: widget.onLastFrame,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcula las dimensiones manteniendo la proporción aspect ratio
    final aspectRatio = widget.frameHeight / widget.frameWidth;
    final calculatedHeight =
        widget.width != null ? widget.width! * aspectRatio : widget.frameHeight;

    // Construye el widget con transformación opcional para volteo horizontal
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

/// Clase principal del juego que maneja la lógica de la animación
class _CustomAnimatedSpriteGame extends FlameGame {
  final String spritePath;
  final double frameWidth;
  final double frameHeight;
  final int frameCount;
  final double stepTime;
  final bool loop;
  final double? widgetWidth;
  final VoidCallback? onLastFrame;
  CustomSpriteAnimationComponent? _animatedComponent;
  bool _isLoaded = false;

  _CustomAnimatedSpriteGame({
    required this.spritePath,
    required this.frameWidth,
    required this.frameHeight,
    required this.frameCount,
    required this.stepTime,
    required this.loop,
    this.widgetWidth,
    this.onLastFrame,
  });

  // Hace el fondo transparente
  @override
  Color backgroundColor() => Colors.transparent;

  /// Se llama cuando el juego se inicializa
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (!_isLoaded) {
      await _loadAnimation();
      _isLoaded = true;
    }
  }

  /// Carga la animación desde el spritesheet
  Future<void> _loadAnimation() async {
    try {
      // Elimina la animación anterior si existe
      if (_animatedComponent != null) {
        remove(_animatedComponent!);
      }

      // Carga el spritesheet
      final spriteSheet = await images.load(spritePath);
      
      // Genera la lista de sprites individuales del spritesheet
      final spriteFrames = List<Sprite>.generate(frameCount, (i) => 
        Sprite(
          spriteSheet,
          srcPosition: Vector2(frameWidth * i, 0),
          srcSize: Vector2(frameWidth, frameHeight),
        )
      );

      // Crea la animación con los sprites
      final spriteAnimation = SpriteAnimation.spriteList(
        spriteFrames,
        stepTime: stepTime,
        loop: loop,
      );

      // Crea el componente de animación personalizado
      _animatedComponent = CustomSpriteAnimationComponent(
        animation: spriteAnimation,
        frameCount: frameCount,
        stepTime: stepTime,
        onLastFrame: onLastFrame,
      )..anchor = Anchor.center;

      // Ajusta el tamaño del componente
      if (widgetWidth != null) {
        double aspectRatio = frameHeight / frameWidth;
        _animatedComponent!.size =
            Vector2(widgetWidth!, widgetWidth! * aspectRatio);
      } else {
        _animatedComponent!.size = Vector2(frameWidth, frameHeight);
      }

      // Centra el componente
      _animatedComponent!.position = size / 2;
      await add(_animatedComponent!);
    } catch (e) {
      debugPrint('Error loading animation: $e');
    }
  }

  /// Actualiza la posición del componente en cada frame
  @override
  void update(double dt) {
    if (_isLoaded && _animatedComponent != null) {
      _animatedComponent!.position = size / 2;
    }
    super.update(dt);
  }
}

/// Componente personalizado que maneja la lógica de la animación frame por frame
class CustomSpriteAnimationComponent extends SpriteAnimationComponent {
  final int frameCount;
  final double stepTime;
  final VoidCallback? onLastFrame;
  // Tiempo acumulado desde el último cambio de frame
  double _elapsedTime = 0;
  // Frame actual de la animación
  int _currentFrame = 0;

  CustomSpriteAnimationComponent({
    required SpriteAnimation animation,
    required this.frameCount,
    required this.stepTime,
    this.onLastFrame,
  }) : super(animation: animation);

  /// Se llama en cada frame del juego
  @override
  void update(double dt) {
    super.update(dt);
    
    if (animation == null) return;

    // Acumula el tiempo transcurrido
    _elapsedTime += dt;
    
    // Cuando el tiempo acumulado supera el stepTime, cambia al siguiente frame
    if (_elapsedTime >= stepTime) {
      _elapsedTime = 0; // Reinicia el contador de tiempo
      _currentFrame = (_currentFrame + 1) % frameCount; // Avanza al siguiente frame
      
      // Solo llama a la función cuando es el último frame
      if (_currentFrame == frameCount - 1) {
        onLastFrame?.call();
      }
    }
  }
}
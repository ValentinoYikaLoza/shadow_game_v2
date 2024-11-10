import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

final spiderProvider =
    StateNotifierProvider<SpiderNotifier, SpiderState>((ref) {
  return SpiderNotifier(ref);
});

class SpiderNotifier extends StateNotifier<SpiderState> {
  SpiderNotifier(this.ref) : super(SpiderState()) {
    // Escuchar los cambios del jugador para actualizar la posición y dirección del perro
    ref.listen(playerProvider, (previous, next) {
      followPlayer(previous, next);
    });
  }
  final Ref ref;
  double? previousPositionX;

  void updateXCoords(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;
    state = state.copyWith(
      initialPosition: newPosition.roundToDouble(),
    );
    // print(state.initialPosition);
  }

  void followPlayer(PlayerState? previousState, PlayerState playerState) {
    // Definimos la distancia a mantener detrás del jugador
    const double followDistance = 100.0;

    // Actualizar la posición y dirección del perro para que siga al jugador
    if (playerState.positionX < state.initialPosition - followDistance &&
        isPlayerColliding(playerState.positionX)) {
      // Si el jugador está a la izquierda y el perro está demasiado lejos
      state = state.copyWith(
        initialPosition: playerState.positionX + followDistance,
        currentState: SpiderStates.walk,
        currentDirection: Directions.left,
      );
    } else if (playerState.positionX > state.initialPosition + followDistance &&
        isPlayerColliding(playerState.positionX)) {
      // Si el jugador está a la derecha y el perro está demasiado lejos
      state = state.copyWith(
        initialPosition: playerState.positionX - followDistance,
        currentState: SpiderStates.walk,
        currentDirection: Directions.right,
      );
    } else {
      // ataca
      if (!isPlayerColliding(playerState.positionX)) {
        state = state.copyWith(
          currentState: SpiderStates.stay,
          currentDirection: playerState.positionX < state.initialPosition
              ? Directions.left
              : Directions.right,
        );
      } else {
        state = state.copyWith(
          currentState:
              state.health <= 0 ? SpiderStates.die : SpiderStates.attack,
          currentDirection: playerState.positionX < state.initialPosition
              ? Directions.left
              : Directions.right,
        );
      }
    }
  }

  void changeState(SpiderStates newState) {
    state = state.copyWith(
      currentState: newState,
    );
  }

  bool isPlayerColliding(double playerX) {
    // Define el área de colisión del objeto
    final objectLeft = state.initialPosition - (state.width / 2);
    final objectRight = state.initialPosition + (state.width / 2);

    // Define el área de colisión del jugador
    // Asumimos que el jugador tiene un área de colisión más pequeña que su sprite
    const playerWidth = 50.0; // Ajusta según el tamaño real del jugador
    final playerLeft = playerX - (playerWidth / 2);
    final playerRight = playerX + (playerWidth / 2);

    // Verifica si hay superposición en ambos ejes
    bool colisionHorizontal =
        playerRight >= objectLeft && playerLeft <= objectRight;

    return colisionHorizontal;
  }

  void takeDamage(double damage) {
    final newHealth = state.health - damage;
    state = state.copyWith(
      health: newHealth,
    );
  }

  //verificar porque el state.copywith no funciona
  void die() {
    print('muelto');
    state = state.copyWith(
      currentState: SpiderStates.die,
    );
  }

  //verificar si este funciona
  void attackPlayer() {
    state = state.copyWith(
      currentState: SpiderStates.attack,
    );

    ref.read(playerProvider.notifier).takeDamage(state.attackDamage);
  }
}

class SpiderState {
  final double initialPosition;
  final SpiderStates currentState;
  final Directions currentDirection;
  final double width;
  final double health;
  final double maxHealth;
  final double attackDamage;

  SpiderState({
    this.initialPosition = 500,
    this.currentState = SpiderStates.stay,
    this.currentDirection = Directions.left,
    this.width = 200,
    this.health = 5,
    this.maxHealth = 5,
    this.attackDamage = 1,
  });

  SpiderState copyWith({
    double? initialPosition,
    SpiderStates? currentState,
    Directions? currentDirection,
    double? width,
    double? health,
    double? maxHealth,
    double? attackDamage,
  }) {
    return SpiderState(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      currentDirection: currentDirection ?? this.currentDirection,
      width: width ?? this.width,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      attackDamage: attackDamage ?? this.attackDamage,
    );
  }
}

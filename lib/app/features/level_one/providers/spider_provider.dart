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

  void updateXCoords(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;
    state = state.copyWith(
      initialPosition: newPosition.roundToDouble(),
    );
    // print(state.initialPosition);
  }

  void followPlayer(PlayerState? previousState, PlayerState playerState) {
    // Definimos la distancia a mantener detrás del jugador
    const double followDistance = 80.0;

    // Actualizar la posición y dirección de la araña para que siga al jugador
    if (playerState.positionX < state.initialPosition - followDistance) {
      // Si el jugador está a la izquierda y la araña está demasiado lejos
      state = state.copyWith(
        currentDirection: Directions.left,
      );
    } else if (playerState.positionX > state.initialPosition + followDistance) {
      // Si el jugador está a la derecha y la araña está demasiado lejos
      state = state.copyWith(
        currentDirection: Directions.right,
      );
    } else {
      // ataca si la araña está cerca del jugador
      state = state.copyWith(
        currentDirection: playerState.positionX < state.initialPosition
            ? Directions.left
            : Directions.right,
      );
    }
  }

  void attack() {
    state = state.copyWith(currentState: SpiderStates.attack);
  }

  void die() {
    state = state.copyWith(currentState: SpiderStates.die);
  }

  void walk() {
    state = state.copyWith(currentState: SpiderStates.walk);
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
}

class SpiderState {
  final double initialPosition;
  final SpiderStates currentState;
  final Directions currentDirection;
  final double width;

  SpiderState({
    this.initialPosition = 500,
    this.currentState = SpiderStates.stay,
    this.currentDirection = Directions.left,
    this.width = 120,
  });

  SpiderState copyWith({
    double? initialPosition,
    SpiderStates? currentState,
    Directions? currentDirection,
    double? width,
  }) {
    return SpiderState(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      currentDirection: currentDirection ?? this.currentDirection,
      width: width ?? this.width,
    );
  }
}

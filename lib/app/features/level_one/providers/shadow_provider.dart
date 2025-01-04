import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider_2.dart';

class DogState {
  final double xCoords;
  final ShadowStates currentState;
  final Directions currentDirection;
  final bool isEnemyNear;

  DogState({
    this.xCoords = 45,
    this.isEnemyNear = false,
    this.currentState = ShadowStates.sit,
    this.currentDirection = Directions.left,
  });

  DogState copyWith({
    double? xCoords,
    ShadowStates? currentState,
    Directions? currentDirection,
    bool? isEnemyNear,
  }) {
    return DogState(
      xCoords: xCoords ?? this.xCoords,
      currentState: currentState ?? this.currentState,
      currentDirection: currentDirection ?? this.currentDirection,
      isEnemyNear: isEnemyNear ?? this.isEnemyNear,
    );
  }
}

class DogNotifier extends StateNotifier<DogState> {
  DogNotifier(this.ref) : super(DogState()) {
    // Escuchar los cambios del jugador para actualizar la posición y dirección del perro
    ref.listen(playerProvider, (previous, next) {
      followPlayer(previous, next);
    });
  }
  //! Refactorizar el código para que sea más legible
  final Ref ref;
  double? previousPositionX;

  /// Restablece el estado de las arañas
  void resetData() {
    state = DogState(); // Restaura el estado inicial
  }

  void followPlayer(PlayerState? previousState, PlayerState playerState) {
    // Definimos la distancia a mantener detrás del jugador
    const double followDistance = 80.0;

    // Verifica si la posición X del jugador ha cambiado
    bool hasPositionChanged =
        previousPositionX != null && previousPositionX != playerState.xCoords;
    previousPositionX = playerState.xCoords;

    // Si estaba caminando y ahora salta, mantiene la caminata
    if (!hasPositionChanged &&
        (playerState.currentState == PlayerStates.walk ||
            playerState.currentState == PlayerStates.jump)) {
      state = state.copyWith(currentState: ShadowStates.walk);
      return;
    }

    // Actualizar la posición y dirección del perro para que siga al jugador
    if (playerState.xCoords < state.xCoords - followDistance) {
      // Si el jugador está a la izquierda y el perro está demasiado lejos
      state = state.copyWith(
        xCoords: playerState.xCoords + followDistance,
        currentState: ShadowStates.walk,
        currentDirection: Directions.left,
      );
    } else if (playerState.xCoords > state.xCoords + followDistance) {
      // Si el jugador está a la derecha y el perro está demasiado lejos
      state = state.copyWith(
        xCoords: playerState.xCoords - followDistance,
        currentState: ShadowStates.walk,
        currentDirection: Directions.right,
      );
    } else {
      // si el jugador está quieto
      state = state.copyWith(
        currentState: state.isEnemyNear ? ShadowStates.bark : ShadowStates.sit,
        currentDirection: playerState.xCoords < state.xCoords
            ? Directions.left
            : Directions.right,
      );
    }
  } 

  void help() {
    state = state.copyWith(
      isEnemyNear: true,
      currentState: ShadowStates.bark,
    );
  }

  void changeState(ShadowStates newState) {
    state = state.copyWith(
      currentState: newState,
    );
  }
}

final dogProvider = StateNotifierProvider<DogNotifier, DogState>((ref) {
  return DogNotifier(ref);
});
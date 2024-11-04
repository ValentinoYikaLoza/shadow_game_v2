import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

final dogProvider = StateNotifierProvider<DogNotifier, DogState>((ref) {
  return DogNotifier(ref);
});

class DogNotifier extends StateNotifier<DogState> {
  DogNotifier(this.ref) : super(DogState()) {
    // Escuchar los cambios del jugador para actualizar la posición y dirección del perro
    ref.listen(playerProvider, (previous, next) {
      followPlayer(previous, next);
    });
  }
  final Ref ref;
  double? previousPositionX;

  void followPlayer(PlayerState? previousState, PlayerState playerState) {
    // Definimos la distancia a mantener detrás del jugador
    const double followDistance = 80.0;

    // Verifica si la posición X del jugador ha cambiado
    bool hasPositionChanged =
        previousPositionX != null && previousPositionX != playerState.positionX;
    previousPositionX = playerState.positionX;

    // Si estaba caminando y ahora salta, mantiene la caminata
    if (!hasPositionChanged &&
        (playerState.currentState == PlayerStates.walk ||
            playerState.currentState == PlayerStates.jump)) {
      state = state.copyWith(currentState: ShadowStates.walk);
      return;
    }

    // Actualizar la posición y dirección del perro para que siga al jugador
    if (playerState.positionX < state.positionX - followDistance) {
      // Si el jugador está a la izquierda y el perro está demasiado lejos
      state = state.copyWith(
        positionX: playerState.positionX + followDistance,
        currentState: ShadowStates.walk,
        currentDirection: Directions.left,
      );
    } else if (playerState.positionX > state.positionX + followDistance) {
      // Si el jugador está a la derecha y el perro está demasiado lejos
      state = state.copyWith(
        positionX: playerState.positionX - followDistance,
        currentState: ShadowStates.walk,
        currentDirection: Directions.right,
      );
    } else {
      // Solo se sienta si no estaba caminando previamente
      state = state.copyWith(
        currentState: ShadowStates.sit,
        currentDirection: playerState.positionX < state.positionX
            ? Directions.left
            : Directions.right,
      );
    }
  }

  void changeState(ShadowStates newState) {
    state = state.copyWith(
      currentState: newState,
    );
  }
}

class DogState {
  final double positionX;
  final double positionY;
  final ShadowStates currentState;
  final Directions currentDirection;

  DogState({
    this.positionX = 45,
    this.positionY = 82,
    this.currentState = ShadowStates.sit,
    this.currentDirection = Directions.left,
  });

  DogState copyWith({
    double? positionX,
    double? positionY,
    ShadowStates? currentState,
    Directions? currentDirection,
  }) {
    return DogState(
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      currentState: currentState ?? this.currentState,
      currentDirection: currentDirection ?? this.currentDirection,
    );
  }
}

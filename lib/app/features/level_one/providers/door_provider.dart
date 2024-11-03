import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';

final doorProvider = StateNotifierProvider<DoorNotifier, DoorState>((ref) {
  return DoorNotifier(ref);
});

class DoorNotifier extends StateNotifier<DoorState> {
  DoorNotifier(this.ref) : super(DoorState());
  final Ref ref;

  void updateXCoords(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;
    state = state.copyWith(
      initialPosition: newPosition.roundToDouble(),
    );
    // print(state.initialPosition);
  }

  void openDoor() {
    state = state.copyWith(
      currentState: DoorStates.open,
    );
  }

  void closeDoor() {
    state = state.copyWith(
      currentState: DoorStates.close,
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
}

class DoorState {
  final double initialPosition;
  final DoorStates currentState;
  final double width;

  DoorState({
    this.initialPosition = 100,
    this.currentState = DoorStates.close,
    this.width = 80,
  });

  DoorState copyWith({
    double? initialPosition,
    DoorStates? currentState,
    double? width,
  }) {
    return DoorState(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      width: width ?? this.width,
    );
  }
}

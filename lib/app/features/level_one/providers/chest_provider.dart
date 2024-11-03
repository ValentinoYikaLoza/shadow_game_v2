import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';

final chestProvider = StateNotifierProvider<ChestNotifier, ChestState>((ref) {
  return ChestNotifier(ref);
});

class ChestNotifier extends StateNotifier<ChestState> {
  ChestNotifier(this.ref) : super(ChestState());
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
      currentState: ChestStates.open,
    );
  }

  void closeDoor() {
    state = state.copyWith(
      currentState: ChestStates.close,
    );
  }

  bool isPlayerColliding(double playerX, double playerY) {
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

class ChestState {
  final double initialPosition;
  final ChestStates currentState;
  final double width;

  ChestState({
    this.initialPosition = 500,
    this.currentState = ChestStates.close,
    this.width = 80,
  });

  ChestState copyWith({
    double? initialPosition,
    ChestStates? currentState,
    double? width,
  }) {
    return ChestState(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      width: width ?? this.width,
    );
  }
}

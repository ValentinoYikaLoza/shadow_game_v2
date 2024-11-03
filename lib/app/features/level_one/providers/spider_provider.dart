import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';

final spiderProvider =
    StateNotifierProvider<SpiderNotifier, SpiderState>((ref) {
  return SpiderNotifier(ref);
});

class SpiderNotifier extends StateNotifier<SpiderState> {
  SpiderNotifier(this.ref) : super(SpiderState());
  final Ref ref;

  void updateXCoords(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;
    state = state.copyWith(
      initialPosition: newPosition.roundToDouble(),
    );
    // print(state.initialPosition);
  }

  void attack(){
    state = state.copyWith(
      currentState: SpiderStates.attack
    );
  }

  void die(){
    state = state.copyWith(
      currentState: SpiderStates.die
    );
  }

  void walk(){
    state = state.copyWith(
      currentState: SpiderStates.walk
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

class SpiderState {
  final double initialPosition;
  final SpiderStates currentState;
  final double width;

  SpiderState({
    this.initialPosition = 500,
    this.currentState = SpiderStates.stay,
    this.width = 120,
  });

  SpiderState copyWith({
    double? initialPosition,
    SpiderStates? currentState,
    double? width,
  }) {
    return SpiderState(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      width: width ?? this.width,
    );
  }
}

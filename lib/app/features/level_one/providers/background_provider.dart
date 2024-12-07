import 'package:flutter_riverpod/flutter_riverpod.dart';

final backgroundProvider =
    StateNotifierProvider<BackgroundNotifier, BackgroundState>((ref) {
  return BackgroundNotifier(ref);
});

class BackgroundNotifier extends StateNotifier<BackgroundState> {
  BackgroundNotifier(this.ref) : super(BackgroundState());
  final Ref ref;

  void updateXCoords(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;
    state = state.copyWith(
      initialPosition: newPosition.roundToDouble(),
    );
  }

  // Método para verificar si se puede mover a la izquierda
  bool canMoveLeft(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;

    // Permite el movimiento solo si la nueva posición es mayor que 0
    return newPosition > 0;
  }

  // Método para verificar si se puede mover a la derecha
  bool canMoveRight(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;

    // Permite el movimiento solo si la nueva posición no excede el límite derecho
    return newPosition < state.rightLimit;
  }

  setRightLimit(double rightLimit) {
    state = state.copyWith(
      rightLimit: rightLimit,
    );
  }
}

class BackgroundState {
  final double initialPosition;
  final double rightLimit;

  BackgroundState({
    this.initialPosition = 0,
    this.rightLimit = 5000,
  });

  BackgroundState copyWith({
    double? initialPosition,
    double? rightLimit,
  }) {
    return BackgroundState(
      initialPosition: initialPosition ?? this.initialPosition,
      rightLimit: rightLimit ?? this.rightLimit,
    );
  }
}

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
    return newPosition > 0; // Permite el movimiento solo si la nueva posición es mayor que 0
  }
}

class BackgroundState {
  final double initialPosition;

  BackgroundState({
    this.initialPosition = 0,
  });

  BackgroundState copyWith({
    double? initialPosition,
  }) {
    return BackgroundState(
      initialPosition: initialPosition ?? this.initialPosition,
    );
  }
}

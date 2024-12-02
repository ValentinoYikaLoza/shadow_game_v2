import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/door_provider.dart';

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

  bool canMoveRight(double distanciaRecorrida) {
    final newPosition = state.initialPosition + distanciaRecorrida;

    final doorState = ref.watch(doorProvider);

    debugPrint(doorState.doors.map((door) {
      return door.initialPosition;
    }).toString());

    // Busca la puerta de tipo finish y obtiene su posición inicial
    final lastDoor = doorState.doors.where(
      (door) {
        return door.doorType == DoorType.finish;
      },
    ).toList();

    if (lastDoor.isEmpty) return newPosition < 1000000;

    debugPrint(lastDoor.first.initialPosition.toString());

    // Solo permite moverse si la nueva posición es menor a la posición de la puerta de salida
    return newPosition < lastDoor.first.initialPosition + 100;
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

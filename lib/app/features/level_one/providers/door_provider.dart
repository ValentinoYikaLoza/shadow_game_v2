import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';

final doorProvider = StateNotifierProvider<DoorNotifier, DoorState>((ref) {
  return DoorNotifier(ref);
});

class DoorNotifier extends StateNotifier<DoorState> {
  DoorNotifier(this.ref) : super(DoorState());
  final Ref ref;

  void addDoor(
      {double initialPosition = 100, DoorType doorType = DoorType.start}) {
    // print('cofre en x:$initialPosition');
    state = state.copyWith(
      doors: [
        ...state.doors,
        Door(
          initialPosition: initialPosition,
          doorType: doorType,
        )
      ],
    );
  }

  void updateXCoords(double distanciaRecorrida) {
    state = state.copyWith(
        doors: state.doors.map((door) {
      final newPosition = door.initialPosition + distanciaRecorrida;

      return door.copyWith(
        initialPosition: newPosition.roundToDouble(),
      );
    }).toList());
  }

  bool isPlayerColliding(double playerX, Door door) {
    // Define el área de colisión del objeto
    final objectLeft = door.initialPosition - (door.width / 2);
    final objectRight = door.initialPosition + (door.width / 2);

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

  void isAnyDoorNear(double playerX) {
    state = state.copyWith(
      doors: state.doors.map(
        (door) {
          if (isPlayerColliding(playerX, door)) {
            // followPlayer(spider);
            return door.copyWith(
              currentState: DoorStates.open,
            );
          } else {
            return door.copyWith(
              currentState: DoorStates.close,
            );
          }
        },
      ).toList(),
    );
  }
}

class DoorState {
  final List<Door> doors;

  DoorState({
    this.doors = const [],
  });

  DoorState copyWith({
    List<Door>? doors,
  }) {
    return DoorState(
      doors: doors ?? this.doors,
    );
  }
}

class Door {
  final double initialPosition;
  final DoorStates currentState;
  final DoorType doorType;
  final double width;

  Door({
    this.initialPosition = 100,
    this.currentState = DoorStates.close,
    this.doorType = DoorType.start,
    this.width = 100,
  });

  Door copyWith({
    double? initialPosition,
    DoorStates? currentState,
    DoorType? doorType,
    double? width,
  }) {
    return Door(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      doorType: doorType ?? this.doorType,
      width: width ?? this.width,
    );
  }
}

enum DoorType {
  start,
  finish,
}

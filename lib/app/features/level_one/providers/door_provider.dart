import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

enum DoorType { start, finish }

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
  final double xCoords;
  final DoorStates currentState;
  final DoorType doorType;
  final double width;

  Door({
    this.xCoords = 100,
    this.currentState = DoorStates.close,
    this.doorType = DoorType.start,
    this.width = 120,
  });

  Door copyWith({
    double? xCoords,
    DoorStates? currentState,
    DoorType? doorType,
    double? width,
  }) {
    return Door(
      xCoords: xCoords ?? this.xCoords,
      currentState: currentState ?? this.currentState,
      doorType: doorType ?? this.doorType,
      width: width ?? this.width,
    );
  }
}

class DoorNotifier extends StateNotifier<DoorState> {
  DoorNotifier(this.ref) : super(DoorState());
  final Ref ref;

  /// Restablece el estado de las arañas
  void resetData() {
    state = DoorState(); // Restaura el estado inicial
  }

  void addDoor(
      {double xCoords = 100, DoorType doorType = DoorType.start}) {
    state = state.copyWith(
      doors: [
        ...state.doors,
        Door(xCoords: xCoords, doorType: doorType)
      ],
    );
  }

  void updateXCoords(double distance) {
    state = state.copyWith(
        doors: state.doors.map((door) {
      final newPosition = door.xCoords - distance;

      if (canMove()) return door;

      if (!canMoveLeft(distance) || !canMoveRight(distance)) return door;

      return door.copyWith(
        xCoords: newPosition,
      );
    }).toList());
  }

  bool canMove() {
    final playerState = ref.read(playerProvider);
    return playerState.isBetweenTheLimits;
  }

  bool canMoveLeft(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveLeft(distance);
  }

  bool canMoveRight(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveRight(distance);
  }

  bool isPlayerColliding(double playerX, Door door) {
    final leftBoundary = door.xCoords;
    final rightBoundary = door.xCoords + door.width;

    const playerWidth = 50.0;
    final playerLeftBoundary = playerX;
    final playerRightBoundary = playerX + (playerWidth / 2);

    bool colisionHorizontal = playerRightBoundary >= leftBoundary &&
        playerLeftBoundary <= rightBoundary;

    return colisionHorizontal;
  }

  void isAnyDoorNear(double playerX) {
    state = state.copyWith(
      doors: state.doors.map(
        (door) {
          return door.copyWith(
            currentState: isPlayerColliding(playerX, door)
                ? DoorStates.open
                : DoorStates.close,
          );
        },
      ).toList(),
    );
  }
}

final doorProvider = StateNotifierProvider<DoorNotifier, DoorState>((ref) {
  return DoorNotifier(ref);
});

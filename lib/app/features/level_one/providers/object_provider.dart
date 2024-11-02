import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';

final objectProvider =
    StateNotifierProvider<ObjectNotifier, ObjectState>((ref) {
  return ObjectNotifier(ref);
});

class ObjectNotifier extends StateNotifier<ObjectState> {
  ObjectNotifier(this.ref) : super(ObjectState()) {
    // Solo escuchamos los cambios del fondo
    ref.listen(backgroundProvider, (previous, next) {
      _updatePosition(previous, next);
    });
  }
  final Ref ref;

  void _updatePosition(BackgroundState? previous, BackgroundState current) {
    if (previous == null) return;

    // Calculamos cuánto se movió el fondo
    double backgroundMovement =
        current.initialPosition - previous.initialPosition;

    if (backgroundMovement != 0) {
      // El objeto se mueve en dirección opuesta al fondo
      double objectMovement = backgroundMovement * state.objectSpeed * -1;

      state = state.copyWith(
        positionX: state.positionX + objectMovement,
        currentDirection: objectMovement > 0
            ? Directions.right
            : Directions.left,
      );
    }
  }

  // Método para modificar la velocidad del objeto
  void setObjectSpeed(double newSpeed) {
    state = state.copyWith(objectSpeed: newSpeed);
  }
}

class ObjectState {
  final double positionX;
  final double positionY;
  final Directions currentDirection;
  final double objectSpeed;

  ObjectState({
    this.positionX = 200,
    this.positionY = 60,
    this.currentDirection = Directions.right,
    this.objectSpeed = 0.2, // Misma velocidad que el jugador por defecto
  });

  ObjectState copyWith({
    double? positionX,
    double? positionY,
    Directions? currentDirection,
    double? objectSpeed,
  }) {
    return ObjectState(
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      currentDirection: currentDirection ?? this.currentDirection,
      objectSpeed: objectSpeed ?? this.objectSpeed,
    );
  }
}
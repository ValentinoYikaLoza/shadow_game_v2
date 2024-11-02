import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

final objectProvider = StateNotifierProvider<ObjectNotifier, ObjectState>((ref) {
  return ObjectNotifier(ref);
});

class ObjectNotifier extends StateNotifier<ObjectState> {
  ObjectNotifier(this.ref) : super(ObjectState()) {
    // Escuchar cambios en la posición del jugador para actualizar la visibilidad del objeto
    ref.listen(playerProvider, (previous, next) {
      updateVisibility(next.positionX, next.positionY);
    });
  }

  final Ref ref;

  void updateVisibility(double playerX, double playerY) {
    // Calcular la distancia entre el jugador y el objeto
    final distance = sqrt(pow(state.positionX - playerX, 2) + pow(state.positionY - playerY, 2));

    // Ajustar la opacidad en función de la distancia (cuanto más cerca, más opaco)
    const visibilityThreshold = 200.0; // Distancia máxima para visibilidad completa
    double opacity = 1 - (distance / visibilityThreshold).clamp(0.0, 1.0);

    // Actualizar el estado del objeto con la nueva opacidad
    state = state.copyWith(opacity: opacity);
  }
}

class ObjectState {
  final double positionX;
  final double positionY;
  final double opacity;

  ObjectState({
    this.positionX = 300, // Posición inicial del objeto
    this.positionY = 60,
    this.opacity = 0.0,   // Opacidad inicial del objeto (invisible)
  });

  ObjectState copyWith({
    double? positionX,
    double? positionY,
    double? opacity,
  }) {
    return ObjectState(
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      opacity: opacity ?? this.opacity,
    );
  }
}

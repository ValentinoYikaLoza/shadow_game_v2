import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref) : super(PlayerState());
  final Ref ref;
  Timer? _jumpTimer;
  Timer? _fallTimer;

  void jump() {
    if (!state.isJumping) {
      state = state.copyWith(
        isJumping: true,
        currentState: PlayerStates.jump,
      );

      _jumpTimer?.cancel();
      _jumpTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (state.positionY <= 105) {
          state = state.copyWith(
            positionY: state.positionY + 5,
          );
        } else {
          timer.cancel();
          _startFalling();
        }
      });
    }
  }

  void _startFalling() {
    _fallTimer?.cancel();
    _fallTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (state.positionY >= 90) {
        state = state.copyWith(
          positionY: state.positionY - 5,
        );
      } else {
        timer.cancel();
        land();
      }
    });
  }

  void land() {
    state = state.copyWith(
      isJumping: false,
      currentState: PlayerStates.stay,
    );
  }

  void attack(){
    state = state.copyWith(
      currentState: PlayerStates.attack,
    );
  }

  // Definimos los límites del jugador en la pantalla
  static const double leftBoundary = 20.0;

  void moveRight(double rightBoundary) {
    final distanciaRecorrida = state.moveAmount * state.playerSpeed;

    if (state.positionX < rightBoundary / 1.5) {
      // Si no ha llegado al límite derecho, movemos al jugador
      state = state.copyWith(
        positionX: state.positionX + distanciaRecorrida,
        currentDirection: Directions.right,
        currentState: !state.isJumping ? PlayerStates.walk : state.currentState,
      );
    } else {
      // Si está en el límite derecho, movemos el fondo
      state = state.copyWith(
        skyPosition: state.skyPosition - distanciaRecorrida,
        groundPosition: state.groundPosition - distanciaRecorrida,
        currentDirection: Directions.right,
        currentState: !state.isJumping ? PlayerStates.walk : state.currentState,
      );
    }

    ref.read(backgroundProvider.notifier).updateXCoords(distanciaRecorrida);
  }

  void moveLeft() {
    final distanciaRecorrida = -state.moveAmount * state.playerSpeed;

    // Verificar si se puede mover a la izquierda
    if (!ref
        .read(backgroundProvider.notifier)
        .canMoveLeft(distanciaRecorrida)) {
      return; // Si no se puede mover, salimos de la función
    }

    if (state.positionX > leftBoundary) {
      // Si no ha llegado al límite izquierdo, movemos al jugador
      state = state.copyWith(
        positionX: state.positionX + distanciaRecorrida,
        currentDirection: Directions.left,
        currentState: !state.isJumping ? PlayerStates.walk : state.currentState,
      );
    } else {
      // Si está en el límite izquierdo, movemos el fondo
      state = state.copyWith(
        skyPosition: state.skyPosition - distanciaRecorrida,
        groundPosition: state.groundPosition - distanciaRecorrida,
        currentDirection: Directions.left,
        currentState: !state.isJumping ? PlayerStates.walk : state.currentState,
      );
    }

    ref.read(backgroundProvider.notifier).updateXCoords(distanciaRecorrida);
  }

  void stopMoving() {
    if (!state.isJumping) {
      state = state.copyWith(
        currentState: PlayerStates.stay,
      );
    }
  }
}

class PlayerState {
  final double skyPosition;
  final double groundPosition;
  final double positionX;
  final double positionY;
  final bool isJumping;
  final Directions currentDirection;
  final PlayerStates currentState;
  final double moveAmount;
  final double playerSpeed;

  PlayerState({
    this.skyPosition = 0,
    this.groundPosition = 0,
    this.positionX = 20,
    this.positionY = 85,
    this.isJumping = false,
    this.currentDirection = Directions.right,
    this.currentState = PlayerStates.stay,
    this.moveAmount = 10,
    this.playerSpeed = 0.2,
  });

  PlayerState copyWith({
    double? skyPosition,
    double? groundPosition,
    double? positionX,
    double? positionY,
    bool? isJumping,
    Directions? currentDirection,
    PlayerStates? currentState,
    double? moveAmount,
    double? playerSpeed,
  }) {
    return PlayerState(
      skyPosition: skyPosition ?? this.skyPosition,
      groundPosition: groundPosition ?? this.groundPosition,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      isJumping: isJumping ?? this.isJumping,
      currentDirection: currentDirection ?? this.currentDirection,
      currentState: currentState ?? this.currentState,
      moveAmount: moveAmount ?? this.moveAmount,
      playerSpeed: playerSpeed ?? this.playerSpeed,
    );
  }
}


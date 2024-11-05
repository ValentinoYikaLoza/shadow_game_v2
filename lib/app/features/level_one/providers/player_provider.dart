import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/shadow_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider_provider.dart';

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref) : super(PlayerState());
  final Ref ref;
  Timer? _jumpTimer;
  Timer? _fallTimer;

  Timer? _inactivityTimer;

  // Duración de tiempo para considerar inactividad
  static const inactivityDuration = Duration(minutes: 5);

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(inactivityDuration, () {
      dance(); // Llama a dance si pasa el tiempo sin actividad
    });
  }

  void resetInactivityTimer() {
    _startInactivityTimer();
  }

  void jump() {
    resetInactivityTimer();
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
    resetInactivityTimer();
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
    resetInactivityTimer();
    state = state.copyWith(
      isJumping: false,
      currentState: PlayerStates.stay,
    );
  }

  void dance() {
    state = state.copyWith(
      currentState: PlayerStates.dance,
    );
  }

  // Definimos los límites del jugador en la pantalla
  static const double leftBoundary = 20.0;

  void moveRight(double rightBoundary) {
    resetInactivityTimer();
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
      ref.read(doorProvider.notifier).updateXCoords(-distanciaRecorrida);
      ref.read(chestProvider.notifier).updateXCoords(-distanciaRecorrida);
      ref.read(spiderProvider.notifier).updateXCoords(-distanciaRecorrida);
    }
    ref.read(backgroundProvider.notifier).updateXCoords(distanciaRecorrida);
    checkCollisionsFirstDoor();
    checkCollisionsFirstChest();
    checkCollisionsFirstSpider();
  }

  void moveLeft() {
    resetInactivityTimer();
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
      ref.read(doorProvider.notifier).updateXCoords(-distanciaRecorrida);
      ref.read(chestProvider.notifier).updateXCoords(-distanciaRecorrida);
      ref.read(spiderProvider.notifier).updateXCoords(-distanciaRecorrida);
    }

    ref.read(backgroundProvider.notifier).updateXCoords(distanciaRecorrida);
    checkCollisionsFirstDoor();
    checkCollisionsFirstChest();
    checkCollisionsFirstSpider();
  }

  void stopMoving() {
    resetInactivityTimer();
    if (!state.isJumping) {
      state = state.copyWith(
        currentState: PlayerStates.stay,
      );
    }
    checkCollisionsFirstDoor();
    checkCollisionsFirstChest();
    checkCollisionsFirstSpider();
  }

  void checkCollisionsFirstDoor() {
    final isColliding =
        ref.read(doorProvider.notifier).isPlayerColliding(state.positionX);

    if (isColliding) {
      ref.read(doorProvider.notifier).openDoor();
    } else {
      ref.read(doorProvider.notifier).closeDoor();
    }
  }

  void checkCollisionsFirstChest() {
    final isColliding =
        ref.read(chestProvider.notifier).isPlayerColliding(state.positionX);

    if (isColliding) {
      ref.read(chestProvider.notifier).openChest();
    } else {
      ref.read(chestProvider.notifier).closeChest();
    }
  }

  void checkCollisionsFirstSpider() {
    final isColliding =
        ref.read(spiderProvider.notifier).isPlayerColliding(state.positionX);

    if (isColliding) {
      ref.read(spiderProvider.notifier).changeState(SpiderStates.attack);
      state = state.copyWith(
        moveAmount: 0,
        playerSpeed: 0,
      );
      ref.read(dogProvider.notifier).help();
    } else {
      state = state.copyWith(
        moveAmount: 10,
        playerSpeed: 0.2,
      );
    }
  }

  void changeState(PlayerStates newState) {
    state = state.copyWith(
      currentState: newState,
    );
  }

  void takeDamage(double damage) {
    if (state.isInvulnerable || !state.isAlive) return;

    final newHealth = state.health - damage;
    if (newHealth <= 0) {
      die();
    } else {
      state = state.copyWith(
        health: newHealth,
        isInvulnerable: true,
      );

      // Invulnerability period after taking damage
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          state = state.copyWith(isInvulnerable: false);
        }
      });

      // Return to normal state after hurt animation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          state = state.copyWith(currentState: PlayerStates.stay);
        }
      });
    }
  }

  void die() {
    state = state.copyWith(
      health: 0,
      isAlive: false,
      moveAmount: 0,
      playerSpeed: 0,
    );
    // You might want to trigger game over screen or restart mechanism here
  }

  void heal(double amount) {
    if (!state.isAlive) return;

    final double newHealth = (state.health + amount).clamp(0, state.maxHealth);
    state = state.copyWith(health: newHealth);
  }

  void attack() {
    if (!state.isAlive) return;

    resetInactivityTimer();
    state = state.copyWith(
      currentState: PlayerStates.attack,
    );

    // Check if spider is in range and deal damage
    final spiderNotifier = ref.read(spiderProvider.notifier);
    if (spiderNotifier.isPlayerColliding(state.positionX)) {
      spiderNotifier.takeDamage(state.attackDamage);
    }

    ref.read(dogProvider.notifier).changeState(ShadowStates.bark);
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
  final double health;
  final double maxHealth;
  final double attackDamage;
  final bool isInvulnerable;
  final bool isAlive;

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
    this.health = 10,
    this.maxHealth = 10,
    this.attackDamage = 20,
    this.isInvulnerable = false,
    this.isAlive = true,
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
    double? health,
    double? maxHealth,
    double? attackDamage,
    bool? isInvulnerable,
    bool? isAlive,
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
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      attackDamage: attackDamage ?? this.attackDamage,
      isInvulnerable: isInvulnerable ?? this.isInvulnerable,
      isAlive: isAlive ?? this.isAlive,
    );
  }
}

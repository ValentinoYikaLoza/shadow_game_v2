import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/shadow_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider2_provider.dart';
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
      // ref.read(spiderProvider.notifier).updateXCoords(-distanciaRecorrida);
    }
    ref.read(backgroundProvider.notifier).updateXCoords(distanciaRecorrida);
    checkCollisionsFirstDoor();
    checkCollisionsFirstChest();
    checkCollisionsSpiders();
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
      // ref.read(spiderProvider.notifier).updateXCoords(-distanciaRecorrida);
    }

    ref.read(backgroundProvider.notifier).updateXCoords(distanciaRecorrida);
    checkCollisionsFirstDoor();
    checkCollisionsFirstChest();
    checkCollisionsSpiders();
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
    checkCollisionsSpiders();
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

  void checkCollisionsSpiders() {
    ref.read(spider2Provider.notifier).isAnySpiderNear(state.positionX);
    final spidersIndex = ref.read(spider2Provider);

    if (spidersIndex.spiders
        .where(
          (spider) {
            return spider.currentState == SpiderStates.walk ||
                spider.currentState == SpiderStates.attack;
          },
        )
        .toList()
        .isNotEmpty) {
      // ref.read(spiderProvider.notifier).changeState(SpiderStates.attack);
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
    state = state.copyWith(
      health: state.health - damage,
    );
    if (state.health > 0) {
      print('jugador: ${state.health}');
    } else {
      print('jugador: muelto');
    }
  }

  void die() {}

  void attack() {
    resetInactivityTimer();
    state = state.copyWith(
      currentState: PlayerStates.attack,
    );

    ref.read(spider2Provider.notifier).takeDamage(state.attackDamage);

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
    this.attackDamage = 2,
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
    );
  }
}

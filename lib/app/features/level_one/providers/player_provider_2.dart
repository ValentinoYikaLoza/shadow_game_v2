import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/coin_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/dog_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider_provider.dart';

enum PlayerStatus { playing, tutorial, gameOver }

class PlayerState {
  final double xCoords;
  final double yCoords;
  final double currentLives;
  final double maxLives;
  final double damage;
  final double damageResistance;
  final double coins;
  final double speed;
  final PlayerStatus currentStatus;
  final PlayerStates currentState;
  final Directions currentDirection;
  final bool isBetweenTheLimits;
  final bool isJumping;

  PlayerState({
    required this.maxLives,
    required this.currentLives,
    required this.currentStatus,
    this.currentState = PlayerStates.stay,
    this.currentDirection = Directions.right,
    this.xCoords = 20.0,
    this.yCoords = 0.0,
    this.damage = 1,
    this.damageResistance = 0.1,
    this.coins = 0,
    this.speed = 0.2,
    this.isBetweenTheLimits = false,
    this.isJumping = false,
  });

  PlayerState copyWith({
    double? maxLives,
    double? xCoords,
    double? yCoords,
    double? currentLives,
    double? damage,
    double? damageResistance,
    double? coins,
    double? speed,
    PlayerStatus? currentStatus,
    PlayerStates? currentState,
    Directions? currentDirection,
    bool? isBetweenTheLimits,
    bool? isJumping,
  }) {
    return PlayerState(
      maxLives: maxLives ?? this.maxLives,
      xCoords: xCoords ?? this.xCoords,
      yCoords: yCoords ?? this.yCoords,
      currentLives: currentLives ?? this.currentLives,
      damage: damage ?? this.damage,
      damageResistance: damageResistance ?? this.damageResistance,
      coins: coins ?? this.coins,
      speed: speed ?? this.speed,
      currentStatus: currentStatus ?? this.currentStatus,
      currentState: currentState ?? this.currentState,
      currentDirection: currentDirection ?? this.currentDirection,
      isBetweenTheLimits: isBetweenTheLimits ?? this.isBetweenTheLimits,
      isJumping: isJumping ?? this.isJumping,
    );
  }
}

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier(this.ref)
      : super(PlayerState(
            maxLives: 10,
            currentLives: 10,
            currentStatus: PlayerStatus.playing));

  final Ref ref;

  Timer? _jumpTimer;
  Timer? _fallTimer;
  Timer? _inactivityTimer;

  static const inactivityDuration = Duration(seconds: 5);
  static const leftLimit = 20.0;
  static const deltaX = 10.0;

  void resetData() {
    state = PlayerState(
        maxLives: 10, currentLives: 10, currentStatus: PlayerStatus.playing);
    ref.read(doorProvider.notifier).resetData();
    ref.read(coinProvider.notifier).resetData();
    ref.read(chestProvider.notifier).resetData();
    ref
        .read(spiderProvider.notifier)
        .resetData(state.currentStatus == PlayerStatus.tutorial);
    ref.read(dogProvider.notifier).resetData();
  }

  void startInactivityTimer() {
    stopInactivityTimer();
    _inactivityTimer = Timer(inactivityDuration, () {
      dance();
    });
  }

  void stopInactivityTimer() {
    _inactivityTimer?.cancel();
  }

  void resetInactivityTimer() {
    startInactivityTimer();
  }

  void updateLives(double newLives) {
    state = state.copyWith(currentLives: newLives);
  }

  void updateMaxLives(double newMaxLives) {
    if (state.maxLives == state.currentLives) {
      updateLives(newMaxLives);
    }
    state = state.copyWith(maxLives: newMaxLives);
  }

  void updateCoins(double newCoins) {
    state = state.copyWith(coins: newCoins);
  }

  void updateSpeed(double newSpeed) {
    state = state.copyWith(speed: newSpeed);
  }

  void updateDamage(double newDamage) {
    state = state.copyWith(damage: newDamage);
  }

  void updateDamageResistance(double newDamageResistance) {
    state = state.copyWith(damageResistance: newDamageResistance);
  }

  void updateCoords(double xCoords, double yCoords) {
    if (!state.isBetweenTheLimits) return;

    state = state.copyWith(xCoords: xCoords, yCoords: yCoords);
  }

  void updateStatus(PlayerStatus newStatus) {
    state = state.copyWith(currentStatus: newStatus);
  }

  void updateState(PlayerStates newState) {
    state = state.copyWith(currentState: newState);
  }

  void updateDirection(Directions newDirection) {
    state = state.copyWith(currentDirection: newDirection);
  }

  void updateFlagIsBetweenTheLimits(bool isBetweenTheLimits) {
    state = state.copyWith(isBetweenTheLimits: isBetweenTheLimits);
  }

  void updateFlagIsJumping(bool isJumping) {
    state = state.copyWith(isJumping: isJumping);
  }

  void tutorialMode() {
    updateStatus(PlayerStatus.tutorial);
  }

  void gameOver() {
    updateStatus(PlayerStatus.gameOver);
  }

  void takeDamage(double damage) {
    if (state.currentStatus == PlayerStatus.tutorial) return;
    final random = Random();
    debugPrint(random.toString());
    if (random.nextDouble() > state.damageResistance) {
      final newLives = state.currentLives - damage;
      updateLives(newLives);
      if (newLives <= 0) {
        gameOver();
      }
    }
  }

  void addCoins(double coins) {
    final newCoins = state.coins + coins;
    updateCoins(newCoins);
  }

  void attack() {
    resetInactivityTimer();
    updateState(PlayerStates.attack);
    ref.read(spiderProvider.notifier).takeDamage(state.damage);
  }

  void jump() {
    resetInactivityTimer();
    if (state.isJumping) return;

    state = state.copyWith(
      isJumping: true,
      currentState: PlayerStates.jump,
    );

    _jumpTimer?.cancel();
    _jumpTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (state.yCoords <= 25) {
        state = state.copyWith(yCoords: state.yCoords + 5);
      } else {
        timer.cancel();
        _startFalling();
      }
    });
  }

  void _startFalling() {
    resetInactivityTimer();
    _fallTimer?.cancel();
    _fallTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (state.yCoords >= 5) {
        state = state.copyWith(yCoords: state.yCoords - 5);
      } else {
        timer.cancel();
        _land();
      }
    });
  }

  void _land() {
    resetInactivityTimer();
    state = state.copyWith(
      isJumping: false,
      currentState: PlayerStates.stay,
    );
  }

  void dance() {
    updateState(PlayerStates.dance);
  }

  void move() {
    resetInactivityTimer();
    ref.read(dogProvider.notifier).followPlayer(state.xCoords);
    updateState(PlayerStates.walk);
  }

  void stopMovement() {
    resetInactivityTimer();
    updateState(PlayerStates.stay);
  }

  void moveLeft() {
    final distance = -deltaX * state.speed;

    state.xCoords > leftLimit
        ? updateFlagIsBetweenTheLimits(true)
        : updateFlagIsBetweenTheLimits(false);

    final newPosition = state.xCoords + distance;

    updateDirection(Directions.left);
    updateCoordsOfEnviromentsEntities(distance);
    checkCollisions();
    updateCoords(newPosition, state.yCoords);
    move();
  }

  void moveRight(double rightLimit) {
    final distance = deltaX * state.speed;

    state.xCoords < rightLimit
        ? updateFlagIsBetweenTheLimits(true)
        : updateFlagIsBetweenTheLimits(false);

    final newPosition = state.xCoords + distance;

    updateCoords(newPosition, state.yCoords);
    updateCoordsOfEnviromentsEntities(distance);
    checkCollisions();
    updateDirection(Directions.right);
    move();
  }

  void updateCoordsOfEnviromentsEntities(double distance) {
    if (state.currentStatus == PlayerStatus.tutorial) return;
    ref.read(doorProvider.notifier).updateXCoords(distance);
    ref.read(coinProvider.notifier).updateXCoords(distance);
    ref.read(chestProvider.notifier).updateXCoords(distance);
    ref.read(spiderProvider.notifier).updateXCoords(distance);
    ref.read(backgroundProvider.notifier).updateXCoords(distance);
  }

  void checkCollisions() {
    checkCollisionsDoors();
    checkCollisionsCoins();
    checkCollisionsChests();
    checkCollisionsSpiders();
  }

  void checkCollisionsDoors() {
    ref.read(doorProvider.notifier).isAnyDoorNear(state.xCoords);
  }

  void checkCollisionsCoins() {
    ref.read(coinProvider.notifier).isAnyCoinNear(state.xCoords);
  }

  void checkCollisionsChests() {
    ref.read(chestProvider.notifier).isAnyChestNear(state.xCoords);
  }

  void checkCollisionsSpiders() {
    //! Refactorizar
    ref.read(spiderProvider.notifier).isAnySpiderNear(state.xCoords);

    final spiders = ref.read(spiderProvider).spiders;

    final isSpiderNear = spiders.any((spider) =>
        spider.currentState == SpiderStates.walk ||
        spider.currentState == SpiderStates.attack);

    state = state.copyWith(
      speed: isSpiderNear ? 0 : 0.2,
    );

    ref.read(dogProvider.notifier).goAwayFromEnemy(state.xCoords, isSpiderNear);
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});

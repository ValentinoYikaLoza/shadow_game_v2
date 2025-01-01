import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/coin_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider_provider.dart';

enum PlayerStatus { playing, tutorial, gameOver }

class PlayerState {
  final double positionX;
  final double positionY;
  final double currentLives;
  final double maxLives;
  final double damage;
  final double damageResistance;
  final double coins;
  final double speed;
  final PlayerStatus currentStatus;
  final PlayerStates currentState;
  final Directions currentDirection;
  final bool isMoving;

  PlayerState({
    required this.maxLives,
    required this.currentLives,
    required this.currentStatus,
    this.currentState = PlayerStates.stay,
    this.currentDirection = Directions.right,
    this.positionX = 20.0,
    this.positionY = 0.0,
    this.damage = 1,
    this.damageResistance = 0.1,
    this.coins = 10,
    this.speed = 0.2,
    this.isMoving = false,
  });

  PlayerState copyWith({
    double? maxLives,
    double? positionX,
    double? positionY,
    double? currentLives,
    double? damage,
    double? damageResistance,
    double? coins,
    double? speed,
    PlayerStatus? currentStatus,
    PlayerStates? currentState,
    Directions? currentDirection,
    bool? isMoving,
  }) {
    return PlayerState(
      maxLives: maxLives ?? this.maxLives,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      currentLives: currentLives ?? this.currentLives,
      damage: damage ?? this.damage,
      damageResistance: damageResistance ?? this.damageResistance,
      coins: coins ?? this.coins,
      speed: speed ?? this.speed,
      currentStatus: currentStatus ?? this.currentStatus,
      currentState: currentState ?? this.currentState,
      currentDirection: currentDirection ?? this.currentDirection,
      isMoving: isMoving ?? this.isMoving,
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
  Timer? _inactivityTimer;

  static const inactivityDuration = Duration(seconds: 5);
  static const leftLimit = 20.0;
  static const deltaX = 10.0;

  void resetData() {
    state = PlayerState(
        maxLives: 10, currentLives: 10, currentStatus: PlayerStatus.playing);
  }

  void startInactivityTimer() {
    stopInactivityTimer();
    _inactivityTimer = Timer(inactivityDuration, () {
      //! TODO: Implement inactivity logic
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

  void updatePosition(double x, double y) {
    if (!state.isMoving) return;

    state = state.copyWith(positionX: x, positionY: y);
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

  void updateFlagIsMoving(bool isMoving) {
    state = state.copyWith(isMoving: isMoving);
  }

  void tutorialMode() {
    updateStatus(PlayerStatus.tutorial);
  }

  void gameOver() {
    updateStatus(PlayerStatus.gameOver);
  }

  void takeDamage(double damage) {
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

  void move() {
    resetInactivityTimer();
    updateState(PlayerStates.walk);
    // debugPrint('moving');
  }

  void stopMovement() {
    resetInactivityTimer();
    updateState(PlayerStates.stay);
  }

  void moveLeft() {
    final distance = -deltaX * state.speed;

    state.positionX > leftLimit
        ? updateFlagIsMoving(true)
        : updateFlagIsMoving(false);

    final newPosition = state.positionX + distance;

    updateDirection(Directions.left);
    updateCoordsOfEnviromentsEntities(distance);
    checkCollisions();
    updatePosition(newPosition, state.positionY);
    move();
  }

  void moveRight(double rightLimit) {
    final distance = deltaX * state.speed;

    state.positionX < rightLimit
        ? updateFlagIsMoving(true)
        : updateFlagIsMoving(false);

    final newPosition = state.positionX + distance;

    updatePosition(newPosition, state.positionY);
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
    ref.read(doorProvider.notifier).isAnyDoorNear(state.positionX);
  }

  void checkCollisionsCoins() {
    ref.read(coinProvider.notifier).isAnyCoinNear(state.positionX);
  }

  void checkCollisionsChests() {
    ref.read(chestProvider.notifier).isAnyChestNear(state.positionX);
  }

  void checkCollisionsSpiders() {
    //! Refactorizar
    ref.read(spiderProvider.notifier).isAnySpiderNear(state.positionX);

    final spiders = ref.read(spiderProvider).spiders;

    final isSpiderNear = spiders.any((spider) =>
        spider.currentState == SpiderStates.walk ||
        spider.currentState == SpiderStates.attack);

    state = state.copyWith(
      speed: isSpiderNear ? 0 : 0.2,
    );
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});

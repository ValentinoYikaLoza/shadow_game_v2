import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

final spider2Provider =
    StateNotifierProvider<Spider2Notifier, SpiderState>((ref) {
  return Spider2Notifier(ref);
});

class Spider2Notifier extends StateNotifier<SpiderState> {
  Spider2Notifier(this.ref) : super(SpiderState());

  final Ref ref;
  Timer? moveTimer;
  Timer? disapearTimer;

  void addSpider() {
    state = state.copyWith(
      spiders: [...state.spiders, Spider()],
    );
    startMoving();
  }

  bool isPlayerColliding(double playerX, Spider spider) {
    // Define el área de colisión del objeto
    final objectLeft = spider.initialPosition - (spider.width / 2);
    final objectRight = spider.initialPosition + (spider.width / 2);

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

  void startMoving() {
    moveTimer?.cancel();
    moveTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final playerState = ref.read(playerProvider);
      state = state.copyWith(
        spiders: state.spiders.map((spider) {
          if (spider.currentState == SpiderStates.walk) {
            if (spider.initialPosition < playerState.positionX + 50) {
              return spider.copyWith(
                currentState: SpiderStates.attack,
              );
            } else {
              return spider.copyWith(
                initialPosition: spider.initialPosition - 5,
              );
            }
          }
          return spider;
        }).toList(),
      );
    });
  }

  void isAnySpiderNear(double playerX) {
    state = state.copyWith(
      spiders: state.spiders.map(
        (spider) {
          if (isPlayerColliding(playerX, spider)) {
            // followPlayer(spider);
            return spider.copyWith(
              currentState: SpiderStates.walk,
              currentDirection: Directions.left,
            );
          }
          return spider;
        },
      ).toList(),
    );
  }

  void takeDamage(double damage) {
    state = state.copyWith(
        spiders: state.spiders.map((spider) {
      if (spider.currentState == SpiderStates.attack) {
        final newHealth = spider.health - damage;

        return spider.copyWith(
          health: newHealth,
          currentState: newHealth <= 0 ? SpiderStates.die : SpiderStates.attack,
        );
      }
      return spider;
    }).toList());
  }
}

class SpiderState {
  final List<Spider> spiders;

  SpiderState({
    this.spiders = const [],
  });

  SpiderState copyWith({
    List<Spider>? spiders,
  }) {
    return SpiderState(
      spiders: spiders ?? this.spiders,
    );
  }
}

class Spider {
  final double initialPosition;
  final SpiderStates currentState;
  final Directions currentDirection;
  final double width;
  final double health;
  final double maxHealth;
  final double attackDamage;

  Spider({
    this.initialPosition = 500,
    this.currentState = SpiderStates.stay,
    this.currentDirection = Directions.left,
    this.width = 300,
    this.health = 5,
    this.maxHealth = 5,
    this.attackDamage = 1,
  });

  Spider copyWith({
    double? initialPosition,
    SpiderStates? currentState,
    Directions? currentDirection,
    double? width,
    double? health,
    double? maxHealth,
    double? attackDamage,
  }) {
    return Spider(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      currentDirection: currentDirection ?? this.currentDirection,
      width: width ?? this.width,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      attackDamage: attackDamage ?? this.attackDamage,
    );
  }
}

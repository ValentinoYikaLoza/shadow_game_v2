import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/door_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

final spiderProvider =
    StateNotifierProvider<SpiderNotifier, SpiderState>((ref) {
  return SpiderNotifier(ref);
});

class SpiderNotifier extends StateNotifier<SpiderState> {
  SpiderNotifier(this.ref) : super(SpiderState());

  final Ref ref;
  Timer? moveTimer;
  Timer? disapearTimer;

  void addSpider({double initialPosition = 500}) {
    state = state.copyWith(
      spiders: state.spiders.length <= state.maxSpiders - 1
          ? [
              ...state.spiders,
              Spider(
                initialPosition: initialPosition,
                attackDamage:
                    state.spiders.length == state.maxSpiders - 1 ? 3 : 1,
                health: state.spiders.length == state.maxSpiders - 1 ? 10 : 5,
                maxHealth:
                    state.spiders.length == state.maxSpiders - 1 ? 10 : 5,
              )
            ]
          : state.spiders,
    );
    // print('araña ${state.spiders.length} x:$initialPosition');
    startMoving();
  }

  // void killSpider(Spider spider) {
  //   state.spiders.remove(spider);
  // }

  void updateXCoords(double distanciaRecorrida) {
    state = state.copyWith(
        spiders: state.spiders.map((spider) {
      final newPosition = spider.initialPosition + distanciaRecorrida;

      return spider.copyWith(
        initialPosition: newPosition.roundToDouble(),
      );
    }).toList());
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
              currentState: spider.currentState == SpiderStates.die
                  ? SpiderStates.die
                  : SpiderStates.walk,
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

        if (newHealth <= 0) {
          if (state.spiders.indexOf(spider) == state.maxSpiders - 1) {
            Future.delayed(const Duration(seconds: 2), () {
              ref
                  .read(chestProvider.notifier)
                  .addChest(initialPosition: spider.initialPosition + 50);
              ref.read(doorProvider.notifier).addDoor(
                    initialPosition: spider.initialPosition + 150,
                    doorType: DoorType.finish,
                  );
            });
          }

          if (state.spiders.indexOf(spider) < state.maxSpiders) {
            Future.delayed(const Duration(seconds: 2), () {
              ref
                  .read(chestProvider.notifier)
                  .addChest(initialPosition: spider.initialPosition + 50);
              addSpider(
                  initialPosition: spider.initialPosition +
                      (spider.initialPosition +
                          Random().nextDouble() *
                              (1500 - spider.initialPosition)));
            });
          }
        }

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
  final int maxSpiders;

  SpiderState({
    this.spiders = const [],
    this.maxSpiders = 2,
  });

  SpiderState copyWith({
    List<Spider>? spiders,
    int? maxSpiders,
  }) {
    return SpiderState(
      spiders: spiders ?? this.spiders,
      maxSpiders: maxSpiders ?? this.maxSpiders,
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

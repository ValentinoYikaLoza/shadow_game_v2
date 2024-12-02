import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';

final chestProvider = StateNotifierProvider<ChestNotifier, ChestState>((ref) {
  return ChestNotifier(ref);
});

class ChestNotifier extends StateNotifier<ChestState> {
  ChestNotifier(this.ref) : super(ChestState());
  final Ref ref;

  void addChest({double initialPosition = 600}) {
    // print('cofre en x:$initialPosition');
    state = state.copyWith(
      chests: [...state.chests, Chest(initialPosition: initialPosition)],
    );
  }

  void updateXCoords(double distanciaRecorrida) {
    state = state.copyWith(
        chests: state.chests.map((chest) {
      final newPosition = chest.initialPosition + distanciaRecorrida;

      return chest.copyWith(
        initialPosition: newPosition.roundToDouble(),
      );
    }).toList());
  }

  bool isPlayerColliding(double playerX, Chest chest) {
    // Define el área de colisión del objeto
    final objectLeft = chest.initialPosition - (chest.width / 2);
    final objectRight = chest.initialPosition + (chest.width / 2);

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

  void isAnyChestNear(double playerX) {
    state = state.copyWith(
      chests: state.chests.map(
        (chest) {
          if (isPlayerColliding(playerX, chest)) {
            // followPlayer(spider);
            return chest.copyWith(
              currentState: ChestStates.open,
            );
          }
          return chest;
        },
      ).toList(),
    );
  }
}

class ChestState {
  final List<Chest> chests;

  ChestState({
    this.chests = const [],
  });

  ChestState copyWith({
    List<Chest>? chests,
  }) {
    return ChestState(
      chests: chests ?? this.chests,
    );
  }
}

class Chest {
  final double initialPosition;
  final ChestStates currentState;
  final double width;
  Chest({
    this.initialPosition = 600,
    this.currentState = ChestStates.close,
    this.width = 60,
  });

  Chest copyWith({
    double? initialPosition,
    ChestStates? currentState,
    double? width,
  }) {
    return Chest(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      width: width ?? this.width,
    );
  }
}

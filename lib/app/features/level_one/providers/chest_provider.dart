import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/coin_provider.dart';

final chestProvider = StateNotifierProvider<ChestNotifier, ChestState>((ref) {
  return ChestNotifier(ref);
});

class ChestNotifier extends StateNotifier<ChestState> {
  ChestNotifier(this.ref) : super(ChestState());
  final Ref ref;

  /// Restablece el estado de las arañas
  void resetData() {
    state = ChestState(); // Restaura el estado inicial
  }

  void addChest({double initialPosition = 600, double coinValue = 1}) {
    state = state.copyWith(
      chests: [
        ...state.chests,
        Chest(initialPosition: initialPosition, coinValue: coinValue)
      ],
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
            // // Imprime el índice del cofre y su estado de coinDropped
            // print('Cofre índice: ${state.chests.indexOf(chest)}, '
            //     'coinDropped: ${chest.coinDropped}, '
            //     'Estado actual: ${chest.currentState}, '
            //     'total cofres: ${state.chests.length}');

            // Si el cofre está cerrado, ábrelo
            if (chest.currentState == ChestStates.close) {
              return chest.copyWith(
                currentState: ChestStates.open,
              );
            }

            // Si el cofre está abierto y aún no ha soltado moneda
            if (chest.currentState == ChestStates.open && !chest.coinDropped) {
              // Añadir moneda en la posición del cofre
              ref.read(coinProvider.notifier).addCoin(
                  initialPosition: chest.initialPosition + 50,
                  coinValue: chest.coinValue);
              return chest.copyWith(
                coinDropped: true,
              );
            }
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
  final bool coinDropped;
  final double coinValue;
  final double width;

  Chest({
    this.initialPosition = 600,
    this.currentState = ChestStates.close,
    this.coinDropped = false,
    this.coinValue = 1,
    this.width = 60,
  });

  Chest copyWith({
    double? initialPosition,
    ChestStates? currentState,
    bool? coinDropped,
    double? coinValue,
    double? width,
  }) {
    return Chest(
      initialPosition: initialPosition ?? this.initialPosition,
      currentState: currentState ?? this.currentState,
      coinDropped: coinDropped ?? this.coinDropped,
      coinValue: coinValue ?? this.coinValue,
      width: width ?? this.width,
    );
  }
}

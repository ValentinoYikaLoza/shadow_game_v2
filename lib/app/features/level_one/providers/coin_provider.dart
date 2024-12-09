import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';

final coinProvider = StateNotifierProvider<CoinNotifier, CoinState>((ref) {
  return CoinNotifier(ref);
});

class CoinNotifier extends StateNotifier<CoinState> {
  CoinNotifier(this.ref) : super(CoinState());
  final Ref ref;

  /// Restablece el estado de las arañas
  void resetData() {
    state = CoinState(); // Restaura el estado inicial
  }

  void addCoin({double initialPosition = 600, double coinValue = 1}) {
    state = state.copyWith(
      coins: [
        ...state.coins,
        Coin(initialPosition: initialPosition, coinValue: coinValue)
      ],
    );
  }

  void updateXCoords(double distanciaRecorrida) {
    state = state.copyWith(
        coins: state.coins.map((coin) {
      final newPosition = coin.initialPosition + distanciaRecorrida;

      return coin.copyWith(
        initialPosition: newPosition.roundToDouble(),
      );
    }).toList());
  }

  bool isPlayerColliding(double playerX, Coin coin) {
    // Define el área de colisión del objeto
    final objectLeft = coin.initialPosition - (coin.width / 2);
    final objectRight = coin.initialPosition + (coin.width / 2);

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

  void isAnyCoinNear(double playerX) {
    state = state.copyWith(
      coins: state.coins.map(
        (coin) {
          if (isPlayerColliding(playerX, coin)) {
            // print('coin índice: ${state.coins.indexOf(coin)}, '
            //     'coinCollected: ${coin.coinCollected}, '
            //     'Total coins: ${state.coins.length}');

            if (!coin.coinCollected) {
              ref.read(playerProvider.notifier).getCoin(coin.coinValue);
            }

            return coin.copyWith(
              coinCollected: true,
            );
          }
          return coin;
        },
      ).toList(),
    );
  }
}

class CoinState {
  final List<Coin> coins;

  CoinState({
    this.coins = const [],
  });

  CoinState copyWith({
    List<Coin>? coins,
  }) {
    return CoinState(
      coins: coins ?? this.coins,
    );
  }
}

class Coin {
  final double initialPosition;
  final bool coinCollected;
  final double coinValue;
  final double width;

  Coin({
    this.initialPosition = 600,
    this.coinCollected = false,
    this.coinValue = 1,
    this.width = 5,
  });

  Coin copyWith({
    double? initialPosition,
    bool? coinCollected,
    double? coinValue,
    double? width,
  }) {
    return Coin(
      initialPosition: initialPosition ?? this.initialPosition,
      coinCollected: coinCollected ?? this.coinCollected,
      coinValue: coinValue ?? this.coinValue,
      width: width ?? this.width,
    );
  }
}

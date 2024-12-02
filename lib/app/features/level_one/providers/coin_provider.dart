import 'package:flutter_riverpod/flutter_riverpod.dart';

final coinProvider = StateNotifierProvider<CoinNotifier, CoinState>((ref) {
  return CoinNotifier(ref);
});

class CoinNotifier extends StateNotifier<CoinState> {
  CoinNotifier(this.ref) : super(CoinState());
  final Ref ref;

  void addCoin({double initialPosition = 600, CoinType coinType = CoinType.uncollected}) {
    // print('cofre en x:$initialPosition');
    state = state.copyWith(
      coins: [...state.coins, Coin(initialPosition: initialPosition, coinType: coinType)],
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
            return coin.copyWith(
              coinType: CoinType.collected, // New state to trigger jump
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
  final CoinType coinType;
  final double width;

  Coin({
    this.initialPosition = 600,
    this.coinType = CoinType.uncollected,
    this.width = 5,
  });

  Coin copyWith({
    double? initialPosition,
    CoinType? coinType,
    double? width,
  }) {
    return Coin(
      initialPosition: initialPosition ?? this.initialPosition,
      coinType: coinType ?? this.coinType,
      width: width ?? this.width,
    );
  }
}

enum CoinType {
  collected,
  uncollected,
}
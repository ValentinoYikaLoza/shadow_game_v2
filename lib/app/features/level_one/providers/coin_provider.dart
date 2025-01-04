import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';

// import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider_2.dart';

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
  final double xCoords;
  final bool isCoinCollected;
  final double coinValue;
  final double width;

  Coin({
    this.xCoords = 600,
    this.isCoinCollected = false,
    this.coinValue = 1,
    this.width = 5,
  });

  Coin copyWith({
    double? xCoords,
    bool? isCoinCollected,
    double? coinValue,
    double? width,
  }) {
    return Coin(
      xCoords: xCoords ?? this.xCoords,
      isCoinCollected: isCoinCollected ?? this.isCoinCollected,
      coinValue: coinValue ?? this.coinValue,
      width: width ?? this.width,
    );
  }
}

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
        Coin(xCoords: initialPosition, coinValue: coinValue)
      ],
    );
  }

  void updateXCoords(double distance) {
    state = state.copyWith(
        coins: state.coins.map((coin) {
      
      final newPosition = coin.xCoords - distance;

      if (canMove()) return coin;

      if (!canMoveLeft(distance) || !canMoveRight(distance)) return coin;

      return coin.copyWith(
        xCoords: newPosition,
      );
    }).toList());
  }

  bool canMove() {
    final playerState = ref.read(playerProvider);
    return playerState.isBetweenTheLimits;
  }

  bool canMoveLeft(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveLeft(distance);
  }

  bool canMoveRight(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveRight(distance);
  }

  bool isPlayerColliding(double playerX, Coin coin) {
    final leftBoundary = coin.xCoords;
    final rightBoundary = coin.xCoords + coin.width;

    const playerWidth = 50.0;
    final playerLeftBoundary = playerX;
    final playerRightBoundary = playerX + (playerWidth / 2);

    bool colisionHorizontal = playerRightBoundary >= leftBoundary &&
        playerLeftBoundary <= rightBoundary;

    return colisionHorizontal;
  }

  void isAnyCoinNear(double playerX) {
    state = state.copyWith(
      coins: state.coins.map((coin) {
        if (isPlayerColliding(playerX, coin) && !coin.isCoinCollected) {
          ref.read(playerProvider.notifier).addCoins(coin.coinValue);
          return coin.copyWith(isCoinCollected: true);
        }
        return coin;
      }).toList(),
    );
  }
}

final coinProvider = StateNotifierProvider<CoinNotifier, CoinState>((ref) {
  return CoinNotifier(ref);
});

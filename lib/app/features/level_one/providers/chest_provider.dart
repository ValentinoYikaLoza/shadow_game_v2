import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/background_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/coin_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider_2.dart';

class Chest {
  final double xCoords;
  final ChestStates currentState;
  final bool hasCoin;
  final double coinValue;
  final double width;

  Chest({
    this.xCoords = 600,
    this.currentState = ChestStates.close,
    this.hasCoin = false,
    this.coinValue = 1,
    this.width = 60,
  });

  Chest copyWith({
    double? xCoords,
    ChestStates? currentState,
    bool? hasCoin,
    double? coinValue,
    double? width,
  }) {
    return Chest(
      xCoords: xCoords ?? this.xCoords,
      currentState: currentState ?? this.currentState,
      hasCoin: hasCoin ?? this.hasCoin,
      coinValue: coinValue ?? this.coinValue,
      width: width ?? this.width,
    );
  }
}

class ChestNotifier extends StateNotifier<ChestState> {
  ChestNotifier(this.ref) : super(ChestState());
  final Ref ref;

  /// Restablece el estado de las arañas
  void resetData() {
    state = ChestState(); // Restaura el estado inicial
  }

  void addChest({double xCoords = 600, double coinValue = 1}) {
    state = state.copyWith(
      chests: [...state.chests, Chest(xCoords: xCoords, coinValue: coinValue)],
    );
  }

  void updateXCoords(double distance) {
    state = state.copyWith(
        chests: state.chests.map((chest) {
      final newPosition = chest.xCoords - distance;

      if (canMove()) return chest;

      if (!canMoveLeft(distance) || !canMoveRight(distance)) return chest;

      return chest.copyWith(
        xCoords: newPosition,
      );
    }).toList());
  }

  bool canMove() {
    final playerState = ref.read(playerProvider);
    return playerState.isMoving;
  }

  bool canMoveLeft(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveLeft(distance);
  }

  bool canMoveRight(double distance) {
    final backgroundState = ref.read(backgroundProvider.notifier);
    return backgroundState.canMoveRight(distance);
  }

  bool isPlayerColliding(double playerX, Chest chest) {
    final leftBoundary = chest.xCoords;
    final rightBoundary = chest.xCoords + chest.width;

    const playerWidth = 50.0;
    final playerLeftBoundary = playerX;
    final playerRightBoundary = playerX + (playerWidth / 2);

    bool colisionHorizontal = playerRightBoundary >= leftBoundary &&
        playerLeftBoundary <= rightBoundary;

    return colisionHorizontal;
  }

  void isAnyChestNear(double playerX) {
    state = state.copyWith(
      chests: state.chests.map((chest) {
        if (!isPlayerColliding(playerX, chest)) return chest;

        if (chest.currentState == ChestStates.open && !chest.hasCoin) {
          _dropCoin(chest);
          return chest.copyWith(hasCoin: true);
        }

        return chest.copyWith(currentState: ChestStates.open);
      }).toList(),
    );
  }

  void _dropCoin(Chest chest) {
    ref.read(coinProvider.notifier).addCoin(
      initialPosition: chest.xCoords + 50,
      coinValue: chest.coinValue,
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

final chestProvider = StateNotifierProvider<ChestNotifier, ChestState>((ref) {
  return ChestNotifier(ref);
});

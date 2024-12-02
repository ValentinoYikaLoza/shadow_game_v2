import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/coin_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/characters_animation.dart';

class CoinWidget extends ConsumerStatefulWidget {
  final Coin coin;
  const CoinWidget({super.key, required this.coin});

  @override
  CoinWidgetState createState() => CoinWidgetState();
}

class CoinWidgetState extends ConsumerState<CoinWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomGif(
      images: CoinStates.waiting.images,
      width: 28,
      loop: false,
      onComplete: () {
        if (widget.coin.coinType != CoinType.uncollected) {
          ref.read(playerProvider.notifier).getCoin(1);
          widget.coin.copyWith(
            coinType: CoinType.collected
          );
        }
      },
    );
  }
}

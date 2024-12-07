import 'package:flutter/widgets.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/coin_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/characters_animation.dart';

class CoinWidget extends StatelessWidget {
  final Coin coin;
  const CoinWidget({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return CustomGif(
      images: CoinStates.waiting.images,
      width: 28,
      loop: true, // Si la moneda necesita animación constante
    );
  }
}

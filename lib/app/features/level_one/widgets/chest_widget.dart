import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/coin_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/characters_animation.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/coin_widget.dart';

class ChestWidget extends ConsumerStatefulWidget {
  final Chest chest;
  final bool isBoss;
  const ChestWidget({
    super.key,
    required this.chest,
    this.isBoss = false,
  });

  @override
  ChestWidgetState createState() => ChestWidgetState();
}

class ChestWidgetState extends ConsumerState<ChestWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _jumpController;
  late Animation<double> _positionAnimation;
  bool isJumping = false;

  @override
  void initState() {
    super.initState();
    _jumpController = AnimationController(
      duration: const Duration(milliseconds: 950),
      vsync: this,
    );

    _positionAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 100, end: 180),
        weight: 0.4,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 180, end: 85),
        weight: 0.6,
      ),
    ]).animate(CurvedAnimation(
      parent: _jumpController,
      curve: Curves.easeInOut,
    ));

    _jumpController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isJumping = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChestWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.chest.currentState == ChestStates.open &&
        oldWidget.chest.currentState != ChestStates.open) {
      setState(() {
        isJumping = true;
        _jumpController.forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coinState = ref.watch(coinProvider);
    return Stack(
      children: [
        Positioned(
          bottom: 78,
          left: widget.chest.initialPosition,
          child: CustomGif(
            images: widget.chest.currentState.images,
            width: 65,
            loop: false,
          ),
        ),
        if (widget.chest.currentState != ChestStates.close)
          ...List.generate(
            coinState.coins.length,
            (index) {
              final coin = coinState.coins[index];
              return AnimatedBuilder(
                animation: _positionAnimation,
                builder: (context, child) {
                  // print(widget.chest.currentState);
                  return Positioned(
                    bottom: _positionAnimation.value,
                    left:
                        widget.chest.initialPosition + (widget.chest.width / 2),
                    child: child!,
                  );
                },
                child: CoinWidget(
                  coin: coin,
                ),
              );
            },
          ),
      ],
    );
  }
}

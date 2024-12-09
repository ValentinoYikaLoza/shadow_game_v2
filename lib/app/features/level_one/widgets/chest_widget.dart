import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/coin_provider.dart';
import 'package:shadow_game_v2/app/features/shared/widgets/custom_gif.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/coin_widget.dart';

class ChestWidget extends ConsumerStatefulWidget {
  final Chest chest;
  final bool isBoss;
  final double groundHeight;
  const ChestWidget({
    super.key,
    required this.chest,
    required this.groundHeight,
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
  int lastCoinCount = 0;

  @override
  void initState() {
    super.initState();
    _jumpController = AnimationController(
      duration: const Duration(milliseconds: 950),
      vsync: this,
    );

    _positionAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.groundHeight + 15, end: widget.groundHeight + 95),
        weight: 0.4,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.groundHeight + 95, end: widget.groundHeight),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    lastCoinCount = ref.read(coinProvider).coins.length;
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

    final currentCoinCount = ref.watch(coinProvider).coins.length;
    if (currentCoinCount > lastCoinCount) {
      // Reinicia la animación cuando hay una nueva moneda
      _jumpController.reset();
      _jumpController.forward();
    }

    lastCoinCount = currentCoinCount; // Actualiza el conteo de monedas
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coins = ref.watch(coinProvider).coins;
    return Stack(
      children: [
        Positioned(
          bottom: widget.groundHeight,
          left: widget.chest.initialPosition,
          child: CustomGif(
            images: widget.chest.currentState.images,
            width: 65,
            loop: false,
          ),
        ),
        // Coins
        ...coins.where((coin) => !coin.coinCollected).map(
              (coin) => AnimatedBuilder(
                animation: _positionAnimation,
                builder: (context, child) {
                  return Positioned(
                    bottom: _positionAnimation.value,
                    left: coin.initialPosition,
                    child: child!,
                  );
                },
                child: CoinWidget(
                  coin: coin,
                ),
              ),
            ),
      ],
    );
  }
}

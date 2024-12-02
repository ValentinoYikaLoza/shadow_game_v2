import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/widgets/characters_animation.dart';

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
  Timer? disappearTimer;
  double opacity = 1;
  bool isJumping = false;

  initOpacity() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        disappearTimer = Timer.periodic(
          const Duration(milliseconds: 50),
          (timer) {
            final newOpacity = opacity - 0.1;
            if (newOpacity <= 0) {
              setState(() {
                opacity = 0;
                disappearTimer!.cancel();
              });
            } else {
              setState(() {
                opacity = newOpacity;
              });
            }
          },
        );
      });
    });
  }

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

    // Trigger jump animation when chest opens
    if (widget.chest.currentState == ChestStates.open &&
        oldWidget.chest.currentState != ChestStates.open) {
      setState(() {
        isJumping = true;
        _jumpController.forward(from: 0);
      });
      initOpacity();
    }
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 85,
          left: widget.chest.initialPosition,
          child: SizedBox(
            width: 60,
            child: Image.asset(
              widget.chest.currentState.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (widget.chest.currentState == ChestStates.open)
          AnimatedBuilder(
            animation: _positionAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: _positionAnimation.value,
                left: widget.chest.initialPosition + (widget.chest.width / 2),
                child: Opacity(
                  opacity: opacity,
                  child: child!,
                ),
              );
            },
            child: CustomGif(
              images: CoinStates.hidden.images,
              width: 28,
              loop: false,
              onComplete: () {
                setState(() {
                  print('hola');
                  ref
                      .read(playerProvider.notifier)
                      .getCoin(!widget.isBoss ? 1 : 5);
                });
              },
            ),
          ),
      ],
    );
  }
}

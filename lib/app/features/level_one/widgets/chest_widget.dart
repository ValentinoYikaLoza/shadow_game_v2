// import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/chest_provider.dart';

class ChestWidget extends ConsumerStatefulWidget {
  final Chest chest;
  const ChestWidget({
    super.key,
    required this.chest,
  });

  @override
  ChestWidgetState createState() => ChestWidgetState();
}

class ChestWidgetState extends ConsumerState<ChestWidget> {
  // Timer? appearTimer;
  double opacity = 1; // Cambiamos el estado inicial a 0

  // void initOpacity() {
  //   Future.delayed(const Duration(seconds: 2), () {
  //     setState(() {
  //       appearTimer = Timer.periodic(
  //         const Duration(milliseconds: 50),
  //         (timer) {
  //           final newOpacity = opacity + 0.1; // Incrementamos la opacidad
  //           if (newOpacity >= 1) {
  //             // Condición para detener la animación
  //             setState(() {
  //               opacity = 1;
  //               appearTimer!.cancel();
  //             });
  //           } else {
  //             setState(() {
  //               opacity = newOpacity;
  //             });
  //           }
  //         },
  //       );
  //     });
  //   });
  // }

  // @override
  // void didUpdateWidget(covariant ChestWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.chest.currentState == ChestStates.close &&
  //       oldWidget.chest.currentState != ChestStates.close) {
  //     initOpacity();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 85,
      left: widget.chest.initialPosition,
      child: Opacity(
        opacity: opacity,
        child: SizedBox(
          width: 60,
          child: Image.asset(
            widget.chest.currentState.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

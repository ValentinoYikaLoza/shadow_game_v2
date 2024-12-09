import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game_v2/app/features/level_one/models/data.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/player_provider.dart';
import 'package:shadow_game_v2/app/features/level_one/providers/spider_provider.dart';

class Gestures extends ConsumerStatefulWidget {
  final Widget child;
  const Gestures({
    super.key,
    required this.child,
  });

  @override
  GesturesState createState() => GesturesState();
}

class GesturesState extends ConsumerState<Gestures> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    final spiderState = ref.watch(spiderProvider);

    return Stack(
      children: [
        widget.child,
        Row(
          children: [
            // Zona izquierda
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    !spiderState.spiders
                            .where(
                              (spider) {
                                return spider.currentState ==
                                        SpiderStates.walk ||
                                    spider.currentState == SpiderStates.attack;
                              },
                            )
                            .toList()
                            .isNotEmpty
                        ? ref.read(playerProvider.notifier).moveLeft()
                        : null;
                  });
                },
                onLongPress: () {
                  setState(() {
                    !spiderState.spiders
                            .where(
                              (spider) {
                                return spider.currentState ==
                                        SpiderStates.walk ||
                                    spider.currentState == SpiderStates.attack;
                              },
                            )
                            .toList()
                            .isNotEmpty
                        ? ref.read(playerProvider.notifier).moveLeft()
                        : null;
                  });
                },
                onLongPressDown: (_) {
                  setState(() {
                    !spiderState.spiders
                            .where(
                              (spider) {
                                return spider.currentState ==
                                        SpiderStates.walk ||
                                    spider.currentState == SpiderStates.attack;
                              },
                            )
                            .toList()
                            .isNotEmpty
                        ? ref.read(playerProvider.notifier).moveLeft()
                        : null;
                  });
                },
                onLongPressMoveUpdate: (_) {
                  setState(() {
                    !spiderState.spiders
                            .where(
                              (spider) {
                                return spider.currentState ==
                                        SpiderStates.walk ||
                                    spider.currentState == SpiderStates.attack;
                              },
                            )
                            .toList()
                            .isNotEmpty
                        ? ref.read(playerProvider.notifier).moveLeft()
                        : null;
                  });
                },
                onLongPressEnd: (_) {
                  setState(() {
                    ref.read(playerProvider.notifier).stopMoving();
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    ref.read(playerProvider.notifier).stopMoving();
                  });
                },
                onVerticalDragUpdate: (_) {
                  setState(() {
                    ref.read(playerProvider.notifier).jump();
                  });
                },
                child: Container(
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
            ),
            // Zona derecha
            Expanded(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    !spiderState.spiders
                            .where(
                              (spider) {
                                return spider.currentState ==
                                        SpiderStates.walk ||
                                    spider.currentState == SpiderStates.attack;
                              },
                            )
                            .toList()
                            .isNotEmpty
                        ? ref
                            .read(playerProvider.notifier)
                            .moveRight(screen.size.width - 70)
                        : null;
                  });
                },
                onLongPress: () {
                  setState(() {
                    !spiderState.spiders
                            .where(
                              (spider) {
                                return spider.currentState ==
                                        SpiderStates.walk ||
                                    spider.currentState == SpiderStates.attack;
                              },
                            )
                            .toList()
                            .isNotEmpty
                        ? ref
                            .read(playerProvider.notifier)
                            .moveRight(screen.size.width - 70)
                        : null;
                  });
                },
                onLongPressDown: (_) {
                  setState(() {
                    !spiderState.spiders
                            .where(
                              (spider) {
                                return spider.currentState ==
                                        SpiderStates.walk ||
                                    spider.currentState == SpiderStates.attack;
                              },
                            )
                            .toList()
                            .isNotEmpty
                        ? ref
                            .read(playerProvider.notifier)
                            .moveRight(screen.size.width - 70)
                        : null;
                  });
                },
                onLongPressMoveUpdate: (_) {
                  setState(() {
                    !spiderState.spiders
                            .where(
                              (spider) {
                                return spider.currentState ==
                                        SpiderStates.walk ||
                                    spider.currentState == SpiderStates.attack;
                              },
                            )
                            .toList()
                            .isNotEmpty
                        ? ref
                            .read(playerProvider.notifier)
                            .moveRight(screen.size.width - 70)
                        : null;
                  });
                },
                onLongPressEnd: (_) {
                  setState(() {
                    ref.read(playerProvider.notifier).stopMoving();
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    ref.read(playerProvider.notifier).stopMoving();
                  });
                },
                onVerticalDragUpdate: (_) {
                  setState(() {
                    ref.read(playerProvider.notifier).jump();
                  });
                },
                child: Container(
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

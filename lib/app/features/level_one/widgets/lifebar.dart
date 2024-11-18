import 'package:flutter/material.dart';

class Lifebar extends StatelessWidget {
  final double totalHearts;
  final double fullHearts;
  const Lifebar({
    super.key,
    required this.totalHearts,
    required this.fullHearts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.5,
      width: 22.5 * totalHearts,
      child: Stack(
        children: List.generate(totalHearts.toInt(), (index) {
          double offset =
              index * 22.5; // Desplazamiento para que se superpongan

          Widget heart = (index < fullHearts)
              ? SizedBox(
                  width: 19.5,
                  child: Image.asset(
                    'assets/icons/life.png',
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(
                  width: 19.5,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      'assets/icons/life.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                );

          return Positioned(
            left: offset, // Desplazamiento para superponer los corazones
            child: heart,
          );
        }),
      ),
    );
  }
}

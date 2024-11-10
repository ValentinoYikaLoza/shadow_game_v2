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
      height: 50,
      width: 20 * totalHearts,
      child: Stack(
        children: List.generate(totalHearts.toInt(), (index) {
          double offset =
              index * 18.0; // Desplazamiento para que se superpongan

          Widget heart = (index < fullHearts)
              ? SizedBox(
                  width: 40,
                  child: Image.asset(
                    'assets/icons/life.png',
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(
                  width: 40,
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

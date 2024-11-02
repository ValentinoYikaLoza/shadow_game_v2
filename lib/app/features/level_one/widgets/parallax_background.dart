import 'package:flutter/material.dart';

class ParallaxBackground extends StatelessWidget {
  final String imagePath;
  final double position;
  final double speed;
  
  const ParallaxBackground({
    super.key,
    required this.imagePath,
    required this.position,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular cuántas imágenes necesitamos para cubrir la pantalla
        final imageWidth = constraints.maxWidth;
        final count = (constraints.maxWidth / imageWidth).ceil() + 2;

        return Stack(
          children: List.generate(count, (index) {
            // Calcular la posición real teniendo en cuenta el scroll infinito
            double actualPosition = position % imageWidth;
            double xPosition =
                (index * imageWidth + actualPosition) - imageWidth;

            return Positioned(
              left: xPosition,
              child: Image.asset(
                imagePath,
                width: imageWidth,
                height: constraints.maxHeight,
                fit: BoxFit.cover,
              ),
            );
          }),
        );
      },
    );
  }
}
